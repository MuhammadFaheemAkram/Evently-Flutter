import 'package:evently/core/design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

double contrast(Color a, Color b) {
  final (hi, lo) = (a.computeLuminance(), b.computeLuminance());
  return hi > lo ? (hi + 0.05) / (lo + 0.05) : (lo + 0.05) / (hi + 0.05);
}

void main() {
  group('AppTheme', () {
    test('builds Material 3 light and dark themes from the seed', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();

      expect(light.useMaterial3, isTrue);
      expect(light.colorScheme.brightness, Brightness.light);
      expect(dark.colorScheme.brightness, Brightness.dark);
    });

    test('registers the matching AppColors extension for each brightness', () {
      expect(AppTheme.light().extension<AppColors>(), same(AppColors.light));
      expect(AppTheme.dark().extension<AppColors>(), same(AppColors.dark));
    });

    test('any scheme can drive it (dynamic color will)', () {
      final scheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: Brightness.dark,
      );

      final theme = AppTheme.fromScheme(scheme);

      expect(theme.colorScheme, scheme);
      expect(theme.extension<AppColors>(), same(AppColors.dark));
    });
  });

  group('AppColors', () {
    test('lerp interpolates every token', () {
      final mid = AppColors.light.lerp(AppColors.dark, 0.5);

      Color? halfway(Color Function(AppColors) token) =>
          Color.lerp(token(AppColors.light), token(AppColors.dark), 0.5);
      expect(mid.going, halfway((c) => c.going));
      expect(mid.soldOut, halfway((c) => c.soldOut));
      expect(mid.moved, halfway((c) => c.moved));
      expect(mid.cancelled, halfway((c) => c.cancelled));
    });

    test('lerp towards a missing extension keeps the current colors', () {
      expect(AppColors.light.lerp(null, 0.5), same(AppColors.light));
    });

    test('copyWith replaces only the given tokens', () {
      const purple = Color(0xFF7B1FA2);
      final copy = AppColors.light.copyWith(moved: purple);

      expect(copy.moved, purple);
      expect(copy.going, AppColors.light.going);
      expect(copy.cancelled, AppColors.light.cancelled);
    });
  });

  // WCAG contrast checks, so a color tweak can't silently make a label
  // unreadable. The state colors are text and icon colors on the page, on
  // cards and on filled fields, so each must reach AA (4.5:1) on all of
  // them.
  group('Contrast in both themes', () {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      final name = theme.colorScheme.brightness.name;
      final colors = theme.extension<AppColors>()!;
      final scheme = theme.colorScheme;
      final surfaces = {
        'the page': scheme.surface,
        'a card': scheme.surfaceContainerLow,
        'a filled field': scheme.surfaceContainerHighest,
      };

      for (final (token, color) in [
        ('going', colors.going),
        ('sold out', colors.soldOut),
        ('moved', colors.moved),
        ('cancelled', colors.cancelled),
      ]) {
        for (final MapEntry(key: surface, value: background)
            in surfaces.entries) {
          test('$name: $token text on $surface meets AA (4.5:1)', () {
            expect(contrast(color, background), greaterThanOrEqualTo(4.5));
          });
        }
      }
    }
  });

  group('CategoryPalette', () {
    test('the eight categories, in the order the row shows them', () {
      expect(CategoryPalette.names, [
        'technology',
        'business',
        'design',
        'sports',
        'education',
        'music',
        'community',
        'health',
      ]);
    });

    for (final brightness in Brightness.values) {
      for (final name in CategoryPalette.names) {
        test('${brightness.name}: $name is readable on itself (AA)', () {
          final style = CategoryPalette.style(name, brightness);
          expect(
            contrast(style.onContainer, style.container),
            greaterThanOrEqualTo(4.5),
          );
        });
      }
    }

    test('each category has its own icon', () {
      final icons = {
        for (final name in CategoryPalette.names)
          CategoryPalette.style(name, Brightness.light).icon,
      };
      expect(icons, hasLength(CategoryPalette.names.length));
    });

    test('styles are cached, and an unknown name falls back', () {
      final tech = CategoryPalette.style('technology', Brightness.light);

      expect(CategoryPalette.style('technology', Brightness.light), same(tech));
      final unknown = CategoryPalette.style('knitting', Brightness.light);
      expect(unknown.container, tech.container);
      expect(unknown.icon, tech.icon);
    });

    test('light and dark styles differ', () {
      expect(
        CategoryPalette.style('music', Brightness.light).container,
        isNot(CategoryPalette.style('music', Brightness.dark).container),
      );
    });
  });
}
