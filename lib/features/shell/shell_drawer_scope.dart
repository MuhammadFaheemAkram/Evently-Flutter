import 'package:material_ui/material_ui.dart';

/// Lets any screen inside the tab shell open the app's navigation drawer.
///
/// The drawer belongs to the shell's outer `Scaffold`, but a tab's
/// `Scaffold.of(context)` finds the tab's own `Scaffold` first. This scope
/// hands the shell's `openDrawer` down instead.
class ShellDrawerScope extends InheritedWidget {
  const ShellDrawerScope({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  final VoidCallback openDrawer;

  static ShellDrawerScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellDrawerScope>();

  @override
  bool updateShouldNotify(ShellDrawerScope oldWidget) => false;
}

/// The menu button at the start of every tab's app bar. Outside the shell
/// (a widget test of one screen) it shows nothing.
class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ShellDrawerScope.maybeOf(context);
    if (scope == null) return const SizedBox.shrink();
    return IconButton(
      tooltip: 'Open navigation menu',
      icon: const Icon(Icons.menu),
      onPressed: scope.openDrawer,
    );
  }
}
