// ignore_for_file: lines_longer_than_80_chars
// lib/src/registry/theme_registry.dart
//
// ThemeRegistry — a named registry for custom FThemeData instances.
//
// This is a pure data store — it has no built-in themes pre-registered.
// Built-in Forui palettes are registered by UiServiceProvider.register()
// so the app controls when and what gets loaded.
//
// Usage:
//   // Register a custom branded theme
//   ThemeRegistry.instance.add('brand_dark', myBrandTheme);
//
//   // Retrieve
//   final theme = ThemeRegistry.instance.get('violet.dark.touch');
//
//   // List all names
//   ThemeRegistry.instance.keys;
//
//   // Resolve with fallback
//   ThemeRegistry.instance.resolve('violet', brightness: Brightness.dark);

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/registry/registry.dart';
import 'package:ui/src/theme/app_theme_extension.dart';

/// A named registry for [FThemeData].
///
/// Pure data store — no themes are pre-registered.
/// Call [UiServiceProvider.register()] to populate built-in palettes,
/// or register custom themes directly via [add] / [set].
///
/// Access the singleton via [ThemeRegistry].
///
/// ```dart
/// // Register a custom branded theme
/// ThemeRegistry.add('brand_dark', myBrandTheme);
///
/// // Retrieve
/// final theme = ThemeRegistry.get('brand_dark');
///
/// // Resolve by palette name + brightness
/// final theme = ThemeRegistry.resolve(
///   'violet',
///   brightness: Brightness.dark,
///   touch: true,
/// );
/// ```
class ThemeRegistry {
  ThemeRegistry._();

  /// The global singleton instance.
  ///
  /// Prefer resolving via the IoC container: `App.make<ThemeRegistry>()`.
  /// This singleton exists only as a fallback for contexts where the
  /// container is not available (e.g. widget build methods in pixielity_ui
  /// which cannot depend on pixielity_container).
  static final ThemeRegistry instance = ThemeRegistry._();

  final Registry<String, FThemeData> _registry = Registry();

  // ── Write ─────────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | add
  |--------------------------------------------------------------------------
  |
  | Registers [theme] under [name].
  | Throws [StateError] if [name] is already registered.
  | Use [set] to overwrite an existing entry.
  |
  */

  /// Registers [theme] under [name].
  ///
  /// Throws [StateError] if [name] is already taken. Use [set] to overwrite.
  void add(String name, FThemeData theme) => _registry.add(name, theme);

  /*
  |--------------------------------------------------------------------------
  | set
  |--------------------------------------------------------------------------
  |
  | Registers or overwrites [theme] under [name].
  |
  */

  /// Registers or overwrites [theme] under [name].
  void set(String name, FThemeData theme) => _registry.set(name, theme);

  /*
  |--------------------------------------------------------------------------
  | remove
  |--------------------------------------------------------------------------
  |
  | Removes the theme registered under [name].
  |
  */

  /// Removes the theme registered under [name].
  FThemeData? remove(String name) => _registry.remove(name);

  /// Removes all registered themes.
  void clear() => _registry.clear();

  // ── Read ──────────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | get
  |--------------------------------------------------------------------------
  |
  | Returns the [FThemeData] registered under [name].
  | Throws [StateError] if [name] is not registered.
  |
  */

  /// Returns the [FThemeData] for [name].
  ///
  /// Throws [StateError] if [name] is not registered.
  FThemeData get(String name) => _registry.get(name);

  /*
  |--------------------------------------------------------------------------
  | tryGet
  |--------------------------------------------------------------------------
  |
  | Returns the [FThemeData] for [name], or null if not registered.
  |
  */

  /// Returns the [FThemeData] for [name], or null if not registered.
  FThemeData? tryGet(String name) => _registry.tryGet(name);

  /*
  |--------------------------------------------------------------------------
  | resolve
  |--------------------------------------------------------------------------
  |
  | Resolves a theme by palette name + brightness + variant.
  | Tries the exact key first, then the built-in key format, then falls
  | back to violet dark touch if nothing matches.
  |
  */

  /// Resolves a theme by [name], [brightness], and [touch] variant.
  ///
  /// Key format tried: `'$name.$mode.$variant'`
  /// e.g. `resolve('violet', brightness: Brightness.dark)` → `'violet.dark.touch'`
  FThemeData resolve(
    String name, {
    Brightness brightness = Brightness.dark,
    bool touch = true,
  }) {
    // Try exact name first (custom themes like 'brand', 'enterprise').
    final exact = _registry.tryGet(name);
    if (exact != null) return exact;

    // Try built-in key format.
    final mode    = brightness == Brightness.dark ? 'dark' : 'light';
    final variant = touch ? 'touch' : 'desktop';
    final builtIn = _registry.tryGet('$name.$mode.$variant');
    if (builtIn != null) return builtIn;

    // Fall back to violet dark touch if registered, else throw.
    return _registry.tryGet('violet.dark.touch')
        ?? (throw StateError(
              'ThemeRegistry: no theme found for "$name". '
              'Make sure UiServiceProvider is registered in Application.boot().',
            ));
  }

  // ── Inspection ────────────────────────────────────────────────────────────

  /// Returns `true` if [name] is registered.
  bool has(String name) => _registry.has(name);

  /// All registered theme names.
  Iterable<String> get keys => _registry.keys;

  /// All registered themes.
  Iterable<FThemeData> get themes => _registry.values;

  /// The number of registered themes.
  int get length => _registry.length;

  /// All registered entries as an unmodifiable map.
  Map<String, FThemeData> get all => _registry.all;

  // ── Internal helper ───────────────────────────────────────────────────────

  /// Attaches [AppThemeExtension] to a base [FThemeData].
  static FThemeData withExtension(FThemeData base, AppThemeExtension ext) =>
      base.copyWith(extensions: [ext]);
}
