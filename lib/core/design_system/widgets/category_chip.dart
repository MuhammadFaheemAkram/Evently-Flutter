import 'package:evently/core/design_system/theme/category_palette.dart';
import 'package:evently/domain/model/event_enums.dart';
import 'package:material_ui/material_ui.dart';

/// A category to filter by, with its icon; `null` is "All".
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onSelected,
  });

  final EventCategory? category;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final category = this.category;
    return ChoiceChip(
      avatar: category == null || selected
          ? null
          : Icon(
              CategoryPalette.style(
                category.name,
                Theme.of(context).brightness,
              ).icon,
            ),
      label: Text(category?.label ?? 'All'),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
