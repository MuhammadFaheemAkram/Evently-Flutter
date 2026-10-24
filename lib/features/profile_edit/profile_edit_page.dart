import 'package:evently/core/design_system/design_system.dart';
import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/di/injection.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_cubit.dart';
import 'package:evently/features/profile_edit/cubit/profile_edit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileEditCubit>()..load(),
      child: ProfileEditView(
        onClose: () => Navigator.of(context).canPop()
            ? Navigator.of(context).pop()
            : const ProfileRoute().go(context),
      ),
    );
  }
}

/// Edit profile, as a full-screen dialog.
///
/// [onClose] leaves it, after a save or a confirmed discard. Leaving with
/// unsaved changes any other way (Close, the system back gesture) first
/// asks "Discard changes?", through [PopScope].
class ProfileEditView extends StatelessWidget {
  const ProfileEditView({super.key, required this.onClose});

  final VoidCallback onClose;

  Future<void> _closeAsked(BuildContext context, ProfileEditState state) async {
    if (!state.hasChanges || await _confirmDiscard(context)) onClose();
  }

  Future<bool> _confirmDiscard(BuildContext context) => showConfirmDialog(
    context,
    title: 'Discard changes?',
    message: "Your edits to your profile won't be saved.",
    confirmLabel: 'Discard',
    cancelLabel: 'Keep editing',
    destructive: true,
  );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileEditCubit>();
    return BlocConsumer<ProfileEditCubit, ProfileEditState>(
      listenWhen: (previous, current) =>
          previous.status != ProfileEditStatus.saved &&
          current.status == ProfileEditStatus.saved,
      listener: (context, state) => onClose(),
      builder: (context, state) {
        final saving = state.status == ProfileEditStatus.saving;
        return PopScope(
          // Nothing to lose, or already saved: leave freely.
          canPop: !state.hasChanges || state.status == ProfileEditStatus.saved,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (await _confirmDiscard(context)) onClose();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: CloseButton(
                onPressed: () => _closeAsked(context, state),
              ),
              title: const Text('Edit profile'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xSmall),
                  child: FilledButton(
                    onPressed: state.status == ProfileEditStatus.editing
                        ? cubit.save
                        : null,
                    child: saving
                        ? Semantics(
                            label: 'Saving',
                            child: const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
            body: state.status == ProfileEditStatus.loading
                ? const LoadingView()
                : _ProfileForm(state: state),
          ),
        );
      },
    );
  }
}

/// The three fields. Stateful only for their controllers, which start from
/// the saved profile; every change goes to the Cubit.
class _ProfileForm extends StatefulWidget {
  const _ProfileForm({required this.state});

  final ProfileEditState state;

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  late final _name = TextEditingController(text: widget.state.name);
  late final _email = TextEditingController(text: widget.state.email);
  late final _avatarUrl = TextEditingController(text: widget.state.avatarUrl);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _avatarUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileEditCubit>();
    final state = widget.state;
    final enabled = state.status == ProfileEditStatus.editing;
    final error = state.error;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      children: [
        TextField(
          controller: _name,
          enabled: enabled,
          onChanged: cubit.nameChanged,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: state.nameError,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          controller: _email,
          enabled: enabled,
          onChanged: cubit.emailChanged,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.emailError,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        TextField(
          controller: _avatarUrl,
          enabled: enabled,
          onChanged: cubit.avatarUrlChanged,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Avatar URL (optional)',
            hintText: 'https://…',
            helperText: 'Kept for a real backend; the app shows initials.',
            errorText: state.avatarUrlError,
            border: const OutlineInputBorder(),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.medium),
          Semantics(
            liveRegion: true,
            child: Text(
              error,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ],
    );
  }
}
