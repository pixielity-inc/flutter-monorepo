// lib/src/widgets/app_status_badge.dart
//
// AppStatusBadge — a semantic status badge that uses AppThemeExtension
// status colors (success, warning, info, error/destructive).
//
// Unlike Forui's FBadge which uses primary/secondary/destructive variants,
// this widget maps directly to the four semantic status colors defined in
// AppThemeExtension, making it easy to communicate state at a glance.
//
// Usage:
//   AppStatusBadge(status: AppStatus.success, label: 'Active')
//   AppStatusBadge(status: AppStatus.warning, label: 'Pending')
//   AppStatusBadge(status: AppStatus.error,   label: 'Failed')
//   AppStatusBadge(status: AppStatus.info,    label: 'Draft')

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/theme/app_theme_context.dart';
import 'package:ui/src/tokens/app_radius.dart';
import 'package:ui/src/tokens/app_spacing.dart';

/// The semantic status variants available for [AppStatusBadge].
enum AppStatus {
  /// Indicates a successful or positive state.
  success,

  /// Indicates a cautionary or pending state.
  warning,

  /// Indicates an error or destructive state.
  error,

  /// Indicates an informational or neutral state.
  info,
}

/// A small pill-shaped badge that communicates semantic status.
///
/// The background and foreground colors are sourced from AppThemeExtension
/// (for success, warning, info) or FColors (for error/destructive), ensuring
/// they always match the active theme.
///
/// {@tool snippet}
/// ```dart
/// AppStatusBadge(status: AppStatus.success, label: 'Deployed')
/// ```
/// {@end-tool}
class AppStatusBadge extends StatelessWidget {
  /// Creates an [AppStatusBadge].
  const AppStatusBadge({
    required this.status,
    required this.label,
    this.icon,
    super.key,
  });

  /// The semantic status this badge represents.
  final AppStatus status;

  /// The text label displayed inside the badge.
  final String label;

  /// Optional leading icon displayed before the label.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final colors = context.theme.colors;
    final typography = context.theme.typography;

    // Resolve background and foreground colors from the active theme.
    final (bg, fg) = switch (status) {
      AppStatus.success => (ext.success, ext.successForeground),
      AppStatus.warning => (ext.warning, ext.warningForeground),
      AppStatus.info => (ext.info, ext.infoForeground),
      AppStatus.error => (colors.destructive, colors.destructiveForeground),
    };

    return DecoratedBox(
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.asFull),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md2,
          vertical: AppSpacing.xs2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            if (icon != null) Icon(icon, size: 12, color: fg),
            Text(
              label,
              style: typography.xs.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
