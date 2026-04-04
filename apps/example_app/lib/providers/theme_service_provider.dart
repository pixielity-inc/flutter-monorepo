// ignore_for_file: lines_longer_than_80_chars
// lib/providers/theme_service_provider.dart
//
// ThemeServiceProvider — registers app-specific custom themes into
// ThemeRegistry so they appear in the theme customizer alongside
// the built-in Forui palettes.
//
// Add your branded themes here. Each theme is registered under a unique
// name and becomes selectable in the palette picker.
//
// Usage:
//   await Application.boot([
//     UiServiceProvider(),        // registers built-ins + services
//     ThemeServiceProvider(),     // registers app custom themes
//     CoreServiceProvider(),
//   ]);

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:container/pixielity_container.dart';
import 'package:ui/pixielity_ui.dart';

/// Registers app-specific custom themes into [ThemeRegistry].
///
/// Custom themes appear in [AppPaletteSelector] alongside built-in palettes.
/// Each theme is registered under a name that the palette provider can select.
///
/// Register themes in [register] — they are available immediately after
/// [Application.boot] completes.
class ThemeServiceProvider extends ServiceProvider {
  @override
  void register() {
    /*
    |--------------------------------------------------------------------------
    | Pixielity Brand Theme — Light
    |--------------------------------------------------------------------------
    |
    | A custom branded theme using a deep indigo primary with warm neutrals.
    | Registered as 'pixielity.light.touch' and 'pixielity.light.desktop'.
    |
    */

    _registerPixielityTheme();

    /*
    |--------------------------------------------------------------------------
    | Midnight Theme — Dark
    |--------------------------------------------------------------------------
    |
    | A deep navy dark theme with cyan accents.
    | Registered as 'midnight.dark.touch' and 'midnight.dark.desktop'.
    |
    */

    _registerMidnightTheme();

    /*
    |--------------------------------------------------------------------------
    | Sunset Theme — Light + Dark
    |--------------------------------------------------------------------------
    |
    | A warm amber/orange theme inspired by sunset gradients.
    | Registered as 'sunset.light.touch', 'sunset.dark.touch', etc.
    |
    */

    _registerSunsetTheme();
  }

  // ── Custom theme builders ─────────────────────────────────────────────────

  /// Registers the Pixielity brand theme (indigo primary, warm neutrals).
  void _registerPixielityTheme() {
    const lightColors = FColors(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      barrier: Color(0x33000000),
      background: Color(0xFFF8F7FF), // very light indigo tint
      foreground: Color(0xFF1A1033),
      primary: Color(0xFF5B21B6), // deep violet
      primaryForeground: Color(0xFFFAFAFA),
      secondary: Color(0xFFEDE9FE),
      secondaryForeground: Color(0xFF4C1D95),
      muted: Color(0xFFF3F0FF),
      mutedForeground: Color(0xFF6D28D9),
      destructive: Color(0xFFE7000B),
      destructiveForeground: Color(0xFFFAFAFA),
      error: Color(0xFFE7000B),
      errorForeground: Color(0xFFFAFAFA),
      card: Color(0xFFFFFFFF),
      border: Color(0xFFDDD6FE),
    );

    const darkColors = FColors(
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      barrier: Color(0x33000000),
      background: Color(0xFF0D0A1A), // very dark indigo
      foreground: Color(0xFFF5F3FF),
      primary: Color(0xFF8B5CF6), // lighter violet for dark mode
      primaryForeground: Color(0xFFFAFAFA),
      secondary: Color(0xFF2E1065),
      secondaryForeground: Color(0xFFDDD6FE),
      muted: Color(0xFF1E1533),
      mutedForeground: Color(0xFFA78BFA),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFAFAFA),
      error: Color(0xFFEF4444),
      errorForeground: Color(0xFFFAFAFA),
      card: Color(0xFF150F2A),
      border: Color(0xFF2E1065),
    );

    final lightExt = AppThemeExtension.light.copyWith(
      success: const Color(0xFF059669),
      info: const Color(0xFF6366F1),
    );
    final darkExt = AppThemeExtension.dark.copyWith(
      success: const Color(0xFF34D399),
      info: const Color(0xFF818CF8),
    );

    final registry = App.make<ThemeRegistry>();

    registry.set(
      'pixielity.light.touch',
      FThemeData(
        colors: lightColors,
        typography: FThemes.violet.light.touch.typography,
        style: FThemes.violet.light.touch.style,
        touch: true,
      ).copyWith(extensions: [lightExt]),
    );
    registry.set(
      'pixielity.light.desktop',
      FThemeData(
        colors: lightColors,
        typography: FThemes.violet.light.desktop.typography,
        style: FThemes.violet.light.desktop.style,
        touch: false,
      ).copyWith(extensions: [lightExt]),
    );
    registry.set(
      'pixielity.dark.touch',
      FThemeData(
        colors: darkColors,
        typography: FThemes.violet.dark.touch.typography,
        style: FThemes.violet.dark.touch.style,
        touch: true,
      ).copyWith(extensions: [darkExt]),
    );
    registry.set(
      'pixielity.dark.desktop',
      FThemeData(
        colors: darkColors,
        typography: FThemes.violet.dark.desktop.typography,
        style: FThemes.violet.dark.desktop.style,
        touch: false,
      ).copyWith(extensions: [darkExt]),
    );
  }

  /// Registers the Midnight theme (deep navy + cyan).
  void _registerMidnightTheme() {
    const darkColors = FColors(
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      barrier: Color(0x33000000),
      background: Color(0xFF050D1A),
      foreground: Color(0xFFE2F0FF),
      primary: Color(0xFF06B6D4), // cyan
      primaryForeground: Color(0xFF050D1A),
      secondary: Color(0xFF0C1F35),
      secondaryForeground: Color(0xFF67E8F9),
      muted: Color(0xFF0A1929),
      mutedForeground: Color(0xFF67E8F9),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFAFAFA),
      error: Color(0xFFEF4444),
      errorForeground: Color(0xFFFAFAFA),
      card: Color(0xFF0A1929),
      border: Color(0xFF0E2A45),
    );

    final darkExt = AppThemeExtension.dark.copyWith(
      success: const Color(0xFF34D399),
      info: const Color(0xFF06B6D4),
    );

    final registry = App.make<ThemeRegistry>();

    registry.set(
      'midnight.dark.touch',
      FThemeData(
        colors: darkColors,
        typography: FThemes.blue.dark.touch.typography,
        style: FThemes.blue.dark.touch.style,
        touch: true,
      ).copyWith(extensions: [darkExt]),
    );

    registry.set(
      'midnight.dark.desktop',
      FThemeData(
        colors: darkColors,
        typography: FThemes.blue.dark.desktop.typography,
        style: FThemes.blue.dark.desktop.style,
        touch: false,
      ).copyWith(extensions: [darkExt]),
    );
  }

  /// Registers the Sunset theme (warm amber/orange).
  void _registerSunsetTheme() {
    const lightColors = FColors(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      barrier: Color(0x33000000),
      background: Color(0xFFFFFBF5),
      foreground: Color(0xFF1C0A00),
      primary: Color(0xFFEA580C), // orange-600
      primaryForeground: Color(0xFFFFFBF5),
      secondary: Color(0xFFFED7AA),
      secondaryForeground: Color(0xFF9A3412),
      muted: Color(0xFFFEF3C7),
      mutedForeground: Color(0xFFB45309),
      destructive: Color(0xFFDC2626),
      destructiveForeground: Color(0xFFFAFAFA),
      error: Color(0xFFDC2626),
      errorForeground: Color(0xFFFAFAFA),
      card: Color(0xFFFFFFFF),
      border: Color(0xFFFED7AA),
    );

    const darkColors = FColors(
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      barrier: Color(0x33000000),
      background: Color(0xFF1A0A00),
      foreground: Color(0xFFFFF7ED),
      primary: Color(0xFFFB923C), // orange-400
      primaryForeground: Color(0xFF1A0A00),
      secondary: Color(0xFF431407),
      secondaryForeground: Color(0xFFFED7AA),
      muted: Color(0xFF2D1200),
      mutedForeground: Color(0xFFFBBF24),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFAFAFA),
      error: Color(0xFFEF4444),
      errorForeground: Color(0xFFFAFAFA),
      card: Color(0xFF2D1200),
      border: Color(0xFF431407),
    );

    final lightExt = AppThemeExtension.light.copyWith(
      warning: const Color(0xFFF59E0B),
      success: const Color(0xFF16A34A),
    );
    final darkExt = AppThemeExtension.dark.copyWith(
      warning: const Color(0xFFFBBF24),
      success: const Color(0xFF4ADE80),
    );

    final registry = App.make<ThemeRegistry>();

    registry.set(
      'sunset.light.touch',
      FThemeData(
        colors: lightColors,
        typography: FThemes.orange.light.touch.typography,
        style: FThemes.orange.light.touch.style,
        touch: true,
      ).copyWith(extensions: [lightExt]),
    );
    registry.set(
      'sunset.light.desktop',
      FThemeData(
        colors: lightColors,
        typography: FThemes.orange.light.desktop.typography,
        style: FThemes.orange.light.desktop.style,
        touch: false,
      ).copyWith(extensions: [lightExt]),
    );
    registry.set(
      'sunset.dark.touch',
      FThemeData(
        colors: darkColors,
        typography: FThemes.orange.dark.touch.typography,
        style: FThemes.orange.dark.touch.style,
        touch: true,
      ).copyWith(extensions: [darkExt]),
    );
    registry.set(
      'sunset.dark.desktop',
      FThemeData(
        colors: darkColors,
        typography: FThemes.orange.dark.desktop.typography,
        style: FThemes.orange.dark.desktop.style,
        touch: false,
      ).copyWith(extensions: [darkExt]),
    );
  }
}
