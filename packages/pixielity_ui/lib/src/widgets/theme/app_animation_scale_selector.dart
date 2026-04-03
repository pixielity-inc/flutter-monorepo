// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_animation_scale_selector.dart
//
// AppAnimationScaleSelector — a segmented control for choosing the global
// animation speed multiplier.
//
// Maps to the theme.animation.scale config value. 0.0 disables all
// animations (accessibility), 0.5 is faster, 1.0 is default, 2.0 is slower.
//
// Usage:
//   AppAnimationScaleSelector(
//     value: 1.0,
//     onChanged: (scale) => ref.read(animScaleProvider.notifier).state = scale,
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A preset animation speed option.
class AppAnimationPreset {
  /// Creates an [AppAnimationPreset].
  const AppAnimationPreset({
    required this.label,
    required this.scale,
    required this.icon,
  });

  /// Human-readable label (e.g. 'None', 'Fast', 'Default', 'Slow').
  final String label;

  /// The scale multiplier value.
  final double scale;

  /// The icon representing this preset.
  final IconData icon;
}

/// The built-in animation speed presets.
const List<AppAnimationPreset> kAnimationPresets = [
  AppAnimationPreset(label: 'None',    scale: 0, icon: Icons.block_rounded),
  AppAnimationPreset(label: 'Fast',    scale: 0.5, icon: Icons.fast_forward_rounded),
  AppAnimationPreset(label: 'Default', scale: 1, icon: Icons.play_arrow_rounded),
  AppAnimationPreset(label: 'Slow',    scale: 2, icon: Icons.slow_motion_video_rounded),
];

/// A segmented control for selecting the global animation speed.
///
/// Renders four preset options: None / Fast / Default / Slow.
/// The active preset is highlighted. Tapping a preset calls [onChanged]
/// with the corresponding scale multiplier.
///
/// {@tool snippet}
/// ```dart
/// AppAnimationScaleSelector(
///   value: 1.0,
///   onChanged: (scale) {
///     // Rebuild the app with the new animation scale.
///   },
/// )
/// ```
/// {@end-tool}
class AppAnimationScaleSelector extends StatelessWidget {
  /// Creates an [AppAnimationScaleSelector].
  const AppAnimationScaleSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The current animation scale multiplier.
  final double value;

  /// Called when the user selects a different animation speed.
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          children: kAnimationPresets.map((preset) {
            final isSelected = value == preset.scale;
            return Expanded(
              child: FTappable(
                onPress: () => onChanged(preset.scale),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colors.background : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        preset.icon,
                        size: 18,
                        color: isSelected
                            ? theme.colors.primary
                            : theme.colors.mutedForeground,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        preset.label,
                        style: theme.typography.xs.copyWith(
                          color: isSelected
                              ? theme.colors.foreground
                              : theme.colors.mutedForeground,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
