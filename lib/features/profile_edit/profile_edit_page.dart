import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:material_ui/material_ui.dart';

/// The profile form, as a full-screen dialog: a placeholder until Phase 6.
///
/// Its Close button is always there, and for a deep link with nothing
/// underneath it goes to Profile (conventions §11.47).
class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  void _close(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      const ProfileRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: () => _close(context)),
        title: const Text('Edit profile'),
      ),
      body: const EmptyStateView(
        icon: Icons.manage_accounts_outlined,
        title: 'Edit profile',
        message: 'Editing your name and email arrives in Phase 6.',
      ),
    );
  }
}
