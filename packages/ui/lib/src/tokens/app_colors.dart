// lib/src/tokens/app_colors.dart
//
// AppColors — raw color palette for the Pixielity design system.
//
// This file defines every raw color constant used across the app.
// These are NOT semantic colors (use AppColorScheme for that).
// Think of this as the "paint bucket" — all available colors in one place.
//
// Usage:
//   AppColors.neutral900  // raw hex value
//
// Do NOT use these directly in widgets. Instead, consume the semantic
// [AppColorScheme] exposed via [context.appTheme.colors].

import 'package:flutter/material.dart';

/// Raw color palette for the Pixielity design system.
///
/// All colors are defined as static constants. They are grouped by hue/family.
/// Widgets should reference semantic tokens from [AppColorScheme], not these
/// raw values directly.
abstract final class AppColors {
  // ── Neutral ──────────────────────────────────────────────────────────────

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);

  /// Near-white, used as light-mode background.
  static const Color neutral50 = Color(0xFFFAFAFA);

  /// Very light grey.
  static const Color neutral100 = Color(0xFFF5F5F5);

  /// Light grey, used for muted backgrounds.
  static const Color neutral200 = Color(0xFFE5E5E5);

  /// Soft grey border.
  static const Color neutral300 = Color(0xFFD4D4D4);

  /// Medium-light grey.
  static const Color neutral400 = Color(0xFFA3A3A3);

  /// Medium grey, used for muted foreground text.
  static const Color neutral500 = Color(0xFF737373);

  /// Medium-dark grey.
  static const Color neutral600 = Color(0xFF525252);

  /// Dark grey.
  static const Color neutral700 = Color(0xFF404040);

  /// Very dark grey, used for dark-mode card backgrounds.
  static const Color neutral800 = Color(0xFF262626);

  /// Near-black, used for dark-mode backgrounds.
  static const Color neutral900 = Color(0xFF171717);

  /// Almost black.
  static const Color neutral950 = Color(0xFF0A0A0A);

  /// Pure black.
  static const Color black = Color(0xFF000000);

  // ── Primary (Violet) ─────────────────────────────────────────────────────

  /// Lightest violet tint.
  static const Color violet50 = Color(0xFFF5F3FF);

  /// Light violet.
  static const Color violet100 = Color(0xFFEDE9FE);

  /// Soft violet.
  static const Color violet200 = Color(0xFFDDD6FE);

  /// Medium-light violet.
  static const Color violet300 = Color(0xFFC4B5FD);

  /// Medium violet.
  static const Color violet400 = Color(0xFFA78BFA);

  /// Brand violet — primary action color.
  static const Color violet500 = Color(0xFF8B5CF6);

  /// Deeper violet.
  static const Color violet600 = Color(0xFF7C3AED);

  /// Dark violet.
  static const Color violet700 = Color(0xFF6D28D9);

  /// Very dark violet.
  static const Color violet800 = Color(0xFF5B21B6);

  /// Darkest violet.
  static const Color violet900 = Color(0xFF4C1D95);

  // ── Destructive (Red) ────────────────────────────────────────────────────

  /// Destructive / error red.
  static const Color red500 = Color(0xFFE7000B);

  /// Lighter destructive red for dark-mode backgrounds.
  static const Color red400 = Color(0xFFF87171);

  // ── Success (Green) ──────────────────────────────────────────────────────

  /// Success green.
  static const Color green500 = Color(0xFF22C55E);

  /// Lighter success green for dark-mode.
  static const Color green400 = Color(0xFF4ADE80);

  // ── Warning (Amber) ──────────────────────────────────────────────────────

  /// Warning amber.
  static const Color amber500 = Color(0xFFF59E0B);

  /// Lighter warning amber for dark-mode.
  static const Color amber400 = Color(0xFFFBBF24);

  // ── Info (Blue) ──────────────────────────────────────────────────────────

  /// Info blue.
  static const Color blue500 = Color(0xFF3B82F6);

  /// Lighter info blue for dark-mode.
  static const Color blue400 = Color(0xFF60A5FA);

  // ── Overlay / Barrier ────────────────────────────────────────────────────

  /// Semi-transparent black barrier used for modals.
  static const Color barrier = Color(0x33000000);

  /// Transparent.
  static const Color transparent = Color(0x00000000);
}
