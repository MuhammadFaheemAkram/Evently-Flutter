import 'package:clock/clock.dart';
import 'package:evently/core/common/guard_write.dart';
import 'package:evently/core/common/result.dart';
import 'package:evently/core/database/daos/events_dao.dart';
import 'package:evently/core/database/daos/organizers_dao.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/event_card_mappers.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/domain/repository/organizer_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';

@LazySingleton(as: OrganizerRepository)
class OrganizerRepositoryImpl implements OrganizerRepository {
  const OrganizerRepositoryImpl(this._organizers, this._events, this._clock);

  final OrganizersDao _organizers;
  final EventsDao _events;
  final Clock _clock;

  /// Two live queries, combined: the organizer (and your follow) and their
  /// events. Either changing gives a new value.
  @override
  Stream<OrganizerDetails?> watchOrganizer(String organizerId) => _organizers
      .watchOne(organizerId)
      .combineLatest(_events.watchCardsBy(organizerId), (found, events) {
        if (found == null) return null;
        final (organizer, following) = found;
        return OrganizerDetails(
          organizer: organizer.toDomain(),
          isFollowing: following,
          events: [for (final row in events) row.toDomain()],
        );
      });

  @override
  Stream<List<OrganizerDetails>> watchFollowed() => _organizers
      .watchFollowed()
      .combineLatest(_events.watchCards(), (organizers, events) {
        final cards = [for (final row in events) row.toDomain()];
        return [
          for (final organizer in organizers)
            OrganizerDetails(
              organizer: organizer.toDomain(),
              isFollowing: true,
              events: [
                for (final card in cards)
                  if (card.event.organizerId == organizer.id) card,
              ],
            ),
        ];
      });

  @override
  Future<Result<void>> setFollowing(
    String organizerId, {
    required bool following,
  }) => guardWrite(
    following ? 'Following $organizerId' : 'Unfollowing $organizerId',
    () => _organizers.setFollowing(
      organizerId,
      following: following,
      at: _clock.now().toUtc(),
    ),
  );
}
