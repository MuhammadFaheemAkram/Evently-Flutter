import 'package:evently/core/common/event_clock.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/domain/repository/settings_repository.dart';
import 'package:evently/features/agenda/cubit/agenda_cubit.dart';
import 'package:evently/features/discover/cubit/discover_cubit.dart';
import 'package:evently/features/event_detail/cubit/event_detail_cubit.dart';
import 'package:evently/features/rsvp/cubit/rsvp_cubit.dart';
import 'package:evently/features/saved/cubit/saved_cubit.dart';
import 'package:evently/features/search/bloc/search_bloc.dart';
import 'package:evently/features/ticket_detail/cubit/ticket_detail_cubit.dart';
import 'package:evently/features/tickets/cubit/tickets_cubit.dart';
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
    expect(getIt<SearchBloc>(), isA<SearchBloc>());
    expect(getIt<SavedCubit>(), isA<SavedCubit>());
    expect(getIt<RsvpCubit>(), isA<RsvpCubit>());
    expect(getIt<TicketsCubit>(), isA<TicketsCubit>());
    expect(getIt<TicketDetailCubit>(), isA<TicketDetailCubit>());
    expect(getIt<AgendaCubit>(), isA<AgendaCubit>());
    expect(getIt<EventClock>().local.name, 'Europe/London');
  });
}
