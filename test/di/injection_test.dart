import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/platform/local_notifications.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/model/device_info.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/domain/service/notification_scheduler.dart';
import 'package:evently/domain/usecase/background_use_cases.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:evently/features/agenda/cubit/agenda_cubit.dart';
import 'package:evently/features/discover/cubit/discover_cubit.dart';
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart';
import 'package:evently/features/following/cubit/following_cubit.dart';
import 'package:evently/features/organizer/cubit/organizer_cubit.dart';
import 'package:evently/features/profile/cubit/profile_cubit.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_cubit.dart';
import 'package:evently/features/rsvp/cubit/rsvp_cubit.dart';
import 'package:evently/features/saved/cubit/saved_cubit.dart';
import 'package:evently/features/search/bloc/search_bloc.dart';
import 'package:evently/features/settings/cubit/settings_cubit.dart';
import 'package:evently/features/settings/cubit/settings_tools_cubit.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_cubit.dart';
import 'package:evently/features/tickets/cubit/tickets_cubit.dart';
import 'package:evently/features/welcome/cubit/welcome_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(getIt.reset);

  // A smoke test of the real composition root. A dependency injectable can't
  // resolve only fails when its type is first resolved, at runtime; resolving
  // the top of each graph here catches it in CI. Every new Cubit, repository
  // and service belongs here.
  test('the real container resolves the app-wide singletons and the '
      'Cubits', () async {
    await configureTestDependencies();

    expect(getIt<SettingsRepository>(), same(getIt<SettingsRepository>()));
    expect(getIt<WelcomeCubit>(), isNot(same(getIt<WelcomeCubit>())));
    expect(getIt<DiscoverCubit>(), isNot(same(getIt<DiscoverCubit>())));
    expect(getIt<EventDetailCubit>(), isA<EventDetailCubit>());
    expect(getIt<SearchBloc>(), isA<SearchBloc>());
    expect(getIt<SavedCubit>(), isA<SavedCubit>());
    expect(getIt<RsvpCubit>(), isA<RsvpCubit>());
    expect(getIt<TicketsCubit>(), isA<TicketsCubit>());
    expect(getIt<TicketDetailCubit>(), isA<TicketDetailCubit>());
    expect(getIt<AgendaCubit>(), isA<AgendaCubit>());
    expect(getIt<SettingsCubit>(), isA<SettingsCubit>());
    expect(getIt<SettingsToolsCubit>(), isA<SettingsToolsCubit>());
    expect(getIt<OrganizerCubit>(), isA<OrganizerCubit>());
    expect(getIt<FollowingCubit>(), isA<FollowingCubit>());
    expect(getIt<ProfileCubit>(), isA<ProfileCubit>());
    expect(getIt<ProfileEditCubit>(), isA<ProfileEditCubit>());
    expect(getIt<AppInfo>().versionLabel, '1.0.0 (1)');
    expect(getIt<EventlyApi>(), same(getIt<FakeEventlyApi>()));
    expect(getIt<EventClock>().local.name, 'Europe/London');
    expect(
      getIt<SyncNotificationsUseCase>(),
      same(getIt<SyncNotificationsUseCase>()),
    );
    expect(getIt<KeepNotificationsInSyncUseCase>(), isNotNull);
    expect(getIt<RunBackgroundSyncUseCase>(), isNotNull);
  });

  test('one plugin wrapper serves both notification roles', () async {
    // The test graph swaps the device for a fake: set its platform mocks
    // up, then build the real graph again over them.
    await configureTestDependencies();
    await getIt.reset();
    await configureDependencies();

    final plugin = getIt<LocalNotifications>();
    expect(getIt<NotificationScheduler>(), same(plugin));
    expect(getIt<NotificationInteractions>(), same(plugin));
  });
}
