// lib/src/widgets/app_section_header.dart
//
// AppSectionHeader — a consistent section heading widget that pairs a title
// with an optional subtitle and trailing action widget.
//
// Reads typography and color tokens directly from FThemeData so it
// automatically adapts to light/dark mode and touch/desktop variants.
//
// Usage:
//   AppSectionHeader(
//     title: 'Recent Activity',
//     subtitle: 'Last 7 days',
//     trailing: FButton(onPress: () {}, child: Text('See all')),
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/tokens/app_spacing.dart';

/// A section heading with an optional subtitle and trailing action.
///
/// Typically placed above a list, grid, or group of cards to label the
/// content below. The [trailing] slot is ideal for "See all" links or
/// filter buttons.
///
/// {@tool snippet}
/// ```dart
/// AppSectionHeader(
///   title: 'Packages',
///   subtitle: '3 packages in this workspace',
///   trailing: FButton(
///     variant: FButtonVariant.ghost,
///     onPress: () {},
///     child: const Text('View all'),
///   ),
/// )
/// ```
/// {@end-tool}
class AppSectionHeader extends StatelessWidget {
  /// Creates an [AppSectionHeader].
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    this.bottomSpacing = AppSpacing.md,
    super.key,
  });

  /// The primary heading text.
  final String title;

  /// Optional secondary text displayed below [title].
  final String? subtitle;

  /// Optional widget aligned to the trailing (right) edge.
  final Widget? trailing;

  /// Bottom padding between this header and the content below it.
  /// Defaults to [AppSpacing.md].
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;
    final colors = context.theme.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + subtitle column.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: typography.lg.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs2),
                  Text(
                    subtitle!,
                    style: typography.sm.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Trailing action.
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
