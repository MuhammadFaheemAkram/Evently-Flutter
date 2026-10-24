import 'package:evently/core/common/app_exception.dart';
import 'package:evently/domain/calculation/rsvp_rules.dart';
import 'package:evently/domain/model/calendar_date.dart';
import 'package:evently/domain/model/event.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/features/discover/cubit/discover_cubit.dart';
import 'package:evently/features/discover/cubit/discover_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  DiscoverCubit cubitOn(DataStack dataStack) {
    stack = dataStack;
    addTearDown(stack.close);
    final cubit = DiscoverCubit(
      stack.watchEventCards,
      stack.watchSettings,
      stack.refreshCatalog,
      stack.setEventSaved,
      stack.eventClock,
    );
    addTearDown(cubit.close);
    return cubit;
  }

  Future<DiscoverState> ready(DiscoverCubit cubit) =>
      waitFor(cubit, (s) => s.status == DiscoverStatus.ready);

  List<String> ids(Iterable<EventCardItem> items) => [
    for (final item in items) item.event.id,
  ];

  Iterable<EventCardItem> upcomingOf(DiscoverState state) =>
      state.upcoming.expand((group) => group.items);

  test(
    'the cached demo: featured, coming up by day, no city section',
    () async {
      final cubit = cubitOn(DataStack());
      await stack.loadDemo();

      cubit.load();
      final state = await ready(cubit);

      expect(ids(state.featured), hasLength(5));
      expect(state.featured.first.event.id, 'ev_flutter_london_meetup');
      expect(state.inYourCity, isEmpty);
      expect(state.city, isNull);
      expect(state.today, CalendarDate(2026, 10, 21));
      expect(state.upcoming.first.day, CalendarDate(2026, 10, 21));
      // 25 events, 3 of them over.
      expect(upcomingOf(state), hasLength(22));
      expect(ids(upcomingOf(state)), isNot(contains('ev_accessibility_talk')));
    },
  );

  test('your city: its upcoming in-person events, and it follows the '
      'setting', () async {
    final cubit = cubitOn(DataStack());
    await stack.loadDemo();
    await stack.settings.update((s) => s.copyWith(preferredCity: 'London'));

    cubit.load();
    final london = await ready(cubit);
    expect(london.city, 'London');
    expect(ids(london.inYourCity), [
      'ev_flutter_london_meetup',
      'ev_thames_10k',
      'ev_hyde_park_cleanup',
      'ev_jazz_vaults',
      'ev_dart_workshop',
    ]);

    await stack.settings.update((s) => s.copyWith(preferredCity: 'Lahore'));
    final lahore = await waitFor(cubit, (s) => s.city == 'Lahore');
    expect(lahore.inYourCity, isNotEmpty);
    expect(
      lahore.inYourCity.every(
        (item) => switch (item.event.location) {
          Venue(:final city) => city == 'Lahore',
          Online() => false,
        },
      ),
      isTrue,
    );
  });

  test('a category filters what is coming up, "All" undoes it', () async {
    final cubit = cubitOn(DataStack());
    await stack.loadDemo();
    cubit.load();
    final all = await ready(cubit);

    cubit.selectCategory(EventCategory.music);
    final music = cubit.state;
    expect(upcomingOf(music), isNotEmpty);
    expect(
      upcomingOf(music).every((i) => i.event.category == EventCategory.music),
      isTrue,
    );
    expect(music.featured, all.featured);

    cubit.selectCategory(null);
    expect(upcomingOf(cubit.state), hasLength(upcomingOf(all).length));
  });

  test('an empty cache is filled first: loading, then the events', () async {
    final cubit = cubitOn(DataStack());

    cubit.load();
    await waitFor(cubit, (s) => s.status == DiscoverStatus.loading);
    final state = await ready(cubit);

    expect(upcomingOf(state), hasLength(22));
  });

  test('an empty cache offline: the error, and Try again recovers', () async {
    final cubit = cubitOn(
      DataStack(
        api: (real) =>
            ScriptedEventlyApi(real, catalog: [const NetworkException()]),
      ),
    );

    cubit.load();
    final failed = await waitFor(
      cubit,
      (s) => s.status == DiscoverStatus.failed,
    );
    expect(failed.errorMessage, const NetworkException().message);

    (stack.api as ScriptedEventlyApi).recover();
    await cubit.tryAgain();
    await ready(cubit);
  });

  test('pull to refresh offline keeps the events and says so', () async {
    final cubit = cubitOn(DataStack(api: (real) => ScriptedEventlyApi(real)));
    await stack.loadDemo();
    cubit.load();
    await ready(cubit);
    stack.network.failRequests = true;

    await cubit.refresh();

    expect(cubit.state.status, DiscoverStatus.ready);
    expect(cubit.state.message, DiscoverCubit.offlineMessage);
    expect(cubit.state.messageSerial, 1);
  });

  test('a successful refresh says nothing', () async {
    final cubit = cubitOn(DataStack());
    await stack.loadDemo();
    cubit.load();
    await ready(cubit);

    await cubit.refresh();

    expect(cubit.state.messageSerial, 0);
  });

  test('saving from a card shows in every list', () async {
    final cubit = cubitOn(DataStack());
    await stack.catalog.refresh();
    cubit.load();
    final before = await ready(cubit);
    final meetup = before.featured.first;
    expect(meetup.isSaved, isFalse);

    await cubit.toggleSaved(meetup);
    final after = await waitFor(cubit, (s) => s.featured.first.isSaved);

    expect(
      upcomingOf(after)
          .firstWhere((i) => i.event.id == meetup.event.id)
          .isSaved,
      isTrue,
    );

    await cubit.toggleSaved(after.featured.first);
    await waitFor(cubit, (s) => !s.featured.first.isSaved);
  });

  test('a save that fails says why', () async {
    final cubit = cubitOn(DataStack());
    await stack.catalog.refresh();
    cubit.load();
    final state = await ready(cubit);
    final ghost = state.featured.first.copyWith.event(id: 'ev_nowhere');

    await cubit.toggleSaved(ghost);

    expect(cubit.state.message, const UnknownException().message);
  });

  test('why each card can or can\'t be booked', () async {
    final cubit = cubitOn(DataStack());
    await stack.loadDemo();
    cubit.load();
    final state = await ready(cubit);
    RsvpBlock? blockOf(String id) => state.rsvpBlockFor(
      upcomingOf(state).firstWhere((i) => i.event.id == id),
    );

    expect(blockOf('ev_flutter_london_meetup'), RsvpBlock.going);
    expect(blockOf('ev_dart_workshop'), RsvpBlock.soldOut);
    expect(blockOf('ev_jazz_vaults'), isNull);
    expect(state.now, stack.eventClock.now());
  });
}
