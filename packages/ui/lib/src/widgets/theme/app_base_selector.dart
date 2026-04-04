// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_base_selector.dart
//
// AppBaseSelector — a slider that controls the "base" value: how much gray
// saturation is mixed into neutral surfaces (backgrounds, cards, borders).
//
// Inspired by HeroUI's Base slider. 0.0 = pure cold gray, 1.0 = warm/tinted.
// Most apps sit between 0.0 and 0.2 for a clean, minimal look.
//
// Usage:
//   AppBaseSelector(
//     value: 0.0,
//     onChanged: (v) => ref.read(themeBaseValueProvider.notifier).state = v,
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A slider for controlling the gray saturation of neutral surfaces.
///
/// The [value] ranges from 0.0 (pure cold gray — no color tint) to 1.0
/// (fully saturated neutrals — warm, colorful). Most apps use 0.0–0.2.
///
/// Shows a gradient track from cold gray to the accent color so the user
/// can see the effect before committing.
///
/// {@tool snippet}
/// ```dart
/// AppBaseSelector(
///   value: 0.0,
///   onChanged: (v) {
///     // Update base value in state management.
///   },
/// )
/// ```
/// {@end-tool}
class AppBaseSelector extends StatelessWidget {
  /// Creates an [AppBaseSelector].
  const AppBaseSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The current base value between 0.0 and 1.0.
  final double value;

  /// Called when the user adjusts the slider.
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    // Derive a label from the current value.
    final label = switch (value) {
      _ when value < 0.05 => 'Pure Gray',
      _ when value < 0.15 => 'Slightly Warm',
      _ when value < 0.35 => 'Warm',
      _ when value < 0.65 => 'Tinted',
      _                   => 'Saturated',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header row ──────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Base',
              style: theme.typography.sm.copyWith(
                color: theme.colors.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  '$label  (${value.toStringAsFixed(2)})',
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

        // ── Gradient track + slider ──────────────────────────────────────────
        Stack(
          alignment: Alignment.center,
          children: [
            // Gradient background showing cold → warm transition.
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // Cold gray end
                      theme.colors.muted,
                      // Warm/primary end
                      theme.colors.primary,
                    ],
                  ),
                ),
              ),
            ),
            // Transparent slider on top.
            Material(
              color: Colors.transparent,
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: theme.colors.background,
                  overlayColor: theme.colors.primary.withValues(alpha: 0.12),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  trackHeight: 8,
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // ── Endpoint labels ──────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gray',
              style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
            ),
            Text(
              'Warm',
              style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Surface preview ──────────────────────────────────────────────────
        // Shows how backgrounds and cards look at the current base value.
        Row(
          children: [
            Expanded(child: _SurfacePreview(label: 'Background', color: _blendBase(theme.colors.background, theme.colors.primary, value))),
            const SizedBox(width: 8),
            Expanded(child: _SurfacePreview(label: 'Card',       color: _blendBase(theme.colors.card,       theme.colors.primary, value))),
            const SizedBox(width: 8),
            Expanded(child: _SurfacePreview(label: 'Muted',      color: _blendBase(theme.colors.muted,      theme.colors.primary, value))),
          ],
        ),
      ],
    );
  }

  /// Blends [surface] toward [accent] by [amount] (0.0–1.0).
  Color _blendBase(Color surface, Color accent, double amount) {
    if (amount <= 0) return surface;
    final accentHsl = HSLColor.fromColor(accent);
    final surfaceHsl = HSLColor.fromColor(surface);
    // Map base (0–1) to saturation using same formula as AppTheme._applyGrayBase.
    // chroma = amount * 0.22, sat ≈ chroma * 2.5
    final sat = (amount * 0.22 * 2.5).clamp(0.0, 1.0);
    return HSLColor.fromAHSL(
      surfaceHsl.alpha,
      accentHsl.hue,
      sat,
      surfaceHsl.lightness,
    ).toColor();
  }
}

// ── Surface preview swatch ────────────────────────────────────────────────────

class _SurfacePreview extends StatelessWidget {
  const _SurfacePreview({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: theme.colors.border),
          ),
          child: const SizedBox(height: 28, width: double.infinity),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
