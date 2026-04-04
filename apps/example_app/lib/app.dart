// ignore_for_file: lines_longer_than_80_chars
// apps/example_app/lib/app.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:config/pixielity_config.dart';
import 'package:container/pixielity_container.dart';
import 'package:pixielity_example_app/pages/home_page.dart';
import 'package:pixielity_example_app/providers/theme_providers.dart';
import 'package:ui/pixielity_ui.dart';

/// Built-in Forui palette names — go through AppTheme.fromConfig.
const Set<String> _builtInPalettes = {
  'neutral', 'zinc', 'slate', 'blue', 'green',
  'orange', 'red', 'rose', 'violet', 'yellow',
};

/// Root application widget.
class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette    = ref.watch(themePaletteProvider);
    final brightness = ref.watch(themeBrightnessProvider);
    final fontScale  = ref.watch(themeFontScaleProvider);
    final grayBase   = ref.watch(themeBaseValueProvider);

    // Build both light and dark variants so MaterialApp can switch correctly.
    final lightTheme = _buildTheme(
      palette: palette,
      brightness: Brightness.light,
      fontScale: fontScale,
      grayBase: grayBase,
    );
    final darkTheme = _buildTheme(
      palette: palette,
      brightness: Brightness.dark,
      fontScale: fontScale,
      grayBase: grayBase,
    );

    // Map AppBrightnessMode → ThemeMode for MaterialApp.
    final themeMode = switch (brightness) {
      AppBrightnessMode.light  => ThemeMode.light,
      AppBrightnessMode.dark   => ThemeMode.dark,
      AppBrightnessMode.system => ThemeMode.system,
    };

    return MaterialApp(
      title: Config.get<String>('app.name', fallback: 'Pixielity'),
      debugShowCheckedModeBanner: Config.get<bool>('app.showDebugBanner', fallback: false),
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      // Provide both variants — MaterialApp picks the right one based on
      // themeMode + OS setting. This is what drives the scaffold background.
      theme: lightTheme.toApproximateMaterialTheme(),
      darkTheme: darkTheme.toApproximateMaterialTheme(),
      themeMode: themeMode,
      // Builder wraps with FTheme using the correct variant for the
      // current resolved brightness (reactive to OS changes).
      builder: (ctx, child) {
        final platformBrightness = MediaQuery.platformBrightnessOf(ctx);
        final resolvedBrightness = resolveBrightness(brightness, platformBrightness);
        final fTheme = resolvedBrightness == Brightness.dark ? darkTheme : lightTheme;

        return FTheme(
          data: fTheme,
          child: FToaster(child: FTooltipGroup(child: child!)),
        );
      },
      home: const FScaffold(child: HomePage()),
    );
  }

  /// Builds [FThemeData] for the given parameters.
  static FThemeData _buildTheme({
    required String palette,
    required Brightness brightness,
    required double fontScale,
    required double grayBase,
  }) {
    if (_builtInPalettes.contains(palette)) {
      return AppTheme.fromConfig(
        brightness: brightness,
        palette: palette,
        fontScale: fontScale,
        grayBase: grayBase,
      );
    }

    // Custom theme from ThemeRegistry.
    final isTouch = _touchPlatforms.contains(defaultTargetPlatform);
    final registry = App.make<ThemeRegistry>();
    var theme = registry.resolve(palette, brightness: brightness, touch: isTouch);
    if (fontScale != 1.0) {
      theme = theme.copyWith(
        typography: theme.typography.scale(sizeScalar: fontScale),
      );
    }
    return theme;
  }

  static const Set<TargetPlatform> _touchPlatforms = {
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.fuchsia,
  };
}
