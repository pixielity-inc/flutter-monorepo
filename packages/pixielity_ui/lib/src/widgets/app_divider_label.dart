// lib/src/widgets/app_divider_label.dart
//
// AppDividerLabel — a horizontal divider with a centred text label.
//
// Commonly used to separate sections with a descriptive label, e.g.
// "OR" between login options, or "Today" between message groups.
//
// Usage:
//   AppDividerLabel(label: 'OR')
//   AppDividerLabel(label: 'Today', lineColor: Colors.grey)

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_ui/src/tokens/app_spacing.dart';

/// A horizontal rule with a centred text label.
///
/// The line color defaults to FColors.border and the label color defaults
/// to FColors.mutedForeground, both sourced from the active theme.
///
/// {@tool snippet}
/// ```dart
/// const AppDividerLabel(label: 'OR')
/// ```
/// {@end-tool}
class AppDividerLabel extends StatelessWidget {
  /// Creates an [AppDividerLabel].
  const AppDividerLabel({
    required this.label,
    this.lineColor,
    this.labelColor,
    super.key,
  });

  /// The text displayed in the centre of the divider.
  final String label;

  /// Override the line color. Defaults to FColors.border.
  final Color? lineColor;

  /// Override the label text color. Defaults to FColors.mutedForeground.
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final typography = context.theme.typography;

    final effectiveLineColor = lineColor ?? colors.border;
    final effectiveLabelColor = labelColor ?? colors.mutedForeground;

    return Row(
      children: [
        Expanded(child: Divider(color: effectiveLineColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: typography.xs.copyWith(
              color: effectiveLabelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: effectiveLineColor, thickness: 1)),
      ],
    );
  }
}
