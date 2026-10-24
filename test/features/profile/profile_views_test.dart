import 'package:bloc_test/bloc_test.dart';
import 'package:evently/domain/model/user_profile.dart';
import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/features/following/cubit/following_cubit.dart';
import 'package:evently/features/following/following_page.dart';
import 'package:evently/features/profile/cubit/profile_cubit.dart';
import 'package:evently/features/profile/cubit/profile_state.dart';
import 'package:evently/features/profile/profile_page.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_cubit.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_state.dart';
import 'package:evently/features/profile_edit/profile_edit_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/catalog_fixtures.dart';
import '../../helpers/event_card_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockFollowingCubit extends MockCubit<List<FollowedOrganizer>?>
    implements FollowingCubit {}

class _MockProfileEditCubit extends MockCubit<ProfileEditState>
    implements ProfileEditCubit {}

void main() {
  Future<void> pumpWith<C extends StateStreamableSource<Object?>>(
    WidgetTester tester,
    C cubit,
    Widget view,
  ) {
    tester.view
      ..physicalSize = const Size(1170, 4000)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    return tester.pumpThemed(BlocProvider<C>.value(value: cubit, child: view));
  }

  group('Profile', () {
    late _MockProfileCubit cubit;

    setUp(() => cubit = _MockProfileCubit());

    testWidgets('who you are, and your counts in words', (tester) async {
      when(() => cubit.state).thenReturn(
        const ProfileState(
          loading: false,
          profile: UserProfile(name: 'Sara Ahmed', email: 'sara@example.com'),
          counts: ProfileCounts(
            upcomingTickets: 1,
            savedEvents: 4,
            organizersFollowed: 2,
          ),
        ),
      );
      await pumpWith<ProfileCubit>(tester, cubit, const ProfileView());

      expect(find.text('Sara Ahmed'), findsOneWidget);
      expect(find.text('SA'), findsOneWidget);
      expect(find.text('1 upcoming ticket'), findsOneWidget);
      expect(find.text('4 saved events'), findsOneWidget);
      expect(find.text('2 organizers followed'), findsOneWidget);
      expect(find.text('0 sessions bookmarked'), findsOneWidget);
    });

    testWidgets('no profile yet: a way to add one', (tester) async {
      when(() => cubit.state).thenReturn(const ProfileState(loading: false));
      await pumpWith<ProfileCubit>(tester, cubit, const ProfileView());

      expect(find.text('No profile yet'), findsOneWidget);
      expect(find.text('Add your profile'), findsOneWidget);
    });
  });

  group('Following', () {
    late _MockFollowingCubit cubit;

    setUp(() => cubit = _MockFollowingCubit());

    testWidgets('each organizer with their next event', (tester) async {
      when(() => cubit.state).thenReturn([
        FollowedOrganizer(
          organizer: organizer().copyWith(name: 'Flutter London'),
          nextEvent: card(event(title: 'State of Flutter')),
        ),
        FollowedOrganizer(organizer: organizer('org_2')),
      ]);
      await pumpWith<FollowingCubit>(tester, cubit, const FollowingView());

      expect(find.text('Flutter London'), findsOneWidget);
      expect(find.textContaining('Next: State of Flutter'), findsOneWidget);
      expect(find.text('Nothing coming up'), findsOneWidget);
    });

    testWidgets('nobody followed: says how', (tester) async {
      when(() => cubit.state).thenReturn(const []);
      await pumpWith<FollowingCubit>(tester, cubit, const FollowingView());

      expect(find.text("You don't follow anyone yet"), findsOneWidget);
    });
  });

  group('Edit profile', () {
    late _MockProfileEditCubit cubit;
    late List<String> closed;

    const editing = ProfileEditState(
      status: ProfileEditStatus.editing,
      original: UserProfile(name: 'Sara', email: 'sara@example.com'),
      name: 'Sara',
      email: 'sara@example.com',
    );

    setUp(() {
      cubit = _MockProfileEditCubit();
      closed = [];
      when(() => cubit.save()).thenAnswer((_) async {});
    });

    Future<void> pumpEdit(WidgetTester tester, ProfileEditState state) {
      when(() => cubit.state).thenReturn(state);
      return pumpWith<ProfileEditCubit>(
        tester,
        cubit,
        ProfileEditView(onClose: () => closed.add('closed')),
      );
    }

    testWidgets('the fields, and Save', (tester) async {
      await pumpEdit(tester, editing);

      expect(find.widgetWithText(TextField, 'Sara'), findsOneWidget);
      await tester.tap(find.text('Save'));
      verify(() => cubit.save()).called(1);
    });

    testWidgets('errors after a Save', (tester) async {
      await pumpEdit(tester, editing.copyWith(email: 'sara', showErrors: true));

      expect(find.text('Enter an email like name@example.com.'), findsOne);
    });

    testWidgets('Close with nothing changed: closes', (tester) async {
      await pumpEdit(tester, editing);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(closed, ['closed']);
    });

    testWidgets('Close with changes: asks; Keep editing stays', (tester) async {
      await pumpEdit(tester, editing.copyWith(name: 'Sara A.'));

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Discard changes?'), findsOneWidget);
      await tester.tap(find.text('Keep editing'));
      await tester.pumpAndSettle();

      expect(closed, isEmpty);
    });

    testWidgets('Close with changes, Discard: closes', (tester) async {
      await pumpEdit(tester, editing.copyWith(name: 'Sara A.'));

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();

      expect(closed, ['closed']);
    });

    testWidgets('saving: a spinner, the fields locked', (tester) async {
      await pumpEdit(
        tester,
        editing.copyWith(status: ProfileEditStatus.saving),
      );

      expect(find.bySemanticsLabel('Saving'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField).first).enabled,
        false,
      );
    });
  });
}
