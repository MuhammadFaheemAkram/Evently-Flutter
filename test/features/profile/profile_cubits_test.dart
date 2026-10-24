import 'package:evently/domain/model/user_summary.dart';
import 'package:evently/features/following/cubit/following_cubit.dart';
import 'package:evently/features/profile/cubit/profile_cubit.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_cubit.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/data_stack.dart';
import '../../helpers/wait_for.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataStack stack;

  setUp(() {
    stack = DataStack();
    addTearDown(stack.close);
  });

  group('Profile', () {
    test("the demo's profile and counts", () async {
      await stack.loadDemo();
      final cubit = ProfileCubit(stack.watchProfile, stack.watchProfileCounts)
        ..load();
      addTearDown(cubit.close);

      final state = await waitFor(
        cubit,
        (s) => !s.loading && s.counts.savedEvents == 4,
      );

      expect(state.profile?.name, 'Sara Ahmed');
      expect(state.counts.upcomingTickets, 3);
    });

    test('a fresh start: no profile, nothing counted', () async {
      await stack.catalog.refresh();
      final cubit = ProfileCubit(stack.watchProfile, stack.watchProfileCounts)
        ..load();
      addTearDown(cubit.close);

      final state = await waitFor(cubit, (s) => !s.loading);

      expect(state.profile, isNull);
      expect(state.counts, const ProfileCounts());
    });
  });

  group('Edit profile', () {
    Future<ProfileEditCubit> opened({bool demo = true}) async {
      demo ? await stack.loadDemo() : await stack.catalog.refresh();
      final cubit = ProfileEditCubit(stack.watchProfile, stack.updateProfile)
        ..load();
      addTearDown(cubit.close);
      await waitFor(cubit, (s) => s.status == ProfileEditStatus.editing);
      return cubit;
    }

    test('starts from the saved profile, with nothing changed', () async {
      final cubit = await opened();

      expect(cubit.state.name, 'Sara Ahmed');
      expect(cubit.state.email, 'sara.ahmed@example.com');
      expect(cubit.state.hasChanges, isFalse);
    });

    test('a fresh start: an empty form', () async {
      final cubit = await opened(demo: false);

      expect(cubit.state.original, isNull);
      expect(cubit.state.name, isEmpty);
    });

    test('errors show only after Save, and nothing is saved', () async {
      final cubit = await opened()
        ..emailChanged('sara');

      expect(cubit.state.emailError, isNull);
      expect(cubit.state.hasChanges, isTrue);
      await cubit.save();

      expect(cubit.state.emailError, isNotNull);
      expect(cubit.state.status, ProfileEditStatus.editing);
      // The form stopped it: no save was tried, so no save error.
      expect(cubit.state.error, isNull);
      expect(
        (await stack.watchProfile().first)!.email,
        'sara.ahmed@example.com',
      );
    });

    test('a valid Save: saved, and the profile changes', () async {
      final cubit = await opened()
        ..nameChanged('Sara A.')
        ..avatarUrlChanged('https://example.com/sara.png');

      await cubit.save();

      expect(cubit.state.status, ProfileEditStatus.saved);
      expect((await stack.watchProfile().first)!.name, 'Sara A.');
    });

    test('typing back the saved values: no changes', () async {
      final cubit = await opened()
        ..nameChanged('Sara')
        ..nameChanged('Sara Ahmed ');

      expect(cubit.state.hasChanges, isFalse);
    });
  });

  test(
    'Following: the demo follows two organizers, with next events',
    () async {
      await stack.loadDemo();
      final cubit = FollowingCubit(stack.watchFollowing)..load();
      addTearDown(cubit.close);

      final following = await waitFor(cubit, (s) => s != null);

      expect(following!.map((f) => f.organizer.name), [
        'Berlin Design Collective',
        'Flutter London',
      ]);
      expect(following.every((f) => f.nextEvent != null), isTrue);
    },
  );
}
