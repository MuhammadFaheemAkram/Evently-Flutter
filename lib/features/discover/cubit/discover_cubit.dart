import 'dart:async';

import 'package:evently/core/common/app_exception.dart';
import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/discover_sections.dart';
import 'package:evently/domain/model/app_settings.dart';
import 'package:evently/domain/model/event_card_item.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/usecase/catalog_use_cases.dart';
import 'package:evently/domain/usecase/event_use_cases.dart';
import 'package:evently/domain/usecase/settings_use_cases.dart';
import 'package:evently/features/discover/cubit/discover_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Discover: featured events, events in your city and what's coming up,
/// from the cache.
///
/// It watches the database, never the API: the lists follow every change
/// (a refresh, a save, a booking) by themselves. A refresh only writes the
/// cache. Offline, the cache stays on screen and a SnackBar says so; only an
/// *empty* cache that can't be filled is an error screen.
@injectable
class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit(
    this._watchCards,
    this._watchSettings,
    this._refreshCatalog,
    this._setSaved,
    this._clock,
  ) : super(const DiscoverState());

  /// What a failed pull-to-refresh says when the cache is still there.
  static const offlineMessage = "You're offline. Showing the events you have.";

  final WatchEventCardsUseCase _watchCards;
  final WatchSettingsUseCase _watchSettings;
  final RefreshCatalogUseCase _refreshCatalog;
  final SetEventSavedUseCase _setSaved;
  final EventClock _clock;

  StreamSubscription<List<EventCardItem>>? _cardsSubscription;
  StreamSubscription<AppSettings>? _settingsSubscription;

  /// `null` until the cache is first read.
  List<EventCardItem>? _cards;

  /// The preferred city, once the settings are read.
  String? _city;

  /// An empty cache is being filled.
  var _filling = false;

  /// Why filling the empty cache failed.
  String? _fillError;

  void load() {
    _settingsSubscription ??= _watchSettings().listen((settings) {
      _city = settings.preferredCity;
      _publish();
    });
    _cardsSubscription ??= _watchCards().listen(
      (cards) {
        final firstRead = _cards == null;
        _cards = cards;
        if (firstRead && cards.isEmpty) {
          // Welcome filled the cache, but Clear cache (Phase 6) can empty
          // it: fetch before showing "no events".
          unawaited(_fill());
        } else {
          _publish();
        }
      },
      onError: (Object _) {
        _fillError = "Couldn't read the events.";
        _cards ??= const [];
        _publish();
      },
    );
  }

  void selectCategory(EventCategory? category) {
    emit(state.copyWith(category: category));
    _publish();
  }

  /// Pull to refresh. Completes when the refresh does, so the spinner
  /// knows when to stop. The lists follow by themselves.
  Future<void> refresh() async {
    final result = await _refreshCatalog();
    if (isClosed) return;
    if (result case Err(:final exception)) {
      _say(exception is NetworkException ? offlineMessage : exception.message);
    }
  }

  /// Error screen → Try again: fetch the catalog into the empty cache.
  Future<void> tryAgain() => _fill();

  Future<void> toggleSaved(EventCardItem item) async {
    final result = await _setSaved(item.event.id, saved: !item.isSaved);
    if (isClosed) return;
    if (result case Err(:final exception)) _say(exception.message);
  }

  Future<void> _fill() async {
    if (_filling) return;
    _filling = true;
    _fillError = null;
    _publish();
    final result = await _refreshCatalog();
    _filling = false;
    if (isClosed) return;
    switch (result) {
      // Events arrived: the database stream brings them and publishes.
      case Ok(:final value) when value > 0:
        return;
      case Ok():
        _publish();
      case Err(:final exception):
        _fillError = exception.message;
        _publish();
    }
  }

  void _publish() {
    final cards = _cards;
    if (cards == null) return;
    final DiscoverStatus status;
    if (cards.isNotEmpty) {
      status = DiscoverStatus.ready;
    } else if (_filling) {
      status = DiscoverStatus.loading;
    } else if (_fillError != null) {
      status = DiscoverStatus.failed;
    } else {
      status = DiscoverStatus.empty;
    }
    final sections = discoverSections(
      cards,
      clock: _clock,
      city: _city,
      category: state.category,
    );
    emit(
      state.copyWith(
        status: status,
        featured: sections.featured,
        inYourCity: sections.inYourCity,
        upcoming: sections.upcoming,
        city: _city,
        now: _clock.now(),
        today: _clock.today(),
        errorMessage: status == DiscoverStatus.failed ? _fillError : null,
      ),
    );
  }

  void _say(String message) => emit(
    state.copyWith(message: message, messageSerial: state.messageSerial + 1),
  );

  @override
  Future<void> close() async {
    await _cardsSubscription?.cancel();
    await _settingsSubscription?.cancel();
    return super.close();
  }
}
