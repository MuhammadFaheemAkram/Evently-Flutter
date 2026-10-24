import 'package:evently/core/common/event_clock.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/domain/calculation/event_timeline.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/domain/repository/organizer_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchOrganizerUseCase {
  const WatchOrganizerUseCase(this._organizers);

  final OrganizerRepository _organizers;

  Stream<OrganizerDetails?> call(String organizerId) =>
      _organizers.watchOrganizer(organizerId);
}

/// The organizers you follow, each with their next event: the soonest not
/// over yet (as of the user's now) and not cancelled.
@injectable
class WatchFollowingUseCase {
  const WatchFollowingUseCase(this._organizers, this._clock);

  final OrganizerRepository _organizers;
  final EventClock _clock;

  Stream<List<FollowedOrganizer>> call() =>
      _organizers.watchFollowed().map((followed) {
        final now = _clock.now();
        return [
          for (final details in followed)
            FollowedOrganizer(
              organizer: details.organizer,
              nextEvent: splitByEnd(
                [
                  for (final card in details.events)
                    if (card.event.status != EventStatus.cancelled) card,
                ],
                eventOf: (card) => card.event,
                now: now,
              ).upcoming.firstOrNull,
            ),
        ];
      });
}

@injectable
class SetFollowingUseCase {
  const SetFollowingUseCase(this._organizers);

  final OrganizerRepository _organizers;

  Future<Result<void>> call(String organizerId, {required bool following}) =>
      _organizers.setFollowing(organizerId, following: following);
}
