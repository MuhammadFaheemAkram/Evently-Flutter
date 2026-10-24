import 'dart:async';

import 'package:material_ui/material_ui.dart';

/// Adapts a [Stream] into a [Listenable], so `GoRouter.refreshListenable` can
/// follow a stream: every new value re-runs the router's redirect.
///
/// go_router only understands `Listenable`s; repositories and Blocs expose
/// `Stream`s. This is the whole bridge between the two.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
