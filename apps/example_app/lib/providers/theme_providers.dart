// ignore_for_file: lines_longer_than_80_chars
// lib/providers/theme_providers.dart
//
// Theme state providers — all 5 theme controls wired to Riverpod StateProviders
// and persisted to SharedPreferences so they survive app restarts.
//
// Every provider is watched by AppWidget so changing any value immediately
// rebuilds FTheme at the root — the entire app reflects the change.
//
// Read:
//   ref.watch(themePaletteProvider)         // 'violet'
//   ref.watch(themeBrightnessProvider)      // AppBrightnessMode.dark
//   ref.watch(themeFontScaleProvider)       // 1.0
//   ref.watch(themeAnimationScaleProvider)  // 1.0
//   ref.watch(themeBaseValueProvider)       // 0.0
//
// Write (persists automatically):
//   ref.read(themePaletteProvider.notifier).state    = 'rose';
//   ref.read(themeBrightnessProvider.notifier).state = AppBrightnessMode.dark;
//   ref.read(themeFontScaleProvider.notifier).state  = 1.2;
//   ref.read(themeBaseValueProvider.notifier).state  = 0.1;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:config/pixielity_config.dart';
import 'package:ui/pixielity_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── SharedPreferences keys ────────────────────────────────────────────────────

const String _kPalette    = 'theme.palette';
const String _kBrightness = 'theme.brightness';
const String _kFontScale  = 'theme.fontScale';
const String _kAnimScale  = 'theme.animScale';
const String _kGrayBase   = 'theme.grayBase';

// ── Persisting notifiers ──────────────────────────────────────────────────────
// Each notifier writes to SharedPreferences whenever state changes.

/// String notifier that persists to SharedPreferences.
class _StringNotifier extends StateNotifier<String> {
  _StringNotifier(super.state, this._key);
  final String _key;

  /// Updates the value and persists it to SharedPreferences.
  void update(String v) {
    state = v;
    SharedPreferences.getInstance().then((p) => p.setString(_key, v));
  }
}

/// AppBrightnessMode notifier that persists to SharedPreferences.
class _BrightnessNotifier extends StateNotifier<AppBrightnessMode> {
  _BrightnessNotifier(super.state);

  /// Updates the brightness mode and persists it to SharedPreferences.
  void update(AppBrightnessMode v) {
    state = v;
    SharedPreferences.getInstance().then((p) => p.setString(_kBrightness, v.name));
  }
}

/// Double notifier that persists to SharedPreferences.
class _DoubleNotifier extends StateNotifier<double> {
  _DoubleNotifier(super.state, this._key);
  final String _key;

  /// Updates the value and persists it to SharedPreferences.
  void update(double v) {
    state = v;
    SharedPreferences.getInstance().then((p) => p.setDouble(_key, v));
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

/// Active palette name — persisted. Watched by AppWidget.
final themePaletteProvider =
    StateNotifierProvider<_StringNotifier, String>((ref) {
  return _StringNotifier(
    Config.get<String>('theme.base', fallback: 'violet'),
    _kPalette,
  );
});

/// Active brightness mode — persisted. Watched by AppWidget.
final themeBrightnessProvider =
    StateNotifierProvider<_BrightnessNotifier, AppBrightnessMode>((ref) {
  final str = Config.get<String>('theme.brightness', fallback: 'system');
  return _BrightnessNotifier(switch (str) {
    'light' => AppBrightnessMode.light,
    'dark'  => AppBrightnessMode.dark,
    _       => AppBrightnessMode.system,
  });
});

/// Active font size scalar — persisted. Watched by AppWidget.
final themeFontScaleProvider =
    StateNotifierProvider<_DoubleNotifier, double>((ref) {
  return _DoubleNotifier(
    Config.get<double>('theme.typography.sizeScalar', fallback: 1),
    _kFontScale,
  );
});

/// Active animation speed multiplier — persisted. Watched by AppWidget.
final themeAnimationScaleProvider =
    StateNotifierProvider<_DoubleNotifier, double>((ref) {
  return _DoubleNotifier(
    Config.get<double>('theme.animation.scale', fallback: 1),
    _kAnimScale,
  );
});

/// Active gray base value (0.0 = pure gray, 1.0 = warm) — persisted.
/// Watched by AppWidget.
final themeBaseValueProvider =
    StateNotifierProvider<_DoubleNotifier, double>((ref) {
  return _DoubleNotifier(
    Config.get<double>('theme.grayBase', fallback: 0),
    _kGrayBase,
  );
});

// ── Bootstrap ─────────────────────────────────────────────────────────────────

/// Loads persisted theme values and returns Riverpod overrides.
///
/// Call once in main() before runApp() so providers start with saved values:
/// ```dart
/// final overrides = await loadThemeOverrides();
/// runApp(ProviderScope(overrides: overrides, child: const AppWidget()));
/// ```
Future<List<Override>> loadThemeOverrides() async {
  final prefs = await SharedPreferences.getInstance();

  final palette = prefs.getString(_kPalette)
      ?? Config.get<String>('theme.base', fallback: 'violet');

  final brightnessStr = prefs.getString(_kBrightness)
      ?? Config.get<String>('theme.brightness', fallback: 'system');
  final brightness = switch (brightnessStr) {
    'light' => AppBrightnessMode.light,
    'dark'  => AppBrightnessMode.dark,
    _       => AppBrightnessMode.system,
  };

  final fontScale = prefs.getDouble(_kFontScale)
      ?? Config.get<double>('theme.typography.sizeScalar', fallback: 1);
  final animScale = prefs.getDouble(_kAnimScale)
      ?? Config.get<double>('theme.animation.scale', fallback: 1);
  final grayBase  = prefs.getDouble(_kGrayBase)
      ?? Config.get<double>('theme.grayBase', fallback: 0);

  return [
    themePaletteProvider.overrideWith(
      (ref) => _StringNotifier(palette, _kPalette),
    ),
    themeBrightnessProvider.overrideWith(
      (ref) => _BrightnessNotifier(brightness),
    ),
    themeFontScaleProvider.overrideWith(
      (ref) => _DoubleNotifier(fontScale, _kFontScale),
    ),
    themeAnimationScaleProvider.overrideWith(
      (ref) => _DoubleNotifier(animScale, _kAnimScale),
    ),
    themeBaseValueProvider.overrideWith(
      (ref) => _DoubleNotifier(grayBase, _kGrayBase),
    ),
  ];
}

// ── Helper ────────────────────────────────────────────────────────────────────

/// Resolves [Brightness] from [AppBrightnessMode] and the platform setting.
Brightness resolveBrightness(
  AppBrightnessMode mode,
  Brightness platformBrightness,
) =>
    switch (mode) {
      AppBrightnessMode.light  => Brightness.light,
      AppBrightnessMode.dark   => Brightness.dark,
      AppBrightnessMode.system => platformBrightness,
    };
