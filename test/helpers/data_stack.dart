import 'dart:math';

import 'package:clock/clock.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/fake_developer_tools.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/data/repository/booking_repository_impl.dart';
import 'package:evently/data/repository/catalog_repository_impl.dart';
import 'package:evently/data/repository/demo_repository_impl.dart';
import 'package:evently/data/repository/organizer_repository_impl.dart';
import 'package:evently/data/repository/profile_repository_impl.dart';
import 'package:evently/data/repository/recent_searches_repository_impl.dart';
import 'package:evently/data/repository/reminder_repository_impl.dart';
import 'package:evently/data/repository/saved_event_repository_impl.dart';
import 'package:evently/data/repository/schedule_repository_impl.dart';
import 'package:evently/data/repository/search_repository_impl.dart';
import 'package:evently/domain/usecase/background_use_cases.dart';
import 'package:evently/domain/usecase/booking_use_cases.dart';
import 'package:evently/domain/usecase/catalog_use_cases.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/domain/usecase/notification_use_cases.dart';
import 'package:evently/domain/usecase/open_link_use_case.dart';
import 'package:evently/domain/usecase/organizer_use_cases.dart';
import 'package:evently/domain/usecase/profile_use_cases.dart';
import 'package:evently/domain/usecase/schedule_use_cases.dart';
import 'package:evently/domain/usecase/search_use_cases.dart';
import 'package:evently/domain/usecase/settings_use_cases.dart';
import 'package:evently/domain/usecase/start_use_cases.dart';
import 'package:flutter/services.dart';

import 'database.dart';
import 'fakes/fake_notification_scheduler.dart';
import 'fakes/fake_settings_repository.dart';
import 'fakes/memory_demo_calendar.dart';
import 'fakes/recording_link_opener.dart';
import 'test_dependencies.dart';

/// The real repositories and use cases on an in-memory database, with a
/// clock stopped at [now] (set it to move time) and the real fake API (zero latency, reading the bundled
/// JSON): what Cubit and repository tests run against instead of mocks.
/// Notifications go to a [FakeNotificationScheduler] ([notifications]).
///
/// Pass [api] to script the server's answers (it can wrap [realApi]).
/// Tests that read the bundled assets need
/// `TestWidgetsFlutterBinding.ensureInitialized()`.
class DataStack {
  DataStack({DateTime? now, EventlyApi Function(EventlyApi real)? api})
    : now = now ?? demoNow,
      network = NetworkSimulator(latency: Duration.zero) {
    calendar = MemoryDemoCalendar(clock);
    // Seeded: the server's ticket codes repeat from run to run.
    realApi = server = FakeEventlyApi(
      AssetJsonLoader(rootBundle),
      network,
      clock,
      calendar,
      random: Random(1),
    );
    this.api = api?.call(realApi) ?? realApi;
  }

  /// What every clock here reads; it moves only when a test sets it.
  DateTime now;
  late final Clock clock = Clock(() => now);
  final NetworkSimulator network;

  /// The fake server's calendar, anchored at its first fetch.
  late final MemoryDemoCalendar calendar;

  /// The fake server, as the developer tools reach it.
  late final FakeEventlyApi server;
  late final EventlyApi realApi;
  late final EventlyApi api;
  final AppDatabase db = newTestDatabase();
  final settings = FakeSettingsRepository();
  final notifications = FakeNotificationScheduler();

  late final catalog = CatalogRepositoryImpl(
    api,
    db.catalogDao,
    db.eventsDao,
    db.remindersDao,
    eventClock,
  );
  late final reminders = ReminderRepositoryImpl(db.remindersDao, db.eventsDao);
  late final savedEvents = SavedEventRepositoryImpl(
    db.savedEventsDao,
    db.eventsDao,
    clock,
  );
  late final searchRepository = SearchRepositoryImpl(db.eventsDao);
  late final recentSearches = RecentSearchesRepositoryImpl(
    db.recentSearchesDao,
    clock,
  );
  late final eventClock = EventClock(clock, londonZone);
  final links = RecordingLinkOpener();
  late final booking = BookingRepositoryImpl(api, db.ticketsDao, clock);
  late final organizers = OrganizerRepositoryImpl(
    db.organizersDao,
    db.eventsDao,
    clock,
  );
  late final profile = ProfileRepositoryImpl(db.profileDao);
  late final schedule = ScheduleRepositoryImpl(db.sessionBookmarksDao, clock);
  late final demo = DemoRepositoryImpl(api, db.userDataDao);

  late final syncNotifications = SyncNotificationsUseCase(
    settings,
    reminders,
    notifications,
    eventClock,
  );
  late final alertChanges = AlertCatalogChangesUseCase(
    reminders,
    settings,
    notifications,
    eventClock,
  );
  late final showRsvpConfirmation = ShowRsvpConfirmationUseCase(
    settings,
    notifications,
    eventClock,
  );
  late final setEventReminder = SetEventReminderUseCase(reminders);
  late final setNotificationsEnabled = SetNotificationsEnabledUseCase(
    settings,
    notifications,
  );
  late final updateReminderLead = UpdateReminderLeadUseCase(settings);
  late final updateSummary = UpdateSummaryUseCase(settings);
  late final openNotificationSettings = OpenNotificationSettingsUseCase(
    notifications,
  );
  late final previewPlan = PreviewNotificationPlanUseCase(
    settings,
    reminders,
    notifications,
    eventClock,
  );
  late final runBackgroundSync = RunBackgroundSyncUseCase(
    catalog,
    alertChanges,
    syncNotifications,
  );
  late final refreshCatalog = RefreshCatalogUseCase(catalog, alertChanges);
  late final listCities = ListCitiesUseCase(catalog);
  late final startWithDemo = StartWithDemoUseCase(demo, settings);
  late final startFresh = StartFreshUseCase(settings);
  late final watchEventCards = WatchEventCardsUseCase(catalog);
  late final watchEventDetails = WatchEventDetailsUseCase(catalog);
  late final setEventSaved = SetEventSavedUseCase(savedEvents);
  late final openLink = OpenLinkUseCase(links);
  late final watchSettings = WatchSettingsUseCase(settings);
  late final watchSaved = WatchSavedEventsUseCase(savedEvents);
  late final searchEvents = SearchEventsUseCase(searchRepository, eventClock);
  late final watchRecentSearches = WatchRecentSearchesUseCase(recentSearches);
  late final saveRecentSearch = SaveRecentSearchUseCase(recentSearches);
  late final clearRecentSearches = ClearRecentSearchesUseCase(recentSearches);
  late final rsvpEvent = RsvpEventUseCase(
    catalog,
    booking,
    eventClock,
    showRsvpConfirmation,
  );
  late final cancelRsvp = CancelRsvpUseCase(booking, eventClock);
  late final watchTickets = WatchTicketsUseCase(booking);
  late final watchTicket = WatchTicketUseCase(booking);
  late final watchAgenda = WatchAgendaUseCase(schedule);
  late final setSessionBookmarked = SetSessionBookmarkedUseCase(schedule);
  late final watchOrganizer = WatchOrganizerUseCase(organizers);
  late final watchFollowing = WatchFollowingUseCase(organizers, eventClock);
  late final setFollowing = SetFollowingUseCase(organizers);
  late final watchProfile = WatchProfileUseCase(profile);
  late final watchProfileCounts = WatchProfileCountsUseCase(
    profile,
    eventClock,
  );
  late final updateProfile = UpdateProfileUseCase(profile);
  late final updateThemeMode = UpdateThemeModeUseCase(settings);
  late final updateDynamicColor = UpdateDynamicColorUseCase(settings);
  late final updatePreferredCity = UpdatePreferredCityUseCase(settings);
  late final clearCache = ClearCacheUseCase(catalog);
  late final developerTools = FakeDeveloperTools(network, server, calendar);
  late final resetDemoData = ResetDemoDataUseCase(
    catalog,
    demo,
    developerTools,
  );
  late final developer = DeveloperToolsUseCase(developerTools);

  /// Fetches the catalog and the demo user, as "Explore with demo data"
  /// does.
  Future<void> loadDemo() async {
    await catalog.refresh();
    await demo.loadDemoUser();
  }

  Future<void> close() => db.close();
}
