// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_font_scale_selector.dart
//
// AppFontScaleSelector — a slider for adjusting the global font size scalar.
//
// The scalar is a multiplier applied to all FTypography font sizes via
// FTypography.scale(sizeScalar: value). 1.0 = default, 0.8 = smaller,
// 1.2 = larger. Useful for accessibility settings.
//
// Usage:
//   AppFontScaleSelector(
//     value: 1.0,
//     onChanged: (scale) => ref.read(fontScaleProvider.notifier).state = scale,
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A slider for adjusting the global font size scalar.
///
/// The [value] is a multiplier between [min] and [max] applied to all
/// FTypography font sizes. A preview of the current scale is shown
/// alongside the slider using the active theme's typography.
///
/// {@tool snippet}
/// ```dart
/// AppFontScaleSelector(
///   value: 1.0,
///   onChanged: (scale) {
///     // Rebuild the app with the new font scale.
///   },
/// )
/// ```
/// {@end-tool}
class AppFontScaleSelector extends StatelessWidget {
  /// Creates an [AppFontScaleSelector].
  const AppFontScaleSelector({
    required this.value,
    required this.onChanged,
    this.min = 0.7,
    this.max = 1.4,
    this.divisions = 7,
    super.key,
  });

  /// The current font size scalar. 1.0 = default size.
  final double value;

  /// Called when the user adjusts the slider.
  final ValueChanged<double> onChanged;

  /// Minimum allowed scalar. Defaults to 0.7 (30% smaller).
  final double min;

  /// Maximum allowed scalar. Defaults to 1.4 (40% larger).
  final double max;

  /// Number of discrete steps on the slider. Defaults to 7.
  final int divisions;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    // Derive a label from the current value.
    final label = switch (value) {
      _ when value < 0.85 => 'XS',
      _ when value < 0.95 => 'S',
      _ when value < 1.05 => 'Default',
      _ when value < 1.15 => 'L',
      _ when value < 1.25 => 'XL',
      _                   => 'XXL',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header row ──────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Font Size',
              style: theme.typography.sm.copyWith(
                color: theme.colors.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Current scale badge
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  '$label  (${value.toStringAsFixed(2)}×)',
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Slider ──────────────────────────────────────────────────────────
        Material(
          color: Colors.transparent,
          child: SliderTheme(
          data: SliderThemeData(
            activeTrackColor: theme.colors.primary,
            inactiveTrackColor: theme.colors.muted,
            thumbColor: theme.colors.primary,
            overlayColor: theme.colors.primary.withValues(alpha: 0.12),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        ), // Material

        // ── Scale endpoints ──────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'A',
              style: theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground,
                fontSize: 10,
              ),
            ),
            Text(
              'A',
              style: theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Preview ──────────────────────────────────────────────────────────
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.muted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview',
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'The quick brown fox',
                  style: theme.typography.md.copyWith(
                    color: theme.colors.foreground,
                    fontSize: (theme.typography.md.fontSize ?? 16) * value,
                  ),
                ),
                Text(
                  'jumps over the lazy dog.',
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.mutedForeground,
                    fontSize: (theme.typography.sm.fontSize ?? 14) * value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
