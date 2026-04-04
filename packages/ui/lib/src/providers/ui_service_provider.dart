// ignore_for_file: lines_longer_than_80_chars
// lib/src/providers/ui_service_provider.dart
//
// UiServiceProvider — the pixielity_ui service provider.
//
// Registers all built-in themes into ThemeRegistry and initialises
// ThemeService + ThemeModeService. Must be included in Application.boot()
// before any UI is rendered.
//
// Usage in main.dart:
//   await Application.boot([
//     UiServiceProvider(),   // ← always first
//     CoreServiceProvider(),
//     ApiServiceProvider(),
//   ]);
//
// After boot, the following are available:
//   ThemeRegistry.get('violet.dark.touch')
//   ThemeService.setPalette('rose')
//   ThemeModeService.toggle()

import 'package:forui/forui.dart';
import 'package:container/pixielity_container.dart';
import 'package:ui/src/registry/theme_registry.dart';
import 'package:ui/src/services/theme_mode_service.dart';
import 'package:ui/src/services/theme_service.dart';
import 'package:ui/src/theme/app_theme_extension.dart';

/// The pixielity_ui service provider.
///
/// Registers:
///   - All 10 Forui built-in palettes × 2 brightness × 2 variants (40 themes)
///     into [ThemeRegistry].
///   - [ThemeService] singleton into the IoC container.
///   - [ThemeModeService] singleton into the IoC container.
///
/// Include this as the **first** provider in [Application.boot()]:
///
/// ```dart
/// await Application.boot([
///   UiServiceProvider(),
///   CoreServiceProvider(),
///   ApiServiceProvider(),
/// ]);
/// ```
class UiServiceProvider extends ServiceProvider {
  @override
  void register() {
    /*
    |--------------------------------------------------------------------------
    | ThemeService
    |--------------------------------------------------------------------------
    |
    | Registers the ThemeService singleton into the IoC container so it can
    | be resolved via App.make<ThemeService>() anywhere in the app.
    |
    */

    App.instance<ThemeService>(ThemeService());

    /*
    |--------------------------------------------------------------------------
    | ThemeModeService
    |--------------------------------------------------------------------------
    |
    | Registers the ThemeModeService singleton into the IoC container.
    |
    */

    App.instance<ThemeModeService>(ThemeModeService(ThemeService()));

    /*
    |--------------------------------------------------------------------------
    | ThemeRegistry
    |--------------------------------------------------------------------------
    |
    | Registers the ThemeRegistry singleton into the IoC container so it
    | can be resolved via App.make<ThemeRegistry>() anywhere in the app.
    | Built-in themes are populated in boot() after all providers have run.
    |
    */

    App.instance<ThemeRegistry>(ThemeRegistry.instance);

    /*
    |--------------------------------------------------------------------------
    | ThemeRegistry — Built-in Palettes
    |--------------------------------------------------------------------------
    |
    | Registers all 10 Forui built-in palettes in 4 variants each:
    |   <palette>.light.touch
    |   <palette>.light.desktop
    |   <palette>.dark.touch
    |   <palette>.dark.desktop
    |
    | Key format: 'violet.dark.touch', 'blue.light.desktop', etc.
    |
    */

    _registerBuiltinThemes();
  }

  @override
  Future<void> boot() async {
    // Nothing async needed — all registrations are synchronous.
    // Override this if you need to load persisted theme preferences
    // and seed ThemeService before the first frame.
  }

  // ── Built-in theme registration ───────────────────────────────────────────

  /// Registers all 10 Forui palettes × 2 brightness × 2 variants.
  void _registerBuiltinThemes() {
    // Resolve from the IoC container — the same instance that was registered.
    final registry = App.make<ThemeRegistry>();

    // Clear any previous registrations (safe to call multiple times).
    registry.clear();

    final palettes = <(String, FPlatformThemeData, FPlatformThemeData)>[
      ('neutral', FThemes.neutral.light, FThemes.neutral.dark),
      ('zinc',    FThemes.zinc.light,    FThemes.zinc.dark),
      ('slate',   FThemes.slate.light,   FThemes.slate.dark),
      ('blue',    FThemes.blue.light,    FThemes.blue.dark),
      ('green',   FThemes.green.light,   FThemes.green.dark),
      ('orange',  FThemes.orange.light,  FThemes.orange.dark),
      ('red',     FThemes.red.light,     FThemes.red.dark),
      ('rose',    FThemes.rose.light,    FThemes.rose.dark),
      ('violet',  FThemes.violet.light,  FThemes.violet.dark),
      ('yellow',  FThemes.yellow.light,  FThemes.yellow.dark),
    ];

    for (final (name, light, dark) in palettes) {
      registry.set(
        '$name.light.touch',
        ThemeRegistry.withExtension(light.touch, AppThemeExtension.light),
      );
      registry.set(
        '$name.light.desktop',
        ThemeRegistry.withExtension(light.desktop, AppThemeExtension.light),
      );
      registry.set(
        '$name.dark.touch',
        ThemeRegistry.withExtension(dark.touch, AppThemeExtension.dark),
      );
      registry.set(
        '$name.dark.desktop',
        ThemeRegistry.withExtension(dark.desktop, AppThemeExtension.dark),
      );
    }
  }
}
