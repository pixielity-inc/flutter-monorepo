// lib/src/widgets/app_surface.dart
//
// AppSurface — a themed container (surface) that applies the correct
// background color, border, border-radius, and shadow from the active theme.
//
// This is the building block for cards, panels, and any elevated container
// in the app. It reads all visual properties from FThemeData so it
// automatically adapts to light/dark mode.
//
// Usage:
//   AppSurface(
//     elevation: AppSurfaceElevation.raised,
//     child: Text('Hello'),
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/tokens/app_shadows.dart';
import 'package:ui/src/tokens/app_spacing.dart';

/// Controls the shadow / elevation level of an [AppSurface].
enum AppSurfaceElevation {
  /// Flat — no shadow, blends with the background.
  flat,

  /// Slightly raised — subtle shadow (e.g. input fields, chips).
  subtle,

  /// Raised — standard card shadow.
  raised,

  /// Floating — popover / dropdown shadow.
  floating,

  /// Overlay — dialog / sheet shadow.
  overlay,
}

/// A themed container that applies background, border, radius, and shadow
/// from the active FThemeData.
///
/// Use this as the base for any elevated surface in the app (cards, panels,
/// popovers, etc.) to ensure consistent visual treatment across themes.
///
/// {@tool snippet}
/// ```dart
/// AppSurface(
///   elevation: AppSurfaceElevation.raised,
///   padding: EdgeInsets.all(AppSpacing.lg),
///   child: Text('Card content'),
/// )
/// ```
/// {@end-tool}
class AppSurface extends StatelessWidget {
  /// Creates an [AppSurface].
  const AppSurface({
    required this.child,
    this.elevation = AppSurfaceElevation.raised,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
    this.color,
    super.key,
  });

  /// The child widget rendered inside the surface.
  final Widget child;

  /// Controls the shadow depth. Defaults to [AppSurfaceElevation.raised].
  final AppSurfaceElevation elevation;

  /// Inner padding applied around [child]. Defaults to [AppSpacing.md].
  final EdgeInsetsGeometry? padding;

  /// Override the border-radius. Defaults to the theme's `md` radius.
  final BorderRadius? borderRadius;

  /// Whether to draw a border using FColors.border. Defaults to `true`.
  final bool showBorder;

  /// Override the background color. Defaults to FColors.card.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final style = context.theme.style;

    final effectiveBorderRadius = borderRadius ?? style.borderRadius.md;
    final effectivePadding =
        padding ?? const EdgeInsets.all(AppSpacing.md);
    final effectiveColor = color ?? colors.card;
    final effectiveShadow = _shadowFor(elevation);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        border: showBorder
            ? Border.all(color: colors.border, width: style.borderWidth)
            : null,
        boxShadow: effectiveShadow,
      ),
      child: Padding(padding: effectivePadding, child: child),
    );
  }

  /// Maps [AppSurfaceElevation] to the corresponding [AppShadows] list.
  List<BoxShadow> _shadowFor(AppSurfaceElevation elevation) {
    return switch (elevation) {
      AppSurfaceElevation.flat => AppShadows.none,
      AppSurfaceElevation.subtle => AppShadows.xs,
      AppSurfaceElevation.raised => AppShadows.sm,
      AppSurfaceElevation.floating => AppShadows.md,
      AppSurfaceElevation.overlay => AppShadows.lg,
    };
  }
}
