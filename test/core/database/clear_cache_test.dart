import 'package:evently/core/database/app_database.dart';
import 'package:evently/data/mapper/catalog_mappers.dart';
import 'package:evently/data/mapper/user_data_mappers.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/database.dart';
import '../../helpers/user_data_fixtures.dart';

// Clear cache keeps everything the user owns anything of.
void main() {
  late AppDatabase db;
  final at = DateTime.utc(2026, 10, 20, 9);

  setUp(() async {
    db = newTestDatabase();
    await db.catalogDao.upsertCatalog(
      catalogOf(
        [
          event(id: 'saved'),
          event(id: 'ticketed'),
          event(id: 'cancelled_ticket'),
          event(id: 'bookmarked'),
          event(id: 'reminded'),
          event(id: 'alerted'),
          event(id: 'free_a', organizerId: 'org_gone'),
          event(id: 'free_b', organizerId: 'org_followed'),
        ],
        sessions: [
          session(id: 'ses_kept', eventId: 'bookmarked'),
          session(id: 'ses_gone', eventId: 'free_a'),
        ],
      ).toRows(),
    );
    await db.savedEventsDao.save('saved', at);
    await db.into(db.tickets).insert(ticket(eventId: 'ticketed').toRow());
    await db
        .into(db.tickets)
        .insert(
          ticket(
            id: 't2',
            eventId: 'cancelled_ticket',
            code: 'EVT-H4TW-8RCU',
            cancelledAt: at,
          ).toRow(),
        );
    await db
        .into(db.sessionBookmarks)
        .insert(SessionBookmarkRow(sessionId: 'ses_kept', createdAt: at));
    await db
        .into(db.eventReminders)
        .insert(const EventReminderRow(eventId: 'reminded', enabled: true));
    await db
        .into(db.eventChanges)
        .insert(
          EventChangesCompanion.insert(
            eventId: 'alerted',
            kind: EventChangeKind.moved,
            detectedAt: at,
          ),
        );
    await db
        .into(db.followedOrganizers)
        .insert(FollowRow(organizerId: 'org_followed', followedAt: at));
  });

  tearDown(() => db.close());

  Future<Set<String>> ids(String table) async => {
    for (final row in await db.customSelect('SELECT id FROM $table').get())
      row.read<String>('id'),
  };

  test('deletes only events nothing of the user points at, and says how '
      'many', () async {
    expect(await db.catalogDao.clearUnowned(), 2);

    expect(await ids('events'), {
      'saved',
      'ticketed',
      'cancelled_ticket',
      'bookmarked',
      'reminded',
      'alerted',
    });
  });

  test('their offers and sessions go too', () async {
    await db.catalogDao.clearUnowned();

    expect(await ids('sessions'), {'ses_kept'});
    final offers = await db.select(db.ticketOffers).get();
    expect(offers.map((o) => o.eventId), isNot(contains('free_a')));
  });

  test('organizers left with no event go, unless followed', () async {
    await db.catalogDao.clearUnowned();

    expect(await ids('organizers'), {'org_1', 'org_followed'});
  });

  test('the user rows are untouched', () async {
    await db.catalogDao.clearUnowned();

    expect(await db.select(db.savedEvents).get(), hasLength(1));
    expect(await db.select(db.tickets).get(), hasLength(2));
    expect(await db.select(db.sessionBookmarks).get(), hasLength(1));
  });

  test('a refresh brings the rest back', () async {
    await db.catalogDao.clearUnowned();

    await db.catalogDao.upsertCatalog(
      catalogOf([event(id: 'free_a', organizerId: 'org_gone')]).toRows(),
    );

    expect(await ids('events'), contains('free_a'));
  });
}
