import 'package:evently/features/welcome/welcome_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('each choice reports itself', (tester) async {
    final chosen = <String>[];
    await tester.pumpThemed(
      WelcomeView(
        onExploreDemo: () => chosen.add('demo'),
        onStartFresh: () => chosen.add('fresh'),
      ),
    );

    await tester.tap(find.text('Explore with demo data'));
    await tester.tap(find.text('Start fresh'));

    expect(chosen, ['demo', 'fresh']);
  });
}
