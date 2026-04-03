// lib/src/theme/app_theme.dart
//
// AppTheme — builds FThemeData from the Config registry or from presets.
//
// Two ways to get a theme:
//
//   1. Config-driven (recommended):
//      final theme = AppTheme.fromConfig(brightness: Brightness.dark);
//      Reads every visual token from Config.get('theme.*') so the entire
//      UI is controlled from apps/<app>/config/theme.dart.
//
//   2. Preset (fallback / testing):
//      final theme = AppTheme.forPlatform(brightness: Brightness.dark);
//      Uses hardcoded violet base with default tokens.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_ui/src/theme/app_theme_extension.dart';

/// Builds and vends [FThemeData] instances for the Pixielity design system.
abstract final class AppTheme {
  // ── Config-driven builder ─────────────────────────────────────────────────

  /// Builds [FThemeData] from the loaded Config registry.
  ///
  /// Reads `theme.*` keys from Config to resolve the base palette,
  /// brightness, platform variant, color overrides, typography, style,
  /// and status color tokens.
  ///
  /// Falls back to [forPlatform] if Config is not loaded.
  static FThemeData fromConfig({required Brightness brightness}) {
    try {
      // Lazy import to avoid hard dep on pixielity_config in pixielity_ui.
      // Config is accessed via dynamic to keep the package decoupled.
      final config = _ConfigBridge.instance;
      if (config == null) return forPlatform(brightness: brightness);

      final base = config.getString('theme.base', fallback: 'violet');
      final variant = config.getString(
        'theme.platformVariant',
        fallback: 'auto',
      );
      final fontFamily = config.getString(
        'theme.typography.fontFamily',
        fallback: '',
      );
      final sizeScalar = config.getDouble(
        'theme.typography.sizeScalar',
        fallback: 1,
      );

      final isTouch = switch (variant) {
        'touch' => true,
        'desktop' => false,
        _ => _touchPlatforms.contains(defaultTargetPlatform),
      };

      // Resolve the Forui base theme.
      final baseTheme = _resolveBase(base, brightness, isTouch);

      // Apply typography overrides.
      var typography = baseTheme.typography;
      if (fontFamily.isNotEmpty && fontFamily != 'packages/forui/Inter') {
        typography = typography.copyWith(
          xs3: TextStyle(fontFamily: fontFamily),
          xs2: TextStyle(fontFamily: fontFamily),
          xs: TextStyle(fontFamily: fontFamily),
          sm: TextStyle(fontFamily: fontFamily),
          md: TextStyle(fontFamily: fontFamily),
          lg: TextStyle(fontFamily: fontFamily),
          xl: TextStyle(fontFamily: fontFamily),
          xl2: TextStyle(fontFamily: fontFamily),
          xl3: TextStyle(fontFamily: fontFamily),
          xl4: TextStyle(fontFamily: fontFamily),
        );
      }
      if (sizeScalar != 1.0) {
        typography = typography.scale(sizeScalar: sizeScalar);
      }

      // Apply style overrides.
      final borderRadiusSm = config.getDouble(
        'theme.style.borderRadius.sm',
        fallback: 0,
      );
      final borderRadiusMd = config.getDouble(
        'theme.style.borderRadius.md',
        fallback: 0,
      );
      final borderRadiusLg = config.getDouble(
        'theme.style.borderRadius.lg',
        fallback: 0,
      );
      final borderWidth = config.getDouble(
        'theme.style.borderWidth',
        fallback: 0,
      );

      var style = baseTheme.style;
      if (borderRadiusSm > 0 || borderRadiusMd > 0 || borderRadiusLg > 0) {
        style = style.copyWith(
          borderRadius: FBorderRadius(
            sm: BorderRadius.circular(borderRadiusSm > 0 ? borderRadiusSm : 4),
            md: BorderRadius.circular(borderRadiusMd > 0 ? borderRadiusMd : 8),
            lg: BorderRadius.circular(borderRadiusLg > 0 ? borderRadiusLg : 12),
          ),
        );
      }
      if (borderWidth > 0) {
        style = style.copyWith(borderWidth: borderWidth);
      }

      // Build AppThemeExtension from status color config.
      final modeKey = brightness == Brightness.dark ? 'dark' : 'light';
      final defaults = brightness == Brightness.dark
          ? AppThemeExtension.dark
          : AppThemeExtension.light;

      final ext = defaults.copyWith(
        success: _colorOrNull(
          config.getInt('theme.statusColors.$modeKey.success', fallback: 0),
        ),
        successForeground: _colorOrNull(
          config.getInt(
            'theme.statusColors.$modeKey.successForeground',
            fallback: 0,
          ),
        ),
        warning: _colorOrNull(
          config.getInt('theme.statusColors.$modeKey.warning', fallback: 0),
        ),
        warningForeground: _colorOrNull(
          config.getInt(
            'theme.statusColors.$modeKey.warningForeground',
            fallback: 0,
          ),
        ),
        info: _colorOrNull(
          config.getInt('theme.statusColors.$modeKey.info', fallback: 0),
        ),
        infoForeground: _colorOrNull(
          config.getInt(
            'theme.statusColors.$modeKey.infoForeground',
            fallback: 0,
          ),
        ),
        hoverOverlay: _colorOrNull(
          config.getInt(
            'theme.statusColors.$modeKey.hoverOverlay',
            fallback: 0,
          ),
        ),
        pressedOverlay: _colorOrNull(
          config.getInt(
            'theme.statusColors.$modeKey.pressedOverlay',
            fallback: 0,
          ),
        ),
      );

      return baseTheme
          .copyWith(typography: typography, style: style)
          .copyWith(extensions: [ext]);
    } catch (_) {
      // Config not loaded or key missing — fall back to preset.
      return forPlatform(brightness: brightness);
    }
  }

  // ── Preset builders ───────────────────────────────────────────────────────

  /// Returns the correct [FThemeData] for the current platform and brightness.
  ///
  /// Uses the violet base theme with default tokens. Prefer [fromConfig]
  /// in production so the theme is controlled from config/theme.dart.
  static FThemeData forPlatform({Brightness brightness = Brightness.light}) {
    final isTouch = _touchPlatforms.contains(defaultTargetPlatform);
    return switch ((brightness, isTouch)) {
      (Brightness.light, true) => lightTouch,
      (Brightness.light, false) => lightDesktop,
      (Brightness.dark, true) => darkTouch,
      _ => darkDesktop,
    };
  }

  /// Light touch preset.
  static FThemeData get lightTouch =>
      _build(FThemes.violet.light.touch, AppThemeExtension.light);

  /// Dark touch preset.
  static FThemeData get darkTouch =>
      _build(FThemes.violet.dark.touch, AppThemeExtension.dark);

  /// Light desktop preset.
  static FThemeData get lightDesktop =>
      _build(FThemes.violet.light.desktop, AppThemeExtension.light);

  /// Dark desktop preset.
  static FThemeData get darkDesktop =>
      _build(FThemes.violet.dark.desktop, AppThemeExtension.dark);

  // ── Internal ──────────────────────────────────────────────────────────────

  static const Set<TargetPlatform> _touchPlatforms = {
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.fuchsia,
  };

  static FThemeData _build(FThemeData base, AppThemeExtension ext) =>
      base.copyWith(extensions: [ext]);

  /// Resolves the Forui base theme from a string name.
  static FThemeData _resolveBase(
    String base,
    Brightness brightness,
    bool touch,
  ) {
    final palette = switch (base) {
      'neutral' => FThemes.neutral,
      'zinc' => FThemes.zinc,
      'slate' => FThemes.slate,
      'blue' => FThemes.blue,
      'green' => FThemes.green,
      'orange' => FThemes.orange,
      'red' => FThemes.red,
      'rose' => FThemes.rose,
      'yellow' => FThemes.yellow,
      _ => FThemes.violet,
    };
    final variant = brightness == Brightness.dark
        ? palette.dark
        : palette.light;
    return touch ? variant.touch : variant.desktop;
  }

  /// Returns a [Color] from an int value, or null if the value is 0.
  static Color? _colorOrNull(int value) => value == 0 ? null : Color(value);
}

// ── Config bridge ─────────────────────────────────────────────────────────────
// A thin adapter so pixielity_ui can read from pixielity_config without
// a hard package dependency. The app registers the bridge in main.dart.

/// Adapter interface for reading config values.
///
/// Implement this and register via [ConfigBridge.register] in main.dart
/// so [AppTheme.fromConfig] can read from the Config registry.
abstract class ConfigBridge {
  /// Registers the active [ConfigBridge] implementation.
  static void register(ConfigBridge bridge) => _ConfigBridge._instance = bridge;

  /// Returns a String config value.
  String getString(String key, {required String fallback});

  /// Returns a double config value.
  double getDouble(String key, {required double fallback});

  /// Returns an int config value.
  int getInt(String key, {required int fallback});
}

class _ConfigBridge {
  static ConfigBridge? _instance;
  static ConfigBridge? get instance => _instance;
}
