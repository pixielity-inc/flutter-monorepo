// lib/src/tokens/app_durations.dart
//
// AppDurations — animation duration tokens for the Pixielity design system.
//
// Centralises all animation timings so they can be tuned globally.
// Pair with [AppCurves] for consistent motion across the app.
//
// Usage:
//   AnimatedContainer(duration: AppDurations.fast)

/// Animation duration tokens for the Pixielity design system.
///
/// All values are [Duration] constants. Prefer these over raw millisecond
/// literals so timing can be adjusted from a single place.
abstract final class AppDurations {
  /// 50 ms — micro-interactions (ripples, icon swaps).
  static const Duration instant = Duration(milliseconds: 50);

  /// 100 ms — very fast transitions (tooltips appearing).
  static const Duration fastest = Duration(milliseconds: 100);

  /// 150 ms — fast transitions (hover states, badges).
  static const Duration fast = Duration(milliseconds: 150);

  /// 200 ms — standard UI transitions (most widgets).
  static const Duration normal = Duration(milliseconds: 200);

  /// 300 ms — medium transitions (drawers, modals entering).
  static const Duration medium = Duration(milliseconds: 300);

  /// 400 ms — slow transitions (page transitions, accordions).
  static const Duration slow = Duration(milliseconds: 400);

  /// 500 ms — very slow transitions (onboarding, splash).
  static const Duration slower = Duration(milliseconds: 500);

  /// 700 ms — extra-slow (skeleton shimmer cycle half-period).
  static const Duration slowest = Duration(milliseconds: 700);
}
