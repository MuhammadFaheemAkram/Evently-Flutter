import 'package:evently/core/common/event_clock.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/features/discover/cubit/discover_cubit.dart';
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart';
import 'package:evently/features/welcome/cubit/welcome_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(getIt.reset);

  // A smoke test of the real composition root. A dependency injectable can't
  // resolve only fails when its type is first resolved, at runtime; resolving
  // the top of each graph here catches it in CI. Every new Cubit, repository
  // and service belongs here.
  test('the real container resolves the app-wide singletons and the '
      'Cubits', () async {
    await configureTestDependencies();

    expect(getIt<SettingsRepository>(), same(getIt<SettingsRepository>()));
    expect(getIt<WelcomeCubit>(), isNot(same(getIt<WelcomeCubit>())));
    expect(getIt<DiscoverCubit>(), isNot(same(getIt<DiscoverCubit>())));
    expect(getIt<EventDetailCubit>(), isA<EventDetailCubit>());
    expect(getIt<EventClock>().local.name, 'Europe/London');
  });
}
