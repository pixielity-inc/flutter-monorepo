// lib/src/widgets/app_loading_indicator.dart
//
// AppLoadingIndicator — a themed loading spinner that uses the primary color
// from the active FThemeData.
//
// Wraps Flutter's CircularProgressIndicator with theme-aware colors and
// a consistent default size so all loading states look the same.
//
// Usage:
//   // Inline spinner
//   AppLoadingIndicator()
//
//   // Full-screen overlay
//   AppLoadingIndicator.fullScreen()

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/tokens/app_spacing.dart';

/// A themed circular loading indicator.
///
/// Reads FColors.primary from the active theme so the spinner color
/// always matches the brand color, in both light and dark mode.
///
/// {@tool snippet}
/// ```dart
/// // Inline
/// const AppLoadingIndicator()
///
/// // Full-screen centred overlay
/// AppLoadingIndicator.fullScreen()
/// ```
/// {@end-tool}
class AppLoadingIndicator extends StatelessWidget {
  /// Creates an inline [AppLoadingIndicator].
  const AppLoadingIndicator({
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
    super.key,
  });

  /// Diameter of the spinner in logical pixels. Defaults to 24.
  final double size;

  /// Stroke width of the spinner arc. Defaults to 2.5.
  final double strokeWidth;

  /// Override the spinner color. Defaults to FColors.primary.
  final Color? color;

  /// Creates a full-screen centred loading overlay.
  ///
  /// Useful as a page-level loading state while data is being fetched.
  static Widget fullScreen({double size = 32, double strokeWidth = 3}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AppLoadingIndicator(size: size, strokeWidth: strokeWidth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.theme.colors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      ),
    );
  }
}
