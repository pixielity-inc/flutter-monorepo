// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_brightness_selector.dart
//
// AppBrightnessSelector — a segmented control for choosing between
// system / light / dark brightness modes.
//
// The widget is self-contained and stateless — it calls [onChanged]
// when the user picks a new mode and the parent is responsible for
// rebuilding the theme (e.g. via a Riverpod StateProvider).
//
// Usage:
//   AppBrightnessSelector(
//     value: AppBrightnessMode.dark,
//     onChanged: (mode) => ref.read(brightnessModeProvider.notifier).state = mode,
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// The three brightness modes the app can operate in.
enum AppBrightnessMode {
  /// Follow the operating system's light/dark setting automatically.
  system,

  /// Always use the light theme regardless of the OS setting.
  light,

  /// Always use the dark theme regardless of the OS setting.
  dark,
}

/// A segmented three-way toggle for selecting the app brightness mode.
///
/// Renders three tappable segments — System / Light / Dark — with the
/// active segment highlighted using the primary color. All colors are
/// sourced from the active [FThemeData] so it adapts to the current theme.
///
/// {@tool snippet}
/// ```dart
/// AppBrightnessSelector(
///   value: AppBrightnessMode.system,
///   onChanged: (mode) {
///     // Rebuild the app with the new brightness.
///   },
/// )
/// ```
/// {@end-tool}
class AppBrightnessSelector extends StatelessWidget {
  /// Creates an [AppBrightnessSelector].
  const AppBrightnessSelector({
    required this.value,
    required this.onChanged,
    this.showLabels = true,
    super.key,
  });

  /// The currently selected brightness mode.
  final AppBrightnessMode value;

  /// Called when the user selects a different brightness mode.
  final ValueChanged<AppBrightnessMode> onChanged;

  /// Whether to show text labels below the icons. Defaults to `true`.
  final bool showLabels;

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
          children: AppBrightnessMode.values.map((mode) {
            return Expanded(
              child: _BrightnessSegment(
                mode: mode,
                isSelected: value == mode,
                showLabel: showLabels,
                onTap: () => onChanged(mode),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Segment ───────────────────────────────────────────────────────────────────

class _BrightnessSegment extends StatelessWidget {
  const _BrightnessSegment({
    required this.mode,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  final AppBrightnessMode mode;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    final (icon, label) = switch (mode) {
      AppBrightnessMode.system => (Icons.brightness_auto_rounded, 'System'),
      AppBrightnessMode.light  => (Icons.light_mode_rounded,      'Light'),
      AppBrightnessMode.dark   => (Icons.dark_mode_rounded,       'Dark'),
    };

    return FTappable(
      onPress: onTap,
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
              icon,
              size: 18,
              color: isSelected
                  ? theme.colors.primary
                  : theme.colors.mutedForeground,
            ),
            if (showLabel) ...[
              const SizedBox(height: 3),
              Text(
                label,
                style: theme.typography.xs.copyWith(
                  color: isSelected
                      ? theme.colors.foreground
                      : theme.colors.mutedForeground,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
