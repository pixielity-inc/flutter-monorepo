// ignore_for_file: lines_longer_than_80_chars
// lib/src/ui_scope.dart
//
// UiScope — InheritedWidget that provides ThemeRegistry, ThemeService,
// and ThemeModeService to the entire widget tree without manual passing.
//
// Place UiScope at the root (inside ProviderScope, above MaterialApp).
// Any widget can then read services via context extensions:
//
//   context.registry        // ThemeRegistry
//   context.themeService    // ThemeService
//   context.themeModeService // ThemeModeService
//
// Usage:
//   UiScope(
//     registry: App.make<ThemeRegistry>(),
//     themeService: App.make<ThemeService>(),
//     themeModeService: App.make<ThemeModeService>(),
//     child: const AppWidget(),
//   )
//
// In widgets (no manual passing needed):
//   final registry = context.registry;
//   final palette  = context.themeService.palette;

import 'package:flutter/widgets.dart';
import 'package:ui/src/registry/theme_registry.dart';
import 'package:ui/src/services/theme_mode_service.dart';
import 'package:ui/src/services/theme_service.dart';

/// InheritedWidget that provides UI services to the widget tree.
///
/// Wrap your root widget with [UiScope] so all descendant widgets can
/// access [ThemeRegistry], [ThemeService], and [ThemeModeService] via
/// [BuildContext] extensions — no manual constructor passing needed.
///
/// ```dart
/// // In main.dart
/// runApp(
///   ProviderScope(
///     overrides: themeOverrides,
///     child: UiScope(
///       registry: App.make<ThemeRegistry>(),
///       themeService: App.make<ThemeService>(),
///       themeModeService: App.make<ThemeModeService>(),
///       child: const AppWidget(),
///     ),
///   ),
/// );
///
/// // In any widget
/// final registry = context.registry;
/// final palette  = context.themeService.palette;
/// context.themeModeService.toggle();
/// ```
class UiScope extends InheritedWidget {
  /// Creates a [UiScope].
  const UiScope({
    required this.registry,
    required this.themeService,
    required this.themeModeService,
    required super.child,
    super.key,
  });

  /// The theme registry — holds all registered [FThemeData] instances.
  final ThemeRegistry registry;

  /// The theme service — get/set palette, brightness, fontScale, grayBase.
  final ThemeService themeService;

  /// The theme mode service — toggle, cycle, force brightness mode.
  final ThemeModeService themeModeService;

  /// Returns the [UiScope] from the nearest ancestor.
  ///
  /// Throws [FlutterError] if no [UiScope] is found in the tree.
  static UiScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<UiScope>();
    assert(
      scope != null,
      'UiScope not found in the widget tree.\n'
      'Make sure UiScope wraps your root widget in main.dart.',
    );
    return scope!;
  }

  /// Returns the [UiScope] without subscribing to updates.
  static UiScope? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<UiScope>();

  @override
  bool updateShouldNotify(UiScope oldWidget) =>
      registry != oldWidget.registry ||
      themeService != oldWidget.themeService ||
      themeModeService != oldWidget.themeModeService;
}

// ── BuildContext extensions ───────────────────────────────────────────────────

/// Convenience extensions on [BuildContext] for accessing UI services.
extension UiScopeX on BuildContext {
  /*
  |--------------------------------------------------------------------------
  | registry
  |--------------------------------------------------------------------------
  |
  | The ThemeRegistry from the nearest UiScope ancestor.
  | Contains all registered FThemeData instances (built-in + custom).
  |
  */

  /// The [ThemeRegistry] from the nearest [UiScope].
  ThemeRegistry get registry => UiScope.of(this).registry;

  /*
  |--------------------------------------------------------------------------
  | themeService
  |--------------------------------------------------------------------------
  |
  | The ThemeService from the nearest UiScope ancestor.
  | Use to read/write palette, brightness, fontScale, grayBase.
  |
  */

  /// The [ThemeService] from the nearest [UiScope].
  ThemeService get themeService => UiScope.of(this).themeService;

  /*
  |--------------------------------------------------------------------------
  | themeModeService
  |--------------------------------------------------------------------------
  |
  | The ThemeModeService from the nearest UiScope ancestor.
  | Use to toggle, cycle, or force brightness mode.
  |
  */

  /// The [ThemeModeService] from the nearest [UiScope].
  ThemeModeService get themeModeService => UiScope.of(this).themeModeService;
}
