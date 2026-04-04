// lib/src/theme/app_theme_context.dart
//
// AppThemeX — BuildContext extension for convenient Pixielity theme access.
//
// Usage:
//   final ext = context.appTheme;
//   ext.success          // Color
//   ext.spacing.md       // 16.0
//   ext.radius.lg        // BorderRadius.circular(12)
//   ext.shadows.sm       // List<BoxShadow>
//   ext.durations.normal // Duration(milliseconds: 200)
//   ext.curves.enter     // Curves.easeOut
//
// See also:
//   - AppThemeExtension — the ThemeExtension class.
//   - AppTheme          — builds the FThemeData instances.

import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/theme/app_theme_extension.dart';

/// Convenience extension on [BuildContext] for accessing Pixielity theme data.
///
/// Extends [BuildContext] directly so the getter is available everywhere
/// without needing to import a separate mixin or wrapper type.
extension AppThemeX on BuildContext {
  /// Returns the [AppThemeExtension] attached to the current FThemeData.
  ///
  /// Always present when AppTheme is used to build themes, since it always
  /// attaches the extension via FThemeData extensions parameter.
  AppThemeExtension get appTheme =>
      FTheme.of(this).extension<AppThemeExtension>();
}
