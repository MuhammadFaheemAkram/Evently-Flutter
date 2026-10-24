import 'dart:math';

import 'package:clock/clock.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/database/app_database.dart';
import 'package:evently/core/network/asset_json_loader.dart';
import 'package:evently/core/network/evently_api.dart';
import 'package:evently/core/network/fake_evently_api.dart';
import 'package:evently/core/network/network_simulator.dart';
import 'package:evently/data/repository/booking_repository_impl.dart';
import 'package:evently/data/repository/catalog_repository_impl.dart';
import 'package:evently/data/repository/demo_repository_impl.dart';
import 'package:evently/data/repository/recent_searches_repository_impl.dart';
import 'package:evently/data/repository/saved_event_repository_impl.dart';
import 'package:evently/data/repository/schedule_repository_impl.dart';
import 'package:evently/data/repository/search_repository_impl.dart';
import 'package:evently/domain/usecase/booking_use_cases.dart';
import 'package:evently/domain/usecase/catalog_use_cases.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/domain/usecase/open_link_use_case.dart';
import 'package:evently/domain/usecase/schedule_use_cases.dart';
import 'package:evently/domain/usecase/search_use_cases.dart';
import 'package:evently/domain/usecase/settings_use_cases.dart';
import 'package:evently/domain/usecase/start_use_cases.dart';
import 'package:flutter/services.dart';

import 'database.dart';
import 'fakes/fake_settings_repository.dart';
import 'fakes/recording_link_opener.dart';
import 'test_dependencies.dart';

/// The real repositories and use cases on an in-memory database, with a
/// fixed clock and the real fake API (zero latency, reading the bundled
/// JSON): what Cubit and repository tests run against instead of mocks.
///
/// Pass [api] to script the server's answers (it can wrap [realApi]).
/// Tests that read the bundled assets need
/// `TestWidgetsFlutterBinding.ensureInitialized()`.
class DataStack {
  DataStack({DateTime? now, EventlyApi Function(EventlyApi real)? api})
    : clock = Clock.fixed(now ?? demoNow),
      network = NetworkSimulator(latency: Duration.zero) {
    // Seeded: the server's ticket codes repeat from run to run.
    realApi = FakeEventlyApi(
      AssetJsonLoader(rootBundle),
      network,
      clock,
      random: Random(1),
    );
    this.api = api?.call(realApi) ?? realApi;
  }

  final Clock clock;
  final NetworkSimulator network;
  late final EventlyApi realApi;
  late final EventlyApi api;
  final AppDatabase db = newTestDatabase();
  final settings = FakeSettingsRepository();

  late final catalog = CatalogRepositoryImpl(api, db.catalogDao, db.eventsDao);
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
  late final schedule = ScheduleRepositoryImpl(db.sessionBookmarksDao, clock);
  late final demo = DemoRepositoryImpl(api, db.userDataDao);

  late final refreshCatalog = RefreshCatalogUseCase(catalog);
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
  late final rsvpEvent = RsvpEventUseCase(catalog, booking, eventClock);
  late final cancelRsvp = CancelRsvpUseCase(booking, eventClock);
  late final watchTickets = WatchTicketsUseCase(booking);
  late final watchTicket = WatchTicketUseCase(booking);
  late final watchAgenda = WatchAgendaUseCase(schedule);
  late final setSessionBookmarked = SetSessionBookmarkedUseCase(schedule);

  /// Fetches the catalog and the demo user, as "Explore with demo data"
  /// does.
  Future<void> loadDemo() async {
    await catalog.refresh();
    await demo.loadDemoUser();
  }

  Future<void> close() => db.close();
}
