// lib/src/tokens/app_curves.dart
//
// AppCurves — animation curve tokens for the Pixielity design system.
//
// Centralises all easing curves. Pair with [AppDurations] for consistent
// motion across the app.
//
// Usage:
//   AnimatedContainer(
//     duration: AppDurations.normal,
//     curve: AppCurves.standard,
//   )

import 'package:flutter/material.dart';

/// Animation curve tokens for the Pixielity design system.
///
/// All values are [Curve] constants from Flutter's [Curves] class,
/// aliased here for semantic clarity.
abstract final class AppCurves {
  /// Standard ease-in-out — most UI transitions.
  static const Curve standard = Curves.easeInOut;

  /// Ease-out — elements entering the screen (feel snappy).
  static const Curve enter = Curves.easeOut;

  /// Ease-in — elements leaving the screen (feel intentional).
  static const Curve exit = Curves.easeIn;

  /// Fast-out, slow-in — Material-style emphasis curve.
  static const Curve emphasized = Curves.fastOutSlowIn;

  /// Linear — progress indicators, loaders.
  static const Curve linear = Curves.linear;

  /// Bounce-out — playful confirmations (success states).
  static const Curve bounce = Curves.bounceOut;

  /// Elastic-out — spring-like pop-in effects.
  static const Curve elastic = Curves.elasticOut;

  /// Decelerate — scroll physics, drag release.
  static const Curve decelerate = Curves.decelerate;
}
