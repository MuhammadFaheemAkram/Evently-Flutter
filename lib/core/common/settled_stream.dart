import 'dart:async';

extension SettledStream<T> on Stream<T> {
  /// The latest value once [duration] has passed without a newer one: a
  /// debounce. A value still waiting when the source ends is delivered
  /// first.
  ///
  /// Unlike stream_transform's `debounce`, cancelling the subscription also
  /// cancels the waiting timer (conventions §11.63): an app-wide watcher's
  /// timer mustn't outlive it, and a widget test fails on any timer left
  /// when its tree is disposed.
  Stream<T> settled(Duration duration) => Stream<T>.multi((controller) {
    Timer? timer;
    T? pending;
    var hasPending = false;

    void flush() {
      timer = null;
      if (!hasPending) return;
      hasPending = false;
      controller.add(pending as T);
      pending = null;
    }

    final subscription = listen(
      (value) {
        timer?.cancel();
        pending = value;
        hasPending = true;
        timer = Timer(duration, flush);
      },
      onError: controller.addError,
      onDone: () {
        timer?.cancel();
        flush();
        controller.close();
      },
    );
    controller.onCancel = () {
      timer?.cancel();
      return subscription.cancel();
    };
  });
}
