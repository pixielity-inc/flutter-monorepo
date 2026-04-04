// lib/src/widgets/app_skeleton.dart
//
// AppSkeleton — an animated shimmer placeholder for loading states.
//
// Renders a rounded rectangle that pulses between the muted background color
// and a slightly lighter shade, giving the classic "skeleton screen" effect.
// All colors are sourced from FThemeData so it adapts to light/dark mode.
//
// Usage:
//   // Single line placeholder
//   AppSkeleton(width: 200, height: 16)
//
//   // Avatar placeholder
//   AppSkeleton(width: 40, height: 40, borderRadius: AppRadius.asFull)
//
//   // Paragraph placeholder
//   Column(children: [
//     AppSkeleton(width: double.infinity, height: 16),
//     SizedBox(height: 8),
//     AppSkeleton(width: 160, height: 16),
//   ])

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:ui/src/tokens/app_durations.dart';
import 'package:ui/src/tokens/app_radius.dart';

/// An animated shimmer placeholder used during loading states.
///
/// The shimmer animation pulses between FColors.muted and a slightly
/// lighter/darker variant, adapting automatically to the active theme.
///
/// {@tool snippet}
/// ```dart
/// // Text line placeholder
/// AppSkeleton(width: double.infinity, height: 16)
///
/// // Circular avatar placeholder
/// AppSkeleton(width: 48, height: 48, borderRadius: AppRadius.asFull)
/// ```
/// {@end-tool}
class AppSkeleton extends StatefulWidget {
  /// Creates an [AppSkeleton].
  const AppSkeleton({
    required this.width,
    required this.height,
    this.borderRadius,
    super.key,
  });

  /// Width of the skeleton placeholder. Use [double.infinity] to fill.
  final double width;

  /// Height of the skeleton placeholder.
  final double height;

  /// Border radius. Defaults to [AppRadius.asSm] (4 px).
  final BorderRadius? borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slowest,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final effectiveBorderRadius = widget.borderRadius ?? AppRadius.asSm;

    // Derive the shimmer highlight by blending muted toward background.
    final baseColor = colors.muted;
    final highlightColor = Color.lerp(baseColor, colors.background, 0.5)!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: effectiveBorderRadius,
              color: Color.lerp(
                baseColor,
                highlightColor,
                _animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}
