// lib/src/tokens/app_shadows.dart
//
// AppShadows — elevation / shadow tokens for the Pixielity design system.
//
// Provides a set of pre-built [List<BoxShadow>] constants that map to
// common elevation levels. Use these instead of raw BoxShadow values so
// shadow styles stay consistent across the app.
//
// Usage:
//   BoxDecoration(boxShadow: AppShadows.sm)

import 'package:flutter/material.dart';

/// Elevation / shadow tokens for the Pixielity design system.
///
/// Each constant is a [List<BoxShadow>] ready to be passed to
/// [BoxDecoration.boxShadow] or [PhysicalModel.elevation].
abstract final class AppShadows {
  /// No shadow — flat surface.
  static const List<BoxShadow> none = [];

  /// Extra-small shadow — subtle lift (e.g. input fields).
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0D000000), // 5 % black
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// Small shadow — cards, dropdowns.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x1A000000), // 10 % black
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5 % black
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];

  /// Medium shadow — popovers, tooltips.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  /// Large shadow — dialogs, sheets.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -4,
    ),
  ];

  /// Extra-large shadow — full-screen overlays.
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
    ),
  ];

  /// Inner shadow — pressed / inset states.
  static const List<BoxShadow> inner = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];
}
