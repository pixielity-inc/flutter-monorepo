// lib/src/tokens/app_spacing.dart
//
// AppSpacing — spacing scale for the Pixielity design system.
//
// Based on a 4-point grid (multiples of 4 logical pixels), matching
// Tailwind CSS spacing conventions. Use these constants everywhere you
// need padding, margin, or gap values so the layout stays consistent.
//
// Usage:
//   SizedBox(height: AppSpacing.md)
//   Padding(padding: EdgeInsets.all(AppSpacing.lg))

/// Spacing scale for the Pixielity design system.
///
/// All values are in logical pixels and follow a 4-point grid.
/// Prefer named constants over raw numbers in widget code.
abstract final class AppSpacing {
  /// 0 px — no spacing.
  static const double none = 0;

  /// 2 px — hairline gap.
  static const double xs2 = 2;

  /// 4 px — extra-small gap.
  static const double xs = 4;

  /// 8 px — small gap.
  static const double sm = 8;

  /// 12 px — medium-small gap.
  static const double md2 = 12;

  /// 16 px — medium gap (base unit).
  static const double md = 16;

  /// 20 px — medium-large gap.
  static const double lg2 = 20;

  /// 24 px — large gap.
  static const double lg = 24;

  /// 32 px — extra-large gap.
  static const double xl = 32;

  /// 40 px — 2x-large gap.
  static const double xl2 = 40;

  /// 48 px — 3x-large gap.
  static const double xl3 = 48;

  /// 64 px — 4x-large gap.
  static const double xl4 = 64;

  /// 80 px — 5x-large gap.
  static const double xl5 = 80;

  /// 96 px — 6x-large gap.
  static const double xl6 = 96;

  /// 128 px — 7x-large gap.
  static const double xl7 = 128;
}
