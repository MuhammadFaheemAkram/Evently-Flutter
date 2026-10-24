import 'package:evently/domain/calculation/catalog_diff.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final six = DateTime.utc(2026, 10, 24, 18);
  final seven = DateTime.utc(2026, 10, 24, 19);

  EventVersion version(
    String id, {
    DateTime? start,
    EventStatus status = EventStatus.scheduled,
  }) => (id: id, start: start ?? six, status: status);

  test('unchanged: no change', () {
    final diff = diffCatalog([version('a')], [version('a')]);

    expect(diff.isEmpty, isTrue);
  });

  test('a new start is a move; the same instant written in another zone '
      'is not', () {
    expect(diffCatalog([version('a')], [version('a', start: seven)]).moved, [
      'a',
    ]);
    expect(
      diffCatalog([version('a')], [version('a', start: six.toLocal())]).isEmpty,
      isTrue,
    );
  });

  test('on, then off: cancelled; already off: no change', () {
    expect(
      diffCatalog(
        [version('a')],
        [version('a', status: EventStatus.cancelled)],
      ).cancelled,
      ['a'],
    );
    expect(
      diffCatalog(
        [version('a', status: EventStatus.cancelled)],
        [version('a', status: EventStatus.cancelled)],
      ).isEmpty,
      isTrue,
    );
  });

  test('moved and cancelled at once: cancelled wins', () {
    final diff = diffCatalog(
      [version('a')],
      [version('a', start: seven, status: EventStatus.cancelled)],
    );

    expect(diff.cancelled, ['a']);
    expect(diff.moved, isEmpty);
  });

  test('a moved event moving again is another move', () {
    expect(
      diffCatalog(
        [version('a', start: seven, status: EventStatus.moved)],
        [version('a', start: six, status: EventStatus.moved)],
      ).moved,
      ['a'],
    );
  });

  test('back on after a cancellation: nothing to alert', () {
    expect(
      diffCatalog(
        [version('a', status: EventStatus.cancelled)],
        [version('a')],
      ).isEmpty,
      isTrue,
    );
  });

  test('new events are added, in the new order', () {
    final diff = diffCatalog(
      [version('a')],
      [version('c'), version('a'), version('b')],
    );

    expect(diff.added, ['c', 'b']);
    expect(diff.moved, isEmpty);
  });

  test('only changes to ticketed events are recorded; new ones never', () {
    final diff = diffCatalog(
      [version('a'), version('b'), version('c'), version('d')],
      [
        version('a', start: seven),
        version('b', start: seven),
        version('c', status: EventStatus.cancelled),
        version('d', status: EventStatus.cancelled),
        version('e'),
      ],
    );

    expect(changesToRecord(diff, {'a', 'c', 'e'}), [
      (eventId: 'a', kind: EventChangeKind.moved),
      (eventId: 'c', kind: EventChangeKind.cancelled),
    ]);
  });
}
