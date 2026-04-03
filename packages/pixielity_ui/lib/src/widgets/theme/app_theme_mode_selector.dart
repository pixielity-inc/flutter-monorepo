// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_theme_mode_selector.dart
//
// AppThemeModeSelector — a combined widget that lets the user pick both
// the base color palette and the brightness mode in one place.
//
// This is the "settings screen" component — drop it in any settings page
// and wire up the callbacks to your state management solution.
//
// Usage:
//   AppThemeModeSelector(
//     palette: 'violet',
//     brightness: AppBrightnessMode.system,
//     onPaletteChanged: (p) => ...,
//     onBrightnessChanged: (b) => ...,
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_ui/src/widgets/theme/app_brightness_selector.dart';
import 'package:pixielity_ui/src/widgets/theme/app_palette_selector.dart';

/// A combined theme selector showing palette swatches and brightness toggle.
///
/// Composes [AppPaletteSelector] and [AppBrightnessSelector] into a single
/// card-like widget suitable for a settings screen or onboarding flow.
///
/// {@tool snippet}
/// ```dart
/// AppThemeModeSelector(
///   palette: 'violet',
///   brightness: AppBrightnessMode.system,
///   onPaletteChanged: (palette) {
///     // Update palette in state management.
///   },
///   onBrightnessChanged: (mode) {
///     // Update brightness in state management.
///   },
/// )
/// ```
/// {@end-tool}
class AppThemeModeSelector extends StatelessWidget {
  /// Creates an [AppThemeModeSelector].
  const AppThemeModeSelector({
    required this.palette,
    required this.brightness,
    required this.onPaletteChanged,
    required this.onBrightnessChanged,
    this.showPaletteLabels = false,
    super.key,
  });

  /// The currently selected palette name (e.g. `'violet'`).
  final String palette;

  /// The currently selected brightness mode.
  final AppBrightnessMode brightness;

  /// Called when the user selects a different palette.
  final ValueChanged<String> onPaletteChanged;

  /// Called when the user selects a different brightness mode.
  final ValueChanged<AppBrightnessMode> onBrightnessChanged;

  /// Whether to show palette name labels below each swatch.
  final bool showPaletteLabels;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        // ── Palette section ──────────────────────────────────────────────────
        _SectionLabel(label: 'Color Palette', theme: theme),
        const SizedBox(height: 10),
        AppPaletteSelector(
          value: palette,
          onChanged: onPaletteChanged,
          showLabels: showPaletteLabels,
        ),
        const SizedBox(height: 20),

        // ── Brightness section ───────────────────────────────────────────────
        _SectionLabel(label: 'Appearance', theme: theme),
        const SizedBox(height: 10),
        AppBrightnessSelector(
          value: brightness,
          onChanged: onBrightnessChanged,
        ),
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.theme});

  final String label;
  final FThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: theme.typography.sm.copyWith(
        color: theme.colors.foreground,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
