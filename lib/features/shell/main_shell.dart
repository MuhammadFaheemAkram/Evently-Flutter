import 'package:evently/core/navigation/app_routes.dart';
import 'package:evently/features/shell/app_navigation_drawer.dart';
import 'package:evently/features/shell/shell_drawer_scope.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Hosts the bottom [NavigationBar] and the [AppNavigationDrawer] around the
/// active tab, as in the Android edition.
///
/// [navigationShell] holds the five tab navigators in an IndexedStack; this
/// widget only decides which branch is visible. Each tab screen brings its
/// own `Scaffold` and `AppBar`; the drawer lives on *this* outer `Scaffold`
/// so it slides over the whole screen, tab bar included. Tabs open it through
/// [ShellDrawerScope] (their own `Scaffold.of` would find the inner one).
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  StatefulNavigationShell get _shell => widget.navigationShell;

  void _selectTab(int index) {
    // Re-tapping the active tab returns it to its initial location (the
    // platform convention on both Android and iOS).
    _shell.goBranch(index, initialLocation: index == _shell.currentIndex);
  }

  void _openFromDrawer(DrawerDestination destination) {
    _scaffoldKey.currentState?.closeDrawer();
    switch (destination) {
      case TabDestination(:final index):
        _selectTab(index);
      case ScreenDestination.following:
        const FollowingRoute().push<void>(context);
      case ScreenDestination.settings:
        const SettingsRoute().push<void>(context);
      case ScreenDestination.about:
        const AboutRoute().push<void>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShellDrawerScope(
      openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppNavigationDrawer(
          currentTab: _shell.currentIndex,
          onSelected: _openFromDrawer,
        ),
        body: _shell,
        // The tab labels keep their size whatever the text setting: five
        // labels share the width, and larger text would break them mid-word.
        // A long press shows the label in a tooltip, and screen readers read
        // it (the large-text rule from ConnectHub onwards).
        bottomNavigationBar: MediaQuery.withNoTextScaling(
          child: NavigationBar(
            selectedIndex: _shell.currentIndex,
            onDestinationSelected: _selectTab,
            destinations: [
              for (final tab in AppTab.values)
                NavigationDestination(
                  icon: Icon(tab.icon),
                  selectedIcon: Icon(tab.selectedIcon),
                  label: tab.label,
                  tooltip: tab.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
