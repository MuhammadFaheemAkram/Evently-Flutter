import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/network/dto/booking_dto.dart';
import 'package:evently/core/network/dto/catalog_dto.dart';
import 'package:evently/core/network/dto/demo_user_dto.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/features/welcome/cubit/welcome_cubit.dart';
import 'package:evently/features/welcome/cubit/welcome_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/fakes/scripted_evently_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  WelcomeCubit cubitOn(DataStack dataStack) {
    stack = dataStack;
    addTearDown(stack.close);
    return WelcomeCubit(
      stack.refreshCatalog,
      stack.listCities,
      stack.startWithDemo,
      stack.startFresh,
    );
  }

  const cities = ['Berlin', 'Lahore', 'London', 'New York'];
  const ready = WelcomeState(catalog: CatalogStatus.ready, cities: cities);

  blocTest<WelcomeCubit, WelcomeState>(
    'loads the catalog, then offers its cities',
    build: () => cubitOn(DataStack()),
    act: (cubit) => cubit.loadCatalog(),
    // The first emit counts even though it equals the initial state.
    expect: () => const [WelcomeState(), ready],
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'an offline catalog says why, and Try again recovers',
    build: () => cubitOn(
      DataStack(
        api: (real) =>
            ScriptedEventlyApi(real, catalog: [const NetworkException()]),
      ),
    ),
    act: (cubit) async {
      await cubit.loadCatalog();
      (stack.api as ScriptedEventlyApi).recover();
      await cubit.loadCatalog();
    },
    expect: () => [
      const WelcomeState(),
      WelcomeState(
        catalog: CatalogStatus.failed,
        errorMessage: const NetworkException().message,
      ),
      const WelcomeState(),
      ready,
    ],
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'nothing can be chosen or started before the catalog is ready',
    build: () => cubitOn(DataStack()),
    act: (cubit) async {
      cubit.selectCity('London');
      await cubit.exploreDemo();
      await cubit.startFresh();
    },
    expect: () => const <WelcomeState>[],
    verify: (_) => expect(stack.settings.writes, 0),
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'the demo with a city: a spinner, then done (the router takes it from '
    'there)',
    build: () => cubitOn(DataStack()),
    act: (cubit) async {
      await cubit.loadCatalog();
      cubit.selectCity('London');
      await cubit.exploreDemo();
    },
    skip: 2,
    expect: () => [
      ready.copyWith(city: 'London'),
      ready.copyWith(city: 'London', starting: StartChoice.demo),
      ready.copyWith(city: 'London'),
    ],
    verify: (_) async {
      expect(
        stack.settings.current,
        const AppSettings(onboarded: true, preferredCity: 'London'),
      );
      final user = await stack.db.userDataDao.readAll();
      expect(user.tickets, hasLength(4));
    },
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'a failed demo says why, and Try again recovers',
    build: () => cubitOn(
      DataStack(
        api: (real) =>
            ScriptedEventlyApi(real, demoUser: [const NetworkException()]),
      ),
    ),
    act: (cubit) async {
      await cubit.loadCatalog();
      await cubit.exploreDemo();
      expect(stack.settings.writes, 0);
      (stack.api as ScriptedEventlyApi).recover();
      await cubit.exploreDemo();
    },
    skip: 2,
    expect: () => [
      ready.copyWith(starting: StartChoice.demo),
      ready.copyWith(errorMessage: const NetworkException().message),
      ready.copyWith(starting: StartChoice.demo),
      ready,
    ],
    verify: (_) => expect(stack.settings.current.onboarded, isTrue),
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'start fresh, Anywhere: no user data',
    build: () => cubitOn(DataStack()),
    act: (cubit) async {
      await cubit.loadCatalog();
      await cubit.startFresh();
    },
    skip: 2,
    expect: () => [ready.copyWith(starting: StartChoice.fresh), ready],
    verify: (_) async {
      expect(stack.settings.current, const AppSettings(onboarded: true));
      final user = await stack.db.userDataDao.readAll();
      expect(user.tickets, isEmpty);
      expect(user.profile, isNull);
    },
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'start fresh in a city: the city is saved',
    build: () => cubitOn(DataStack()),
    act: (cubit) async {
      await cubit.loadCatalog();
      cubit.selectCity('Berlin');
      await cubit.startFresh();
    },
    verify: (_) => expect(
      stack.settings.current,
      const AppSettings(onboarded: true, preferredCity: 'Berlin'),
    ),
  );

  test('a second tap while starting does nothing', () async {
    final gate = Completer<void>();
    final cubit = cubitOn(DataStack(api: (real) => _GatedApi(real, gate)));
    addTearDown(cubit.close);
    await cubit.loadCatalog();

    final first = cubit.exploreDemo();
    await cubit.exploreDemo();
    await cubit.startFresh();
    cubit.selectCity('Berlin');
    expect((stack.api as _GatedApi).demoCalls, 1);
    expect(cubit.state.city, isNull);
    expect(stack.settings.writes, 0);

    gate.complete();
    await first;
    expect(stack.settings.writes, 1);
  });

  test('a second load while one runs does nothing', () async {
    final cubit = cubitOn(DataStack());
    addTearDown(cubit.close);

    await Future.wait([cubit.loadCatalog(), cubit.loadCatalog()]);
    await cubit.loadCatalog();

    expect(cubit.state, ready);
  });
}

/// Holds every demo fetch until [gate] completes.
class _GatedApi implements EventlyApi {
  _GatedApi(this.real, this.gate);

  final EventlyApi real;
  final Completer<void> gate;
  var demoCalls = 0;

  @override
  Future<CatalogDto> fetchCatalog() => real.fetchCatalog();

  @override
  Future<BookingDto> rsvp(RsvpRequestDto request) => real.rsvp(request);

  @override
  Future<EventDto> cancelRsvp(CancelRequestDto request) =>
      real.cancelRsvp(request);

  @override
  Future<DemoUserDto> fetchDemoUser() async {
    demoCalls++;
    await gate.future;
    return real.fetchDemoUser();
  }
}
