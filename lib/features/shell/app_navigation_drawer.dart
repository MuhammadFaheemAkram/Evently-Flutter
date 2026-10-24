import 'package:evently/core/design_system/design_system.dart';
import 'package:material_ui/material_ui.dart';

/// The five tabs, in the order of the shell's branches (`app_routes.dart`).
enum AppTab {
  discover('Discover', Icons.explore_outlined, Icons.explore),
  search('Search', Icons.search, Icons.saved_search),
  saved('Saved', Icons.bookmark_border, Icons.bookmark),
  tickets(
    'Tickets',
    Icons.confirmation_number_outlined,
    Icons.confirmation_number,
  ),
  profile('Profile', Icons.person_outline, Icons.person);

  const AppTab(this.label, this.icon, this.selectedIcon);

  /// The screen's name: the tab bar, its app bar and the drawer. Five share
  /// a phone's width, so each stays one short word.
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Where a drawer item leads: a tab, or a screen above the tabs.
sealed class DrawerDestination {
  const DrawerDestination();
}

final class TabDestination extends DrawerDestination {
  const TabDestination(this.index);

  final int index;
}

enum ScreenDestination implements DrawerDestination {
  following('Following', Icons.favorite_border),
  settings('Settings', Icons.settings_outlined),
  about('About', Icons.info_outline);

  const ScreenDestination(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// The Android edition's navigation drawer: the five tabs, then the screens
/// that don't fit in a bottom bar (Following, Settings), then About.
///
/// Built from `ListTile`s rather than Material's `NavigationDrawer`: its
/// destinations lay the label out in a fixed row, which overflows at large
/// text sizes, while a `ListTile` wraps and grows (conventions §11.52). The
/// tiles keep the Material 3 look (a pill-shaped indicator on the current
/// tab) and report "selected" to screen readers.
///
/// Only a tab can be selected: the other destinations push a screen above
/// the shell, and the drawer is gone by the time it shows.
class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
    required this.currentTab,
    required this.onSelected,
  });

  final int currentTab;
  final ValueChanged<DrawerDestination> onSelected;

  static const screens = [
    ScreenDestination.following,
    ScreenDestination.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      // At large text, nearly the screen's width: at the standard 304
      // points a long label breaks mid-word (seen at AX3 on an iPhone in
      // Momentum).
      width: context.prefersStackedLayout
          ? MediaQuery.sizeOf(context).width * 0.9
          : null,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xSmall),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.small,
                AppSpacing.medium,
                AppSpacing.small,
              ),
              child: Semantics(
                // Its own node: a heading flag on a merged node would make
                // everything around it a heading too.
                container: true,
                header: true,
                child: Text('Evently', style: theme.textTheme.titleLarge),
              ),
            ),
            for (final tab in AppTab.values)
              _DrawerTile(
                icon: tab.index == currentTab ? tab.selectedIcon : tab.icon,
                label: tab.label,
                selected: tab.index == currentTab,
                onTap: () => onSelected(TabDestination(tab.index)),
              ),
            const _DrawerDivider(),
            for (final screen in screens)
              _DrawerTile(
                icon: screen.icon,
                label: screen.label,
                onTap: () => onSelected(screen),
              ),
            const _DrawerDivider(),
            _DrawerTile(
              icon: ScreenDestination.about.icon,
              label: ScreenDestination.about.label,
              onTap: () => onSelected(ScreenDestination.about),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
      child: ListTile(
        shape: const StadiumBorder(),
        selected: selected,
        selectedTileColor: scheme.secondaryContainer,
        selectedColor: scheme.onSecondaryContainer,
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurfaceVariant,
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.large,
      vertical: AppSpacing.xSmall,
    ),
    child: Divider(),
  );
}
