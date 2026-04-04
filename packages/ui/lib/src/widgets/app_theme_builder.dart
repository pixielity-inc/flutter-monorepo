// lib/src/widgets/app_theme_builder.dart
//
// AppThemeBuilder — a convenience widget that rebuilds its subtree whenever
// the active FThemeData changes.
//
// Useful when you need to pass both FThemeData and AppThemeExtension into a
// builder function without calling context.theme / context.appTheme multiple
// times.
//
// Usage:
//   AppThemeBuilder(
//     builder: (context, theme, ext) => ColoredBox(
//       color: ext.success,
//       child: Text('OK', style: theme.typography.sm),
//     ),
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/theme/app_theme_context.dart';
import 'package:ui/src/theme/app_theme_extension.dart';

/// Signature for the builder callback used by [AppThemeBuilder].
///
/// - [context]   — the current [BuildContext].
/// - [theme]     — the active FThemeData (colors, typography, style, etc.).
/// - [extension] — the active AppThemeExtension (status colors, spacing, …).
typedef AppThemeWidgetBuilder =
    Widget Function(
      BuildContext context,
      FThemeData theme,
      AppThemeExtension extension,
    );

/// A widget that exposes both FThemeData and AppThemeExtension to its
/// [builder] callback, rebuilding whenever the theme changes.
///
/// This is a thin convenience wrapper — it does not introduce any additional
/// state or lifecycle. It simply calls `context.theme` and `context.appTheme`
/// and passes them to [builder].
///
/// {@tool snippet}
/// ```dart
/// AppThemeBuilder(
///   builder: (context, theme, ext) {
///     return Container(
///       color: ext.success,
///       padding: EdgeInsets.all(ext.spacing.md),
///       child: Text(
///         'Success',
///         style: theme.typography.sm.copyWith(
///           color: ext.successForeground,
///         ),
///       ),
///     );
///   },
/// )
/// ```
/// {@end-tool}
class AppThemeBuilder extends StatelessWidget {
  /// Creates an [AppThemeBuilder].
  const AppThemeBuilder({required this.builder, super.key});

  /// The builder callback that receives the active theme and extension.
  final AppThemeWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.theme, context.appTheme);
  }
}
