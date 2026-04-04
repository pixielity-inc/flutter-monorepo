// lib/src/widgets/app_empty_state.dart
//
// AppEmptyState — a full-area empty-state placeholder widget.
//
// Displays a centred icon, title, optional description, and optional
// call-to-action button. All visual properties are sourced from the active
// FThemeData so it adapts to light/dark mode automatically.
//
// Usage:
//   AppEmptyState(
//     icon: FIcons.inbox,
//     title: 'No items yet',
//     description: 'Add your first item to get started.',
//     action: FButton(onPress: () {}, child: Text('Add item')),
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/tokens/app_spacing.dart';

/// A centred empty-state widget with icon, title, description, and action.
///
/// Use this whenever a list, grid, or data view has no content to display.
/// It provides a consistent, on-brand empty state across the app.
///
/// {@tool snippet}
/// ```dart
/// AppEmptyState(
///   icon: FIcons.packageOpen,
///   title: 'No packages',
///   description: 'Create a package to get started.',
///   action: FButton(
///     onPress: () {},
///     prefix: const Icon(FIcons.plus),
///     child: const Text('New package'),
///   ),
/// )
/// ```
/// {@end-tool}
class AppEmptyState extends StatelessWidget {
  /// Creates an [AppEmptyState].
  const AppEmptyState({
    required this.icon,
    required this.title,
    this.description,
    this.action,
    super.key,
  });

  /// The icon displayed at the top of the empty state.
  final IconData icon;

  /// The primary heading text.
  final String title;

  /// Optional supporting description text.
  final String? description;

  /// Optional call-to-action widget (typically an FButton).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;
    final colors = context.theme.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon in a muted circle.
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.muted,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Icon(icon, size: 32, color: colors.mutedForeground),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Title.
            Text(
              title,
              style: typography.lg.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            // Description.
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // Action button.
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
