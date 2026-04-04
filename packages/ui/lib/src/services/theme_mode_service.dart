// ignore_for_file: lines_longer_than_80_chars
// lib/src/services/theme_mode_service.dart
//
// ThemeModeService — dedicated service for brightness mode operations.
//
// Injected with ThemeService via constructor — no static singleton access.
// Register via UiServiceProvider and resolve via App.make<ThemeModeService>().

import 'package:flutter/material.dart';
import 'package:ui/src/services/theme_service.dart';
import 'package:ui/src/widgets/theme/app_brightness_selector.dart';

/// A dedicated service for brightness mode operations.
///
/// Delegates state storage to [ThemeService] — injected via constructor.
/// Resolve via `App.make<ThemeModeService>()`.
class ThemeModeService {
  /// Creates a [ThemeModeService] with the given [ThemeService].
  ThemeModeService(this._themeService);

  final ThemeService _themeService;

  // ── Convenience getters ───────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | current
  |--------------------------------------------------------------------------
  |
  | The currently active brightness mode.
  |
  */

  /// The currently active brightness mode.
  AppBrightnessMode get current => _themeService.brightness;

  /*
  |--------------------------------------------------------------------------
  | isDark / isLight / isSystem
  |--------------------------------------------------------------------------
  |
  | Convenience boolean checks for the current mode.
  |
  */

  /// `true` when the active mode is [AppBrightnessMode.dark].
  bool get isDark   => current == AppBrightnessMode.dark;

  /// `true` when the active mode is [AppBrightnessMode.light].
  bool get isLight  => current == AppBrightnessMode.light;

  /// `true` when the active mode is [AppBrightnessMode.system].
  bool get isSystem => current == AppBrightnessMode.system;

  /*
  |--------------------------------------------------------------------------
  | resolvedBrightness
  |--------------------------------------------------------------------------
  |
  | Returns the actual [Brightness] after resolving the system setting.
  | Pass the platform brightness from MediaQuery or the platform dispatcher.
  |
  */

  /// Resolves the actual [Brightness] given the platform brightness.
  ///
  /// ```dart
  /// final b = ThemeModeService.instance.resolvedBrightness(
  ///   WidgetsBinding.instance.platformDispatcher.platformBrightness,
  /// );
  /// ```
  Brightness resolvedBrightness(Brightness platformBrightness) {
    return switch (current) {
      AppBrightnessMode.light  => Brightness.light,
      AppBrightnessMode.dark   => Brightness.dark,
      AppBrightnessMode.system => platformBrightness,
    };
  }

  // ── Setters ───────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | setLight / setDark / setSystem
  |--------------------------------------------------------------------------
  |
  | Force a specific brightness mode.
  |
  */

  /// Forces light mode.
  void setLight()  => _themeService.setBrightness(AppBrightnessMode.light);

  /// Forces dark mode.
  void setDark()   => _themeService.setBrightness(AppBrightnessMode.dark);

  /// Follows the OS setting.
  void setSystem() => _themeService.setBrightness(AppBrightnessMode.system);

  /// Sets the brightness to [mode].
  void set(AppBrightnessMode mode) => _themeService.setBrightness(mode);

  /*
  |--------------------------------------------------------------------------
  | toggle
  |--------------------------------------------------------------------------
  |
  | Toggles between light and dark mode.
  | If the current mode is system, it switches to dark.
  |
  */

  /// Toggles between light and dark.
  ///
  /// System → dark → light → dark → …
  void toggle() {
    final next = switch (current) {
      AppBrightnessMode.light  => AppBrightnessMode.dark,
      AppBrightnessMode.dark   => AppBrightnessMode.light,
      AppBrightnessMode.system => AppBrightnessMode.dark,
    };
    _themeService.setBrightness(next);
  }

  /*
  |--------------------------------------------------------------------------
  | cycle
  |--------------------------------------------------------------------------
  |
  | Cycles through all three modes in order: system → light → dark → system.
  |
  */

  /// Cycles through system → light → dark → system.
  void cycle() {
    final next = switch (current) {
      AppBrightnessMode.system => AppBrightnessMode.light,
      AppBrightnessMode.light  => AppBrightnessMode.dark,
      AppBrightnessMode.dark   => AppBrightnessMode.system,
    };
    _themeService.setBrightness(next);
  }

  /*
  |--------------------------------------------------------------------------
  | toggleDarkLight
  |--------------------------------------------------------------------------
  |
  | Toggles strictly between dark and light, ignoring system.
  | Useful for a simple dark mode switch in settings.
  |
  */

  /// Toggles strictly between dark and light (ignores system mode).
  void toggleDarkLight() {
    final next = isDark ? AppBrightnessMode.light : AppBrightnessMode.dark;
    _themeService.setBrightness(next);
  }

  @override
  String toString() => 'ThemeModeService(current: ${current.name})';
}
