import 'dart:async';

import 'package:evently/core/common/settled_stream.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('delivers the latest value once things are quiet', () {
    fakeAsync((async) {
      final source = StreamController<int>();
      addTearDown(source.close);
      final seen = <int>[];
      source.stream.settled(const Duration(milliseconds: 300)).listen(seen.add);

      source
        ..add(1)
        ..add(2);
      async.elapse(const Duration(milliseconds: 299));
      source.add(3);
      async.elapse(const Duration(milliseconds: 299));
      expect(seen, isEmpty);

      async.elapse(const Duration(milliseconds: 1));
      expect(seen, [3]);
    });
  });

  test('a value waiting when the source ends is delivered', () {
    fakeAsync((async) {
      final seen = <int>[];
      Stream.fromIterable([1, 2])
          .settled(const Duration(seconds: 1))
          .listen(seen.add);

      async.flushMicrotasks();
      expect(seen, [2]);
    });
  });

  // Conventions §11.63: stream_transform's debounce keeps its timer after
  // a cancel, and a widget test fails on it.
  test('cancelling cancels the waiting timer', () {
    fakeAsync((async) {
      final source = StreamController<int>();
      addTearDown(source.close);
      final subscription = source.stream
          .settled(const Duration(milliseconds: 300))
          .listen((_) {});

      source.add(1);
      async.flushMicrotasks();
      expect(async.pendingTimers, hasLength(1));

      subscription.cancel();
      expect(async.pendingTimers, isEmpty);
    });
  });
}
