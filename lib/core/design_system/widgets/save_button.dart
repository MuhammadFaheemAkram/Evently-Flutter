import 'package:material_ui/material_ui.dart';

/// Save / unsave an event: a bookmark that's filled when saved. Its tooltip
/// (and label) says what a tap will do.
class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.isSaved,
    required this.onPressed,
    this.color,
  });

  final bool isSaved;
  final VoidCallback? onPressed;

  /// For a button drawn over a banner.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isSaved ? 'Remove from saved' : 'Save',
      isSelected: isSaved,
      color: color,
      icon: const Icon(Icons.bookmark_border),
      selectedIcon: const Icon(Icons.bookmark),
      onPressed: onPressed,
    );
  }
}
