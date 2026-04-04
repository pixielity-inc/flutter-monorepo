// ignore_for_file: lines_longer_than_80_chars
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
import 'package:ui/src/theme/app_theme_extension.dart';

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
  static FThemeData fromConfig({
    required Brightness brightness,
    String? palette,
    double? fontScale,
    double? grayBase,
  }) {
    try {
      final config = _ConfigBridge.instance;
      if (config == null) return forPlatform(brightness: brightness);

      // Use explicit overrides, or fall back to config values.
      final base       = palette   ?? config.getString('theme.base',                      fallback: 'violet');
      final scale      = fontScale ?? config.getDouble('theme.typography.sizeScalar',     fallback: 1);
      final baseValue  = grayBase  ?? config.getDouble('theme.grayBase',                  fallback: 0);
      final variant = config.getString(
        'theme.platformVariant',
        fallback: 'auto',
      );
      final fontFamily = config.getString(
        'theme.typography.fontFamily',
        fallback: '',
      );
      // sizeScalar: use the provider value (scale) which already falls back to config.

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
      // Apply font scale from provider (already resolved above as `scale`).
      if (scale != 1.0) {
        typography = typography.scale(sizeScalar: scale);
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

      // Apply grayBase — generate neutral surfaces with the accent hue.
      //
      // Mirrors HeroUI's approach: all neutral surfaces (background, card,
      // muted, border) share the accent color's hue but with very low chroma.
      // base=0 → pure gray (chroma=0), base=1 → subtle tint (chroma≈0.04).
      //
      // We rebuild FThemeData from scratch (not copyWith) so ALL widget
      // styles (FCardStyle, FButtonStyles, etc.) regenerate with new colors.
      var colors = baseTheme.colors;
      if (baseValue > 0) {
        colors = _applyGrayBase(colors, baseValue, brightness);
      }

      // Rebuild FThemeData so all widget styles pick up the new colors.
      final rebuiltTheme = FThemeData(
        colors: colors,
        typography: typography,
        style: style,
        touch: isTouch,
      );

      return rebuiltTheme.copyWith(extensions: [ext]);
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

  /// Applies the HeroUI-style gray base to neutral surface colors.
  ///
  /// Extracts the hue from the primary/accent color and mixes it into
  /// all neutral surfaces (background, card, muted, border) with very
  /// low saturation. base=0 → pure gray, base=1 → subtle tint.
  ///
  /// The chroma is kept very low (max ~4% saturation) so the effect is
  /// subtle — just enough to feel "warm" or "cool" rather than colored.
  static FColors _applyGrayBase(
    FColors colors,
    double base,
    Brightness brightness,
  ) {
    // Convert the primary color to get its OKLCH hue angle.
    // We approximate OKLCH hue from HSL hue (close enough for neutral tinting).
    final primaryHsl = HSLColor.fromColor(colors.primary);
    final hue = primaryHsl.hue; // 0–360

    // Map base (0–1) to OKLCH chroma range (0–0.22).
    // At chroma=0 → pure gray. At chroma=0.22 → warm/saturated like HeroUI.
    const maxChroma = 0.22;
    final chroma = base * maxChroma;

    // Generate a neutral surface color given OKLCH lightness + chroma + hue.
    // We approximate OKLCH→sRGB by:
    //   1. Keep the original surface lightness (perceptual).
    //   2. Build an HSL color with the accent hue and scaled saturation.
    //   3. The saturation in HSL ≈ chroma * 2.5 (rough OKLCH→HSL mapping).
    Color oklchSurface(Color original, {double chromaScale = 1.0}) {
      if (chroma <= 0) return original;
      final hsl = HSLColor.fromColor(original);
      final sat = (chroma * 2.5 * chromaScale).clamp(0.0, 1.0);
      return HSLColor.fromAHSL(
        hsl.alpha,
        hue,
        sat,
        hsl.lightness,
      ).toColor();
    }

    return FColors(
      brightness: colors.brightness,
      systemOverlayStyle: colors.systemOverlayStyle,
      barrier: colors.barrier,
      background: oklchSurface(colors.background),
      foreground: colors.foreground,
      primary: colors.primary,
      primaryForeground: colors.primaryForeground,
      secondary: oklchSurface(colors.secondary),
      secondaryForeground: colors.secondaryForeground,
      muted: oklchSurface(colors.muted, chromaScale: 0.4), // less tint on muted — used for field backgrounds
      mutedForeground: colors.mutedForeground,
      destructive: colors.destructive,
      destructiveForeground: colors.destructiveForeground,
      error: colors.error,
      errorForeground: colors.errorForeground,
      card: oklchSurface(colors.card),
      border: oklchSurface(colors.border),
    );
  }
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
  static set instance(ConfigBridge bridge) => _ConfigBridge._instance = bridge;

  /// Registers the active [ConfigBridge] implementation via method call.
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
