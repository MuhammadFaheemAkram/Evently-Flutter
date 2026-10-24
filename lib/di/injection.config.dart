// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:clock/clock.dart' as _i454;
import 'package:evently/core/common/event_clock.dart' as _i805;
import 'package:evently/core/database/app_database.dart' as _i496;
import 'package:evently/core/database/daos/catalog_dao.dart' as _i601;
import 'package:evently/core/database/daos/events_dao.dart' as _i386;
import 'package:evently/core/database/daos/organizers_dao.dart' as _i900;
import 'package:evently/core/database/daos/profile_dao.dart' as _i144;
import 'package:evently/core/database/daos/recent_searches_dao.dart' as _i835;
import 'package:evently/core/database/daos/reminders_dao.dart' as _i627;
import 'package:evently/core/database/daos/saved_events_dao.dart' as _i794;
import 'package:evently/core/database/daos/session_bookmarks_dao.dart' as _i574;
import 'package:evently/core/database/daos/tickets_dao.dart' as _i4;
import 'package:evently/core/database/daos/user_data_dao.dart' as _i542;
import 'package:evently/core/network/asset_json_loader.dart' as _i1000;
import 'package:evently/core/network/demo_calendar.dart' as _i102;
import 'package:evently/core/network/evently_api.dart' as _i844;
import 'package:evently/core/network/fake_developer_tools.dart' as _i520;
import 'package:evently/core/network/fake_evently_api.dart' as _i796;
import 'package:evently/core/network/network_simulator.dart' as _i1024;
import 'package:evently/core/platform/local_notifications.dart' as _i280;
import 'package:evently/core/platform/material_you_color_source.dart' as _i711;
import 'package:evently/core/platform/url_launcher_link_opener.dart' as _i1051;
import 'package:evently/core/platform/workmanager_background_work.dart'
    as _i517;
import 'package:evently/core/storage/settings_local_data_source.dart' as _i327;
import 'package:evently/data/repository/booking_repository_impl.dart' as _i373;
import 'package:evently/data/repository/catalog_repository_impl.dart' as _i507;
import 'package:evently/data/repository/demo_repository_impl.dart' as _i936;
import 'package:evently/data/repository/organizer_repository_impl.dart'
    as _i793;
import 'package:evently/data/repository/profile_repository_impl.dart' as _i75;
import 'package:evently/data/repository/recent_searches_repository_impl.dart'
    as _i315;
import 'package:evently/data/repository/reminder_repository_impl.dart'
    as _i1044;
import 'package:evently/data/repository/saved_event_repository_impl.dart'
    as _i947;
import 'package:evently/data/repository/schedule_repository_impl.dart' as _i564;
import 'package:evently/data/repository/search_repository_impl.dart' as _i832;
import 'package:evently/data/repository/settings_repository_impl.dart' as _i5;
import 'package:evently/di/app_module.dart' as _i64;
import 'package:evently/domain/model/device_info.dart' as _i94;
import 'package:evently/domain/repository/booking_repository.dart' as _i435;
import 'package:evently/domain/repository/catalog_repository.dart' as _i521;
import 'package:evently/domain/repository/demo_repository.dart' as _i182;
import 'package:evently/domain/repository/organizer_repository.dart' as _i385;
import 'package:evently/domain/repository/profile_repository.dart' as _i156;
import 'package:evently/domain/repository/recent_searches_repository.dart'
    as _i107;
import 'package:evently/domain/repository/reminder_repository.dart' as _i297;
import 'package:evently/domain/repository/saved_event_repository.dart' as _i285;
import 'package:evently/domain/repository/schedule_repository.dart' as _i49;
import 'package:evently/domain/repository/search_repository.dart' as _i691;
import 'package:evently/domain/repository/settings_repository.dart' as _i233;
import 'package:evently/domain/service/background_work.dart' as _i175;
import 'package:evently/domain/service/developer_tools.dart' as _i405;
import 'package:evently/domain/service/dynamic_color_source.dart' as _i506;
import 'package:evently/domain/service/link_opener.dart' as _i216;
import 'package:evently/domain/service/notification_scheduler.dart' as _i819;
import 'package:evently/domain/usecase/background_use_cases.dart' as _i246;
import 'package:evently/domain/usecase/booking_use_cases.dart' as _i217;
import 'package:evently/domain/usecase/catalog_use_cases.dart' as _i997;
import 'package:evently/domain/usecase/event_use_cases.dart' as _i351;
import 'package:evently/domain/usecase/notification_use_cases.dart' as _i355;
import 'package:evently/domain/usecase/open_link_use_case.dart' as _i860;
import 'package:evently/domain/usecase/organizer_use_cases.dart' as _i148;
import 'package:evently/domain/usecase/profile_use_cases.dart' as _i112;
import 'package:evently/domain/usecase/schedule_use_cases.dart' as _i983;
import 'package:evently/domain/usecase/search_use_cases.dart' as _i626;
import 'package:evently/domain/usecase/settings_use_cases.dart' as _i27;
import 'package:evently/domain/usecase/start_use_cases.dart' as _i1009;
import 'package:evently/features/agenda/cubit/agenda_cubit.dart' as _i788;
import 'package:evently/features/discover/cubit/discover_cubit.dart' as _i664;
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart'
    as _i186;
import 'package:evently/features/following/cubit/following_cubit.dart' as _i514;
import 'package:evently/features/organizer/cubit/organizer_cubit.dart' as _i359;
import 'package:evently/features/profile/cubit/profile_cubit.dart' as _i550;
import 'package:evently/features/profile_edit/cubit/profile_edit_cubit.dart'
    as _i870;
import 'package:evently/features/rsvp/cubit/rsvp_cubit.dart' as _i655;
import 'package:evently/features/saved/cubit/saved_cubit.dart' as _i397;
import 'package:evently/features/search/bloc/search_bloc.dart' as _i820;
import 'package:evently/features/settings/cubit/settings_cubit.dart' as _i272;
import 'package:evently/features/settings/cubit/settings_tools_cubit.dart'
    as _i263;
import 'package:evently/features/ticket_detail/cubit/ticket_detail_cubit.dart'
    as _i648;
import 'package:evently/features/tickets/cubit/tickets_cubit.dart' as _i220;
import 'package:evently/features/welcome/cubit/welcome_cubit.dart' as _i321;
import 'package:flutter/services.dart' as _i281;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i1024.NetworkSimulator>(() => _i1024.NetworkSimulator());
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    gh.lazySingleton<_i454.Clock>(() => appModule.clock);
    gh.lazySingleton<_i496.AppDatabase>(() => appModule.appDatabase);
    await gh.lazySingletonAsync<_i460.SharedPreferencesWithCache>(
      () => appModule.preferences,
      preResolve: true,
    );
    await gh.lazySingletonAsync<_i805.DeviceTimeZone>(
      () => appModule.deviceTimeZone,
      preResolve: true,
    );
    gh.lazySingleton<_i280.LocalNotifications>(
      () => appModule.localNotifications,
    );
    await gh.lazySingletonAsync<_i94.AppInfo>(
      () => appModule.appInfo,
      preResolve: true,
    );
    gh.lazySingleton<_i601.CatalogDao>(
      () => appModule.catalogDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i542.UserDataDao>(
      () => appModule.userDataDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i386.EventsDao>(
      () => appModule.eventsDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i835.RecentSearchesDao>(
      () => appModule.recentSearchesDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i900.OrganizersDao>(
      () => appModule.organizersDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i144.ProfileDao>(
      () => appModule.profileDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i4.TicketsDao>(
      () => appModule.ticketsDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i574.SessionBookmarksDao>(
      () => appModule.sessionBookmarksDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i627.RemindersDao>(
      () => appModule.remindersDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i794.SavedEventsDao>(
      () => appModule.savedEventsDao(gh<_i496.AppDatabase>()),
    );
    gh.lazySingleton<_i49.ScheduleRepository>(
      () => _i564.ScheduleRepositoryImpl(
        gh<_i574.SessionBookmarksDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.lazySingleton<_i285.SavedEventRepository>(
      () => _i947.SavedEventRepositoryImpl(
        gh<_i794.SavedEventsDao>(),
        gh<_i386.EventsDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.lazySingleton<_i819.NotificationScheduler>(
      () => appModule.notificationScheduler(gh<_i280.LocalNotifications>()),
    );
    gh.lazySingleton<_i819.NotificationInteractions>(
      () => appModule.notificationInteractions(gh<_i280.LocalNotifications>()),
    );
    gh.lazySingleton<_i216.LinkOpener>(
      () => const _i1051.UrlLauncherLinkOpener(),
    );
    gh.lazySingleton<_i175.BackgroundWork>(
      () => const _i517.WorkmanagerBackgroundWork(),
    );
    gh.lazySingleton<_i297.ReminderRepository>(
      () => _i1044.ReminderRepositoryImpl(
        gh<_i627.RemindersDao>(),
        gh<_i386.EventsDao>(),
      ),
    );
    gh.factory<_i983.WatchAgendaUseCase>(
      () => _i983.WatchAgendaUseCase(gh<_i49.ScheduleRepository>()),
    );
    gh.factory<_i983.SetSessionBookmarkedUseCase>(
      () => _i983.SetSessionBookmarkedUseCase(gh<_i49.ScheduleRepository>()),
    );
    gh.lazySingleton<_i506.DynamicColorSource>(
      () => const _i711.MaterialYouColorSource(),
    );
    gh.factory<_i355.SetEventReminderUseCase>(
      () => _i355.SetEventReminderUseCase(gh<_i297.ReminderRepository>()),
    );
    gh.lazySingleton<_i327.SettingsLocalDataSource>(
      () =>
          _i327.SettingsLocalDataSource(gh<_i460.SharedPreferencesWithCache>()),
    );
    gh.factory<_i355.OpenNotificationSettingsUseCase>(
      () => _i355.OpenNotificationSettingsUseCase(
        gh<_i819.NotificationScheduler>(),
      ),
    );
    gh.factory<_i788.AgendaCubit>(
      () => _i788.AgendaCubit(
        gh<_i983.WatchAgendaUseCase>(),
        gh<_i983.SetSessionBookmarkedUseCase>(),
      ),
    );
    gh.lazySingleton<_i1000.AssetJsonLoader>(
      () => _i1000.AssetJsonLoader(gh<_i281.AssetBundle>()),
    );
    gh.lazySingleton<_i156.ProfileRepository>(
      () => _i75.ProfileRepositoryImpl(gh<_i144.ProfileDao>()),
    );
    gh.factory<_i351.WatchSavedEventsUseCase>(
      () => _i351.WatchSavedEventsUseCase(gh<_i285.SavedEventRepository>()),
    );
    gh.factory<_i351.SetEventSavedUseCase>(
      () => _i351.SetEventSavedUseCase(gh<_i285.SavedEventRepository>()),
    );
    gh.lazySingleton<_i385.OrganizerRepository>(
      () => _i793.OrganizerRepositoryImpl(
        gh<_i900.OrganizersDao>(),
        gh<_i386.EventsDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.lazySingleton<_i805.EventClock>(
      () => _i805.EventClock(gh<_i454.Clock>(), gh<_i805.DeviceTimeZone>()),
    );
    gh.lazySingleton<_i107.RecentSearchesRepository>(
      () => _i315.RecentSearchesRepositoryImpl(
        gh<_i835.RecentSearchesDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.factory<_i148.WatchOrganizerUseCase>(
      () => _i148.WatchOrganizerUseCase(gh<_i385.OrganizerRepository>()),
    );
    gh.factory<_i148.SetFollowingUseCase>(
      () => _i148.SetFollowingUseCase(gh<_i385.OrganizerRepository>()),
    );
    gh.lazySingleton<_i691.SearchRepository>(
      () => _i832.SearchRepositoryImpl(gh<_i386.EventsDao>()),
    );
    gh.factory<_i626.SearchEventsUseCase>(
      () => _i626.SearchEventsUseCase(
        gh<_i691.SearchRepository>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.lazySingleton<_i233.SettingsRepository>(
      () => _i5.SettingsRepositoryImpl(gh<_i327.SettingsLocalDataSource>()),
    );
    await gh.lazySingletonAsync<_i94.DeviceColors>(
      () => appModule.deviceColors(gh<_i506.DynamicColorSource>()),
      preResolve: true,
    );
    gh.factory<_i860.OpenLinkUseCase>(
      () => _i860.OpenLinkUseCase(gh<_i216.LinkOpener>()),
    );
    gh.lazySingleton<_i102.DemoCalendar>(
      () => _i102.StoredDemoCalendar(
        gh<_i327.SettingsLocalDataSource>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.factory<_i355.ShowRsvpConfirmationUseCase>(
      () => _i355.ShowRsvpConfirmationUseCase(
        gh<_i233.SettingsRepository>(),
        gh<_i819.NotificationScheduler>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i148.WatchFollowingUseCase>(
      () => _i148.WatchFollowingUseCase(
        gh<_i385.OrganizerRepository>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i355.AlertCatalogChangesUseCase>(
      () => _i355.AlertCatalogChangesUseCase(
        gh<_i297.ReminderRepository>(),
        gh<_i233.SettingsRepository>(),
        gh<_i819.NotificationScheduler>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i397.SavedCubit>(
      () => _i397.SavedCubit(
        gh<_i351.WatchSavedEventsUseCase>(),
        gh<_i351.SetEventSavedUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i112.WatchProfileUseCase>(
      () => _i112.WatchProfileUseCase(gh<_i156.ProfileRepository>()),
    );
    gh.factory<_i112.UpdateProfileUseCase>(
      () => _i112.UpdateProfileUseCase(gh<_i156.ProfileRepository>()),
    );
    gh.factory<_i870.ProfileEditCubit>(
      () => _i870.ProfileEditCubit(
        gh<_i112.WatchProfileUseCase>(),
        gh<_i112.UpdateProfileUseCase>(),
      ),
    );
    gh.factory<_i355.UpdateReminderLeadUseCase>(
      () => _i355.UpdateReminderLeadUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i355.UpdateSummaryUseCase>(
      () => _i355.UpdateSummaryUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i27.WatchSettingsUseCase>(
      () => _i27.WatchSettingsUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i27.UpdateThemeModeUseCase>(
      () => _i27.UpdateThemeModeUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i27.UpdateDynamicColorUseCase>(
      () => _i27.UpdateDynamicColorUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i27.UpdatePreferredCityUseCase>(
      () => _i27.UpdatePreferredCityUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i1009.StartFreshUseCase>(
      () => _i1009.StartFreshUseCase(gh<_i233.SettingsRepository>()),
    );
    gh.factory<_i112.WatchProfileCountsUseCase>(
      () => _i112.WatchProfileCountsUseCase(
        gh<_i156.ProfileRepository>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i626.WatchRecentSearchesUseCase>(
      () => _i626.WatchRecentSearchesUseCase(
        gh<_i107.RecentSearchesRepository>(),
      ),
    );
    gh.factory<_i626.SaveRecentSearchUseCase>(
      () => _i626.SaveRecentSearchUseCase(gh<_i107.RecentSearchesRepository>()),
    );
    gh.factory<_i626.ClearRecentSearchesUseCase>(
      () => _i626.ClearRecentSearchesUseCase(
        gh<_i107.RecentSearchesRepository>(),
      ),
    );
    gh.factory<_i359.OrganizerCubit>(
      () => _i359.OrganizerCubit(
        gh<_i148.WatchOrganizerUseCase>(),
        gh<_i148.SetFollowingUseCase>(),
        gh<_i351.SetEventSavedUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i355.SetNotificationsEnabledUseCase>(
      () => _i355.SetNotificationsEnabledUseCase(
        gh<_i233.SettingsRepository>(),
        gh<_i819.NotificationScheduler>(),
      ),
    );
    gh.factory<_i550.ProfileCubit>(
      () => _i550.ProfileCubit(
        gh<_i112.WatchProfileUseCase>(),
        gh<_i112.WatchProfileCountsUseCase>(),
      ),
    );
    gh.lazySingleton<_i355.SyncNotificationsUseCase>(
      () => _i355.SyncNotificationsUseCase(
        gh<_i233.SettingsRepository>(),
        gh<_i297.ReminderRepository>(),
        gh<_i819.NotificationScheduler>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i355.PreviewNotificationPlanUseCase>(
      () => _i355.PreviewNotificationPlanUseCase(
        gh<_i233.SettingsRepository>(),
        gh<_i297.ReminderRepository>(),
        gh<_i819.NotificationScheduler>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i355.KeepNotificationsInSyncUseCase>(
      () => _i355.KeepNotificationsInSyncUseCase(
        gh<_i355.SyncNotificationsUseCase>(),
        gh<_i297.ReminderRepository>(),
        gh<_i233.SettingsRepository>(),
      ),
    );
    gh.factory<_i272.SettingsCubit>(
      () => _i272.SettingsCubit(
        gh<_i233.SettingsRepository>(),
        gh<_i27.UpdateThemeModeUseCase>(),
        gh<_i27.UpdateDynamicColorUseCase>(),
        gh<_i27.UpdatePreferredCityUseCase>(),
        gh<_i355.UpdateReminderLeadUseCase>(),
        gh<_i355.UpdateSummaryUseCase>(),
        gh<_i94.DeviceColors>(),
      ),
    );
    gh.lazySingleton<_i796.FakeEventlyApi>(
      () => _i796.FakeEventlyApi(
        gh<_i1000.AssetJsonLoader>(),
        gh<_i1024.NetworkSimulator>(),
        gh<_i454.Clock>(),
        gh<_i102.DemoCalendar>(),
      ),
    );
    gh.factory<_i514.FollowingCubit>(
      () => _i514.FollowingCubit(gh<_i148.WatchFollowingUseCase>()),
    );
    gh.factory<_i820.SearchBloc>(
      () => _i820.SearchBloc(
        gh<_i626.SearchEventsUseCase>(),
        gh<_i626.WatchRecentSearchesUseCase>(),
        gh<_i626.SaveRecentSearchUseCase>(),
        gh<_i626.ClearRecentSearchesUseCase>(),
        gh<_i351.SetEventSavedUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.lazySingleton<_i844.EventlyApi>(
      () => appModule.api(gh<_i796.FakeEventlyApi>()),
    );
    gh.lazySingleton<_i405.DeveloperTools>(
      () => _i520.FakeDeveloperTools(
        gh<_i1024.NetworkSimulator>(),
        gh<_i796.FakeEventlyApi>(),
        gh<_i102.DemoCalendar>(),
      ),
    );
    gh.factory<_i27.DeveloperToolsUseCase>(
      () => _i27.DeveloperToolsUseCase(gh<_i405.DeveloperTools>()),
    );
    gh.lazySingleton<_i182.DemoRepository>(
      () => _i936.DemoRepositoryImpl(
        gh<_i844.EventlyApi>(),
        gh<_i542.UserDataDao>(),
      ),
    );
    gh.factory<_i1009.StartWithDemoUseCase>(
      () => _i1009.StartWithDemoUseCase(
        gh<_i182.DemoRepository>(),
        gh<_i233.SettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i435.BookingRepository>(
      () => _i373.BookingRepositoryImpl(
        gh<_i844.EventlyApi>(),
        gh<_i4.TicketsDao>(),
        gh<_i454.Clock>(),
      ),
    );
    gh.lazySingleton<_i521.CatalogRepository>(
      () => _i507.CatalogRepositoryImpl(
        gh<_i844.EventlyApi>(),
        gh<_i601.CatalogDao>(),
        gh<_i386.EventsDao>(),
        gh<_i627.RemindersDao>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i997.RefreshCatalogUseCase>(
      () => _i997.RefreshCatalogUseCase(
        gh<_i521.CatalogRepository>(),
        gh<_i355.AlertCatalogChangesUseCase>(),
      ),
    );
    gh.factory<_i217.RsvpEventUseCase>(
      () => _i217.RsvpEventUseCase(
        gh<_i521.CatalogRepository>(),
        gh<_i435.BookingRepository>(),
        gh<_i805.EventClock>(),
        gh<_i355.ShowRsvpConfirmationUseCase>(),
      ),
    );
    gh.factory<_i217.WatchTicketsUseCase>(
      () => _i217.WatchTicketsUseCase(gh<_i435.BookingRepository>()),
    );
    gh.factory<_i217.WatchTicketUseCase>(
      () => _i217.WatchTicketUseCase(gh<_i435.BookingRepository>()),
    );
    gh.factory<_i997.ListCitiesUseCase>(
      () => _i997.ListCitiesUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i351.WatchEventCardsUseCase>(
      () => _i351.WatchEventCardsUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i351.WatchEventDetailsUseCase>(
      () => _i351.WatchEventDetailsUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i27.ClearCacheUseCase>(
      () => _i27.ClearCacheUseCase(gh<_i521.CatalogRepository>()),
    );
    gh.factory<_i246.RunBackgroundSyncUseCase>(
      () => _i246.RunBackgroundSyncUseCase(
        gh<_i521.CatalogRepository>(),
        gh<_i355.AlertCatalogChangesUseCase>(),
        gh<_i355.SyncNotificationsUseCase>(),
      ),
    );
    gh.factory<_i27.ResetDemoDataUseCase>(
      () => _i27.ResetDemoDataUseCase(
        gh<_i521.CatalogRepository>(),
        gh<_i182.DemoRepository>(),
        gh<_i405.DeveloperTools>(),
      ),
    );
    gh.factory<_i217.CancelRsvpUseCase>(
      () => _i217.CancelRsvpUseCase(
        gh<_i435.BookingRepository>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i186.EventDetailCubit>(
      () => _i186.EventDetailCubit(
        gh<_i351.WatchEventDetailsUseCase>(),
        gh<_i351.SetEventSavedUseCase>(),
        gh<_i355.SetEventReminderUseCase>(),
        gh<_i27.WatchSettingsUseCase>(),
        gh<_i860.OpenLinkUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i648.TicketDetailCubit>(
      () => _i648.TicketDetailCubit(
        gh<_i217.WatchTicketUseCase>(),
        gh<_i217.CancelRsvpUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i664.DiscoverCubit>(
      () => _i664.DiscoverCubit(
        gh<_i351.WatchEventCardsUseCase>(),
        gh<_i27.WatchSettingsUseCase>(),
        gh<_i997.RefreshCatalogUseCase>(),
        gh<_i351.SetEventSavedUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i321.WelcomeCubit>(
      () => _i321.WelcomeCubit(
        gh<_i997.RefreshCatalogUseCase>(),
        gh<_i997.ListCitiesUseCase>(),
        gh<_i1009.StartWithDemoUseCase>(),
        gh<_i1009.StartFreshUseCase>(),
      ),
    );
    gh.factory<_i263.SettingsToolsCubit>(
      () => _i263.SettingsToolsCubit(
        gh<_i997.ListCitiesUseCase>(),
        gh<_i27.ClearCacheUseCase>(),
        gh<_i27.ResetDemoDataUseCase>(),
        gh<_i27.DeveloperToolsUseCase>(),
        gh<_i355.SetNotificationsEnabledUseCase>(),
        gh<_i355.OpenNotificationSettingsUseCase>(),
        gh<_i246.RunBackgroundSyncUseCase>(),
        gh<_i355.PreviewNotificationPlanUseCase>(),
      ),
    );
    gh.factory<_i220.TicketsCubit>(
      () => _i220.TicketsCubit(
        gh<_i217.WatchTicketsUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    gh.factory<_i655.RsvpCubit>(
      () => _i655.RsvpCubit(
        gh<_i351.WatchEventDetailsUseCase>(),
        gh<_i217.RsvpEventUseCase>(),
        gh<_i805.EventClock>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i64.AppModule {}
