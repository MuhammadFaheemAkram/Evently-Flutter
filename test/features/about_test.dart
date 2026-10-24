import 'package:evently/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';

void main() {
  tearDown(getIt.reset);

  testWidgets('About: the version and the editions', (tester) async {
    await pumpEvently(tester, initialLocation: '/about');

    expect(find.text('Version 1.0.0 (1)'), findsOneWidget);
    expect(find.text('Android'), findsOneWidget);
    expect(find.text('iOS'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
  });
}
