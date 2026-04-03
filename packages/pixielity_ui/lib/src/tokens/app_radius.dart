// lib/src/tokens/app_radius.dart
//
// AppRadius — border-radius scale for the Pixielity design system.
//
// Provides both raw [double] constants and pre-built [BorderRadius] objects
// so widgets can use either form without repeating boilerplate.
//
// Usage:
//   BorderRadius.circular(AppRadius.md)
//   // or use the pre-built shorthand:
//   AppRadius.asMd   // → BorderRadius.circular(8)

import 'package:flutter/material.dart';

/// Border-radius scale for the Pixielity design system.
///
/// Raw [double] values are prefixed with nothing; pre-built [BorderRadius]
/// objects are prefixed with `as` (e.g. [asSm], [asMd]).
abstract final class AppRadius {
  /// 0 px — sharp corners.
  static const double none = 0;

  /// 2 px — subtle rounding.
  static const double xs = 2;

  /// 4 px — small rounding.
  static const double sm = 4;

  /// 6 px — medium-small rounding.
  static const double md2 = 6;

  /// 8 px — medium rounding (default for cards, inputs).
  static const double md = 8;

  /// 12 px — large rounding.
  static const double lg = 12;

  /// 16 px — extra-large rounding.
  static const double xl = 16;

  /// 24 px — 2x-large rounding.
  static const double xl2 = 24;

  /// 9999 px — fully rounded / pill shape.
  static const double full = 9999;

  // ── Pre-built BorderRadius objects ───────────────────────────────────────

  /// [BorderRadius.circular] with [none].
  static const BorderRadius asNone = BorderRadius.zero;

  /// [BorderRadius.circular] with [xs].
  static BorderRadius get asXs => BorderRadius.circular(xs);

  /// [BorderRadius.circular] with [sm].
  static BorderRadius get asSm => BorderRadius.circular(sm);

  /// [BorderRadius.circular] with [md2].
  static BorderRadius get asMd2 => BorderRadius.circular(md2);

  /// [BorderRadius.circular] with [md].
  static BorderRadius get asMd => BorderRadius.circular(md);

  /// [BorderRadius.circular] with [lg].
  static BorderRadius get asLg => BorderRadius.circular(lg);

  /// [BorderRadius.circular] with [xl].
  static BorderRadius get asXl => BorderRadius.circular(xl);

  /// [BorderRadius.circular] with [xl2].
  static BorderRadius get asXl2 => BorderRadius.circular(xl2);

  /// [BorderRadius.circular] with [full] — pill / fully rounded.
  static BorderRadius get asFull => BorderRadius.circular(full);
}
