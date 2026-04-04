// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_theme_settings_panel.dart
//
// AppThemeSettingsPanel — a full theme settings panel combining palette,
// brightness, font scale, and animation scale selectors.
//
// Drop this into any settings screen or bottom sheet. Wire the callbacks
// to your state management solution (Riverpod, Provider, etc.).
//
// Usage:
//   AppThemeSettingsPanel(
//     palette: 'violet',
//     brightness: AppBrightnessMode.system,
//     fontScale: 1.0,
//     animationScale: 1.0,
//     onPaletteChanged: (p) => ...,
//     onBrightnessChanged: (b) => ...,
//     onFontScaleChanged: (s) => ...,
//     onAnimationScaleChanged: (s) => ...,
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/widgets/theme/app_animation_scale_selector.dart';
import 'package:ui/src/widgets/theme/app_base_selector.dart';
import 'package:ui/src/widgets/theme/app_brightness_selector.dart';
import 'package:ui/src/widgets/theme/app_font_scale_selector.dart';
import 'package:ui/src/widgets/theme/app_palette_selector.dart';

/// A full theme settings panel with palette, brightness, font, and animation.
///
/// Composes all four theme control widgets into a scrollable column.
/// Each section is separated by a divider and labeled.
///
/// Typically used inside a settings screen, a bottom sheet, or a drawer.
///
/// {@tool snippet}
/// ```dart
/// AppThemeSettingsPanel(
///   palette: 'violet',
///   brightness: AppBrightnessMode.system,
///   fontScale: 1.0,
///   animationScale: 1.0,
///   onPaletteChanged: (p) => setState(() => _palette = p),
///   onBrightnessChanged: (b) => setState(() => _brightness = b),
///   onFontScaleChanged: (s) => setState(() => _fontScale = s),
///   onAnimationScaleChanged: (s) => setState(() => _animScale = s),
/// )
/// ```
/// {@end-tool}
class AppThemeSettingsPanel extends StatelessWidget {
  /// Creates an [AppThemeSettingsPanel].
  const AppThemeSettingsPanel({
    required this.palette,
    required this.brightness,
    required this.fontScale,
    required this.animationScale,
    required this.onPaletteChanged,
    required this.onBrightnessChanged,
    required this.onFontScaleChanged,
    required this.onAnimationScaleChanged,
    this.baseValue = 0.0,
    this.onBaseValueChanged,
    this.showPaletteLabels = false,
    super.key,
  });

  // ── Current values ────────────────────────────────────────────────────────

  /// The currently selected palette name (e.g. `'violet'`).
  final String palette;

  /// The currently selected brightness mode.
  final AppBrightnessMode brightness;

  /// The current font size scalar. 1.0 = default.
  final double fontScale;

  /// The current animation speed multiplier. 1.0 = default.
  final double animationScale;

  // ── Callbacks ─────────────────────────────────────────────────────────────

  /// Called when the user selects a different palette.
  final ValueChanged<String> onPaletteChanged;

  /// Called when the user selects a different brightness mode.
  final ValueChanged<AppBrightnessMode> onBrightnessChanged;

  /// Called when the user adjusts the font scale slider.
  final ValueChanged<double> onFontScaleChanged;

  /// Called when the user selects a different animation speed.
  final ValueChanged<double> onAnimationScaleChanged;

  /// The current base (gray saturation) value. 0.0 = pure gray, 1.0 = warm.
  final double baseValue;

  /// Called when the user adjusts the base slider. Optional.
  final ValueChanged<double>? onBaseValueChanged;

  // ── Options ───────────────────────────────────────────────────────────────

  /// Whether to show palette name labels below each swatch.
  final bool showPaletteLabels;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        // ── Color Palette ────────────────────────────────────────────────────
        _PanelSection(
          label: 'Color Palette',
          description: 'Choose the base color scheme for the app.',
          child: AppPaletteSelector(
            value: palette,
            onChanged: onPaletteChanged,
            showLabels: showPaletteLabels,
          ),
        ),
        _Divider(theme: theme),

        // ── Appearance ───────────────────────────────────────────────────────
        _PanelSection(
          label: 'Appearance',
          description: 'Choose between light, dark, or system-controlled mode.',
          child: AppBrightnessSelector(
            value: brightness,
            onChanged: onBrightnessChanged,
          ),
        ),
        _Divider(theme: theme),

        // ── Font Size ────────────────────────────────────────────────────────
        _PanelSection(
          label: 'Text Size',
          description: 'Adjust the global font size for better readability.',
          child: AppFontScaleSelector(
            value: fontScale,
            onChanged: onFontScaleChanged,
          ),
        ),
        _Divider(theme: theme),

        // ── Base (Gray Saturation) ────────────────────────────────────────────
        if (onBaseValueChanged != null)
          _PanelSection(
            label: 'Base',
            description: 'Controls how much gray is mixed into neutral '
                'surfaces like backgrounds and cards. '
                '0 = pure gray, 1 = warm/tinted.',
            child: AppBaseSelector(
              value: baseValue,
              onChanged: onBaseValueChanged!,
            ),
          ),
        if (onBaseValueChanged != null) _Divider(theme: theme),

        // ── Animation Speed ──────────────────────────────────────────────────
        _PanelSection(
          label: 'Animation Speed',
          description: 'Control how fast UI animations play. '
              'Set to None to disable all animations.',
          child: AppAnimationScaleSelector(
            value: animationScale,
            onChanged: onAnimationScaleChanged,
          ),
        ),
      ],
    );
  }
}

// ── Panel section ─────────────────────────────────────────────────────────────

/// A labeled section within [AppThemeSettingsPanel].
class _PanelSection extends StatelessWidget {
  const _PanelSection({
    required this.label,
    required this.description,
    required this.child,
  });

  final String label;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: theme.typography.sm.copyWith(
              color: theme.colors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: theme.typography.xs.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ── Divider ───────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider({required this.theme});

  final FThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Divider(color: theme.colors.border, height: 1);
  }
}
