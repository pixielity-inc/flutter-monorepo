// ignore_for_file: lines_longer_than_80_chars
// lib/src/services/theme_service.dart
//
// ThemeService — get/set all theme tokens at runtime.
//
// Plain class, no singleton. Register via UiServiceProvider and resolve
// via App.make<ThemeService>() or context.uiScope.themeService.
//
// Usage:
//   final svc = App.make<ThemeService>();
//   svc.setPalette('rose');
//   svc.setBrightness(AppBrightnessMode.light);
//   svc.setFontScale(1.2);
//   svc.setGrayBase(0.1);

import 'package:flutter/foundation.dart';
import 'package:ui/src/widgets/theme/app_brightness_selector.dart';

/// Service for reading and writing all theme tokens.
///
/// Extends [ChangeNotifier] so widgets can listen for changes.
/// Register via [UiServiceProvider] and resolve via [App.make] or
/// [UiScope.of(context).themeService].
class ThemeService extends ChangeNotifier {
  /// Creates a [ThemeService] with optional initial values.
  ThemeService({
    String palette = 'violet',
    AppBrightnessMode brightness = AppBrightnessMode.system,
    double fontScale = 1.0,
    double animationScale = 1.0,
    double grayBase = 0.0,
  })  : _palette = palette,
        _brightness = brightness,
        _fontScale = fontScale,
        _animationScale = animationScale,
        _grayBase = grayBase;

  // ── State ─────────────────────────────────────────────────────────────────

  String _palette;
  AppBrightnessMode _brightness;
  double _fontScale;
  double _animationScale;
  double _grayBase;

  // ── Getters ───────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | palette
  |--------------------------------------------------------------------------
  |
  | The active Forui base palette name.
  | Supported: 'neutral', 'zinc', 'slate', 'blue', 'green', 'orange',
  |            'red', 'rose', 'violet', 'yellow', or any custom name
  |            registered in ThemeRegistry.
  |
  */

  /// The active base palette name (e.g. 'violet', 'rose').
  String get palette => _palette;

  /*
  |--------------------------------------------------------------------------
  | brightness
  |--------------------------------------------------------------------------
  |
  | The active brightness mode: system, light, or dark.
  |
  */

  /// The active brightness mode.
  AppBrightnessMode get brightness => _brightness;

  /*
  |--------------------------------------------------------------------------
  | fontScale
  |--------------------------------------------------------------------------
  |
  | The global font size multiplier. 1.0 = default.
  |
  */

  /// The active font size scalar. 1.0 = default.
  double get fontScale => _fontScale;

  /*
  |--------------------------------------------------------------------------
  | animationScale
  |--------------------------------------------------------------------------
  |
  | The global animation speed multiplier. 1.0 = default.
  |
  */

  /// The active animation speed multiplier. 1.0 = default.
  double get animationScale => _animationScale;

  /*
  |--------------------------------------------------------------------------
  | grayBase
  |--------------------------------------------------------------------------
  |
  | Controls how much of the accent hue is mixed into neutral surfaces.
  | 0.0 = pure gray. 1.0 = fully tinted.
  |
  */

  /// The active gray base value. 0.0 = pure gray, 1.0 = warm/tinted.
  double get grayBase => _grayBase;

  // ── Setters ───────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | setPalette
  |--------------------------------------------------------------------------
  */

  /// Sets the active palette and notifies listeners.
  void setPalette(String palette) {
    if (_palette == palette) return;
    _palette = palette;
    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | setBrightness
  |--------------------------------------------------------------------------
  */

  /// Sets the active brightness mode and notifies listeners.
  void setBrightness(AppBrightnessMode brightness) {
    if (_brightness == brightness) return;
    _brightness = brightness;
    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | setFontScale
  |--------------------------------------------------------------------------
  */

  /// Sets the font size scalar (clamped to 0.5–2.0) and notifies listeners.
  void setFontScale(double scale) {
    final clamped = scale.clamp(0.5, 2.0);
    if (_fontScale == clamped) return;
    _fontScale = clamped;
    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | setAnimationScale
  |--------------------------------------------------------------------------
  */

  /// Sets the animation speed multiplier (clamped to 0.0–4.0).
  void setAnimationScale(double scale) {
    final clamped = scale.clamp(0.0, 4.0);
    if (_animationScale == clamped) return;
    _animationScale = clamped;
    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | setGrayBase
  |--------------------------------------------------------------------------
  */

  /// Sets the gray base value (clamped to 0.0–1.0) and notifies listeners.
  void setGrayBase(double base) {
    final clamped = base.clamp(0.0, 1.0);
    if (_grayBase == clamped) return;
    _grayBase = clamped;
    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | setAll
  |--------------------------------------------------------------------------
  |
  | Sets all theme tokens at once and fires a single notification.
  |
  */

  /// Sets all theme tokens at once and fires a single notification.
  void setAll({
    String? palette,
    AppBrightnessMode? brightness,
    double? fontScale,
    double? animationScale,
    double? grayBase,
  }) {
    var changed = false;
    if (palette != null && _palette != palette) {
      _palette = palette; changed = true;
    }
    if (brightness != null && _brightness != brightness) {
      _brightness = brightness; changed = true;
    }
    if (fontScale != null) {
      final c = fontScale.clamp(0.5, 2.0);
      if (_fontScale != c) { _fontScale = c; changed = true; }
    }
    if (animationScale != null) {
      final c = animationScale.clamp(0.0, 4.0);
      if (_animationScale != c) { _animationScale = c; changed = true; }
    }
    if (grayBase != null) {
      final c = grayBase.clamp(0.0, 1.0);
      if (_grayBase != c) { _grayBase = c; changed = true; }
    }
    if (changed) notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | reset
  |--------------------------------------------------------------------------
  */

  /// Resets all tokens to defaults and notifies listeners.
  void reset() => setAll(
    palette: 'violet',
    brightness: AppBrightnessMode.system,
    fontScale: 1.0,
    animationScale: 1.0,
    grayBase: 0.0,
  );

  @override
  String toString() =>
      'ThemeService(palette: $_palette, brightness: ${_brightness.name}, '
      'fontScale: $_fontScale, grayBase: $_grayBase)';
}
