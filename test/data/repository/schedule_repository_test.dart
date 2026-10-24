import 'package:evently/domain/model/calendar_date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/result_matchers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  setUp(() async {
    stack = DataStack();
    addTearDown(stack.close);
    await stack.loadDemo();
  });

  test("the design conference: two Berlin days, the demo's bookmarks, and "
      'the clash between two of them', () async {
    final agenda = (await stack.schedule.watchAgenda('ev_design_conf').first)!;

    expect(agenda.zone, 'Europe/Berlin');
    expect(agenda.days, hasLength(2));
    expect(agenda.days.first.day, CalendarDate(2026, 11, 2));
    final sessions = {
      for (final day in agenda.days)
        for (final s in day.sessions) s.session.id: s,
    };
    expect(sessions, hasLength(12));
    expect(sessions['ses_conf_trust']!.isBookmarked, isTrue);
    expect(sessions['ses_conf_trust']!.clashesWith.map((s) => s.id), [
      'ses_conf_type',
    ]);
    expect(sessions['ses_conf_tokens']!.clashesWith, isEmpty);
  });

  test('an event without sessions: no days; one not cached: null', () async {
    final jazz = await stack.schedule.watchAgenda('ev_jazz_vaults').first;

    expect(jazz?.days, isEmpty);
    expect(await stack.schedule.watchAgenda('ev_nowhere').first, isNull);
  });

  test('a bookmark removed ends the clash; added back, it returns', () async {
    expect(
      await stack.schedule.setBookmarked('ses_conf_type', bookmarked: false),
      isOk(),
    );
    var agenda = (await stack.schedule.watchAgenda('ev_design_conf').first)!;
    var trust = agenda.days.first.sessions.singleWhere(
      (s) => s.session.id == 'ses_conf_trust',
    );
    expect(trust.clashesWith, isEmpty);

    await stack.schedule.setBookmarked('ses_conf_type', bookmarked: true);
    await stack.schedule.setBookmarked('ses_conf_type', bookmarked: true);
    agenda = (await stack.schedule.watchAgenda('ev_design_conf').first)!;
    trust = agenda.days.first.sessions.singleWhere(
      (s) => s.session.id == 'ses_conf_trust',
    );
    expect(trust.clashesWith, hasLength(1));
  });
}
