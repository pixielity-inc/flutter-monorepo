// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/theme/app_palette_selector.dart
//
// AppPaletteSelector — a color swatch grid for picking the base palette.
//
// Derives swatch colors directly from ThemeRegistry so there is no
// hardcoded color map. Every registered theme (built-in or custom)
// automatically appears with its own primary color as the swatch.
//
// Built-in palettes are shown first, custom themes below with a divider.
//
// Usage:
//   AppPaletteSelector(
//     value: 'violet',
//     onChanged: (name) => ref.read(themePaletteProvider.notifier).update(name),
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/registry/theme_registry.dart';
import 'package:ui/src/ui_scope.dart';

/// The ordered list of built-in Forui palette names.
///
/// Order controls the display sequence in the selector.
const List<String> kBuiltInPaletteNames = [
  'neutral', 'zinc', 'slate', 'blue', 'green',
  'orange', 'red', 'rose', 'violet', 'yellow',
];

/// A grid of color swatches for selecting the base color palette.
///
/// Swatch colors are derived from [ThemeRegistry] — the primary color of
/// each registered theme's dark touch variant is used as the swatch color.
/// This means custom themes automatically show their own brand color.
///
/// Built-in palettes appear first. Custom themes (any name not in
/// [kBuiltInPaletteNames]) appear below with a "Custom" section divider.
///
/// {@tool snippet}
/// ```dart
/// AppPaletteSelector(
///   value: 'violet',
///   onChanged: (name) {
///     ref.read(themePaletteProvider.notifier).update(name);
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

  /// The currently selected palette name (e.g. `'violet'`, `'pixielity'`).
  final String value;

  /// Called when the user selects a different palette.
  final ValueChanged<String> onChanged;

  /// Diameter of each color swatch in logical pixels. Defaults to 36.
  final double swatchSize;

  /// Whether to show the palette name below each swatch. Defaults to `false`.
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme    = FTheme.of(context);
    // Read registry from UiScope — no manual passing needed.
    final reg      = UiScope.of(context).registry;

    // Derive the current brightness to pick the right variant for swatches.
    final isDark = theme.colors.brightness == Brightness.dark;
    final variant = isDark ? 'dark' : 'light';

    // ── Collect built-in palettes ─────────────────────────────────────────
    // Only show built-ins that are actually registered (UiServiceProvider
    // must have run). Derive swatch color from the theme's primary color.
    final builtIns = kBuiltInPaletteNames
        .where((name) => reg.has('$name.$variant.touch'))
        .map((name) {
          final themeData = reg.get('$name.$variant.touch');
          return (name: name, color: themeData.colors.primary, isCustom: false);
        })
        .toList();

    // ── Collect custom palettes ───────────────────────────────────────────
    // Any registered key that doesn't start with a built-in name is custom.
    final customNames = reg.keys
        .where((key) => key.endsWith('.$variant.touch'))
        .map((key) => key.replaceAll('.$variant.touch', ''))
        .where((name) => !kBuiltInPaletteNames.contains(name))
        .toSet()
        .toList()
      ..sort();

    final customs = customNames.map((name) {
      final themeData = reg.get('$name.$variant.touch');
      return (name: name, color: themeData.colors.primary, isCustom: true);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Built-in palettes ─────────────────────────────────────────────
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: builtIns.map((p) => _PaletteSwatch(
            name: p.name,
            color: p.color,
            isSelected: value == p.name,
            size: swatchSize,
            showLabel: showLabels,
            isCustom: false,
            onTap: () => onChanged(p.name),
          )).toList(),
        ),

        // ── Custom palettes ───────────────────────────────────────────────
        if (customs.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Divider(color: theme.colors.border, height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Custom',
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider(color: theme.colors.border, height: 1)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: customs.map((p) => _PaletteSwatch(
              name: p.name,
              color: p.color,
              isSelected: value == p.name,
              size: swatchSize,
              showLabel: true, // always show labels for custom themes
              isCustom: true,
              onTap: () => onChanged(p.name),
            )).toList(),
          ),
        ],
      ],
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
    required this.isCustom,
    required this.onTap,
  });

  final String name;
  final Color color;
  final bool isSelected;
  final double size;
  final bool showLabel;

  /// Custom themes use a rounded square; built-ins use a circle.
  final bool isCustom;
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
              borderRadius: isCustom
                  ? BorderRadius.circular(size * 0.25)
                  : null,
              shape: isCustom ? BoxShape.rectangle : BoxShape.circle,
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
