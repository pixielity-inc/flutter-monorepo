// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_palette_selector.dart
//
// AppPaletteSelector — a color swatch grid for picking the Forui base palette.
//
// Each palette is represented by a colored circle. The active palette shows
// a checkmark. Tapping a swatch calls [onChanged] with the new palette name.
//
// Usage:
//   AppPaletteSelector(
//     value: 'violet',
//     onChanged: (palette) => ref.read(paletteProvider.notifier).state = palette,
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// The representative color for each Forui base palette.
///
/// Used to render the color swatch in [AppPaletteSelector].
const Map<String, Color> kPaletteColors = {
  'neutral': Color(0xFF737373),
  'zinc':    Color(0xFF71717A),
  'slate':   Color(0xFF64748B),
  'blue':    Color(0xFF3B82F6),
  'green':   Color(0xFF22C55E),
  'orange':  Color(0xFFF97316),
  'red':     Color(0xFFEF4444),
  'rose':    Color(0xFFF43F5E),
  'violet':  Color(0xFF8B5CF6),
  'yellow':  Color(0xFFEAB308),
};

/// A grid of color swatches for selecting the Forui base color palette.
///
/// Renders one circle per palette. The active palette shows a checkmark
/// overlay. All sizing and spacing uses the active theme tokens.
///
/// {@tool snippet}
/// ```dart
/// AppPaletteSelector(
///   value: 'violet',
///   onChanged: (palette) {
///     // Rebuild the app with the new palette.
///   },
/// )
/// ```
/// {@end-tool}
class AppPaletteSelector extends StatelessWidget {
  /// Creates an [AppPaletteSelector].
  const AppPaletteSelector({
    required this.value,
    required this.onChanged,
    this.swatchSize = 36,
    this.showLabels = false,
    super.key,
  });

  /// The currently selected palette name (e.g. `'violet'`).
  final String value;

  /// Called when the user selects a different palette.
  final ValueChanged<String> onChanged;

  /// Diameter of each color swatch in logical pixels. Defaults to 36.
  final double swatchSize;

  /// Whether to show the palette name below each swatch. Defaults to `false`.
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: kPaletteColors.entries.map((entry) {
        return _PaletteSwatch(
          name: entry.key,
          color: entry.value,
          isSelected: value == entry.key,
          size: swatchSize,
          showLabel: showLabels,
          onTap: () => onChanged(entry.key),
        );
      }).toList(),
    );
  }
}

// ── Swatch ────────────────────────────────────────────────────────────────────

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch({
    required this.name,
    required this.color,
    required this.isSelected,
    required this.size,
    required this.showLabel,
    required this.onTap,
  });

  final String name;
  final Color color;
  final bool isSelected;
  final double size;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FTappable(
      onPress: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? theme.colors.foreground
                    : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: size * 0.45,
                  )
                : null,
          ),
          if (showLabel) ...[
            const SizedBox(height: 4),
            Text(
              name,
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
    );
  }
}
