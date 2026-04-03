// ignore_for_file: lines_longer_than_80_chars
//
// theme_explorer_page.dart
//
// Live theme explorer — uses the pixielity_ui theme control widgets
// (AppThemeModeSelector, AppFontScaleSelector, AppAnimationScaleSelector)
// to let the user preview every visual token at runtime.

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_config/pixielity_config.dart';
import 'package:pixielity_example_app/pages/shared/explorer_scaffold.dart';
import 'package:pixielity_ui/pixielity_ui.dart';

/// Theme Explorer — live theme switcher and token inspector.
///
/// Demonstrates the [AppThemeModeSelector], [AppFontScaleSelector], and
/// [AppAnimationScaleSelector] widgets from pixielity_ui. Also shows the
/// full typography scale, color palette, status colors, border radius
/// tokens, and spacing tokens from the active theme.
class ThemeExplorerPage extends StatefulWidget {
  /// Creates the [ThemeExplorerPage].
  const ThemeExplorerPage({super.key});

  @override
  State<ThemeExplorerPage> createState() => _ThemeExplorerPageState();
}

class _ThemeExplorerPageState extends State<ThemeExplorerPage> {
  // ── State ──────────────────────────────────────────────────────────────────

  /// The currently selected base palette name.
  late String _palette;

  /// The currently selected brightness mode.
  late AppBrightnessMode _brightness;

  /// The current font size scalar.
  late double _fontScale;

  /// The current animation speed multiplier.
  late double _animScale;

  @override
  void initState() {
    super.initState();
    // Seed from Config so the explorer starts with the configured values.
    _palette    = Config.get<String>('theme.base',            fallback: 'violet');
    _fontScale  = Config.get<double>('theme.typography.sizeScalar', fallback: 1);
    _animScale  = Config.get<double>('theme.animation.scale', fallback: 1);

    final brightnessStr = Config.get<String>('theme.brightness', fallback: 'system');
    _brightness = switch (brightnessStr) {
      'light' => AppBrightnessMode.light,
      'dark'  => AppBrightnessMode.dark,
      _       => AppBrightnessMode.system,
    };
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final ext   = context.appTheme;

    return ExplorerScaffold(
      title: 'Theme',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Config values ─────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.settings2,
            title: 'Config Values',
            children: [
              InfoRow(label: 'theme.base',            value: Config.get<String>('theme.base',            fallback: 'violet')),
              InfoRow(label: 'theme.brightness',      value: Config.get<String>('theme.brightness',      fallback: 'system')),
              InfoRow(label: 'theme.platformVariant', value: Config.get<String>('theme.platformVariant', fallback: 'auto')),
              InfoRow(label: 'typography.fontFamily', value: Config.get<String>('theme.typography.fontFamily', fallback: 'packages/forui/Inter')),
              InfoRow(label: 'typography.sizeScalar', value: Config.get<double>('theme.typography.sizeScalar', fallback: 1).toString()),
              InfoRow(label: 'style.borderWidth',     value: Config.get<double>('theme.style.borderWidth', fallback: 1).toString()),
              InfoRow(label: 'animation.scale',       value: Config.get<double>('theme.animation.scale', fallback: 1).toString()),
            ],
          ),
          const SizedBox(height: 16),

          // ── Theme Mode Selector (pixielity_ui widget) ─────────────────────
          SectionCard(
            icon: LucideIcons.palette,
            title: 'Theme Mode Selector',
            children: [
              const SizedBox(height: 4),
              // AppThemeModeSelector from pixielity_ui — palette + brightness.
              AppThemeModeSelector(
                palette: _palette,
                brightness: _brightness,
                onPaletteChanged: (p) => setState(() => _palette = p),
                onBrightnessChanged: (b) => setState(() => _brightness = b),
                showPaletteLabels: true,
              ),
              const SizedBox(height: 8),
              Text(
                'Selected: $_palette · ${_brightness.name} — '
                'changes take effect on next app restart.',
                style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Font Scale Selector (pixielity_ui widget) ─────────────────────
          SectionCard(
            icon: LucideIcons.type,
            title: 'Font Scale Selector',
            children: [
              const SizedBox(height: 4),
              // AppFontScaleSelector from pixielity_ui.
              AppFontScaleSelector(
                value: _fontScale,
                onChanged: (s) => setState(() => _fontScale = s),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Animation Scale Selector (pixielity_ui widget) ────────────────
          SectionCard(
            icon: LucideIcons.zap,
            title: 'Animation Scale Selector',
            children: [
              const SizedBox(height: 4),
              // AppAnimationScaleSelector from pixielity_ui.
              AppAnimationScaleSelector(
                value: _animScale,
                onChanged: (s) => setState(() => _animScale = s),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Typography scale ──────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.caseUpper,
            title: 'Typography Scale',
            children: [
              _TypographyRow(label: 'xs3', style: theme.typography.xs3),
              _TypographyRow(label: 'xs2', style: theme.typography.xs2),
              _TypographyRow(label: 'xs',  style: theme.typography.xs),
              _TypographyRow(label: 'sm',  style: theme.typography.sm),
              _TypographyRow(label: 'md',  style: theme.typography.md),
              _TypographyRow(label: 'lg',  style: theme.typography.lg),
              _TypographyRow(label: 'xl',  style: theme.typography.xl),
              _TypographyRow(label: 'xl2', style: theme.typography.xl2),
              _TypographyRow(label: 'xl3', style: theme.typography.xl3),
            ],
          ),
          const SizedBox(height: 16),

          // ── Color palette ─────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.swatchBook,
            title: 'Color Palette',
            children: [
              _ColorRow(label: 'primary',     color: theme.colors.primary,     fg: theme.colors.primaryForeground),
              _ColorRow(label: 'secondary',   color: theme.colors.secondary,   fg: theme.colors.secondaryForeground),
              _ColorRow(label: 'muted',       color: theme.colors.muted,       fg: theme.colors.mutedForeground),
              _ColorRow(label: 'destructive', color: theme.colors.destructive, fg: theme.colors.destructiveForeground),
              _ColorRow(label: 'background',  color: theme.colors.background,  fg: theme.colors.foreground),
              _ColorRow(label: 'card',        color: theme.colors.card,        fg: theme.colors.foreground),
            ],
          ),
          const SizedBox(height: 16),

          // ── Status colors (AppThemeExtension) ─────────────────────────────
          SectionCard(
            icon: LucideIcons.circleCheck,
            title: 'Status Colors (AppThemeExtension)',
            children: [
              _ColorRow(label: 'success', color: ext.success, fg: ext.successForeground),
              _ColorRow(label: 'warning', color: ext.warning, fg: ext.warningForeground),
              _ColorRow(label: 'info',    color: ext.info,    fg: ext.infoForeground),
            ],
          ),
          const SizedBox(height: 16),

          // ── Border radius tokens ──────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.squareDashedBottom,
            title: 'Border Radius Tokens',
            children: [
              InfoRow(label: 'style.borderRadius.sm', value: '${Config.get<double>('theme.style.borderRadius.sm', fallback: 4)} px'),
              InfoRow(label: 'style.borderRadius.md', value: '${Config.get<double>('theme.style.borderRadius.md', fallback: 8)} px'),
              InfoRow(label: 'style.borderRadius.lg', value: '${Config.get<double>('theme.style.borderRadius.lg', fallback: 12)} px'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _RadiusPreview(label: 'sm', radius: Config.get<double>('theme.style.borderRadius.sm', fallback: 4),  color: theme.colors.primary),
                  const SizedBox(width: 12),
                  _RadiusPreview(label: 'md', radius: Config.get<double>('theme.style.borderRadius.md', fallback: 8),  color: theme.colors.primary),
                  const SizedBox(width: 12),
                  _RadiusPreview(label: 'lg', radius: Config.get<double>('theme.style.borderRadius.lg', fallback: 12), color: theme.colors.primary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Spacing tokens ────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.ruler,
            title: 'Spacing Tokens',
            children: [
              _SpacingRow(label: 'xs  (4px)',  size: ext.spacing.xs),
              _SpacingRow(label: 'sm  (8px)',  size: ext.spacing.sm),
              _SpacingRow(label: 'md  (16px)', size: ext.spacing.md),
              _SpacingRow(label: 'lg  (24px)', size: ext.spacing.lg),
              _SpacingRow(label: 'xl  (32px)', size: ext.spacing.xl),
              _SpacingRow(label: 'xl2 (40px)', size: ext.spacing.xl2),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Typography row ────────────────────────────────────────────────────────────

class _TypographyRow extends StatelessWidget {
  const _TypographyRow({required this.label, required this.style});

  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(label, style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground, fontFamily: 'monospace')),
          ),
          const SizedBox(width: 8),
          Text('The quick brown fox', style: style.copyWith(color: theme.colors.foreground)),
          const Spacer(),
          Text('${style.fontSize?.toStringAsFixed(0) ?? '?'}px', style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground)),
        ],
      ),
    );
  }
}

// ── Color row ─────────────────────────────────────────────────────────────────

class _ColorRow extends StatelessWidget {
  const _ColorRow({required this.label, required this.color, required this.fg});

  final String label;
  final Color color;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: theme.colors.border),
            ),
            child: const SizedBox(width: 32, height: 20),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: theme.typography.xs.copyWith(color: theme.colors.foreground))),
          Text(
            '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
            style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

// ── Radius preview ────────────────────────────────────────────────────────────

class _RadiusPreview extends StatelessWidget {
  const _RadiusPreview({required this.label, required this.radius, required this.color});

  final String label;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: color),
          ),
          child: const SizedBox(width: 48, height: 48),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground)),
      ],
    );
  }
}

// ── Spacing row ───────────────────────────────────────────────────────────────

class _SpacingRow extends StatelessWidget {
  const _SpacingRow({required this.label, required this.size});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground))),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colors.primary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
            child: SizedBox(width: size.clamp(4, 200), height: 12),
          ),
        ],
      ),
    );
  }
}
