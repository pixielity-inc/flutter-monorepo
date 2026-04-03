// lib/src/theme/app_theme_extension.dart
//
// AppThemeExtension — Flutter ThemeExtension that adds Pixielity-specific
// design tokens on top of Forui's FThemeData.
//
// Forui's theming system supports arbitrary extensions via
// FThemeData(..., extensions: [myExtension]).
// This class is that extension for the Pixielity design system.
//
// It carries:
//   - Semantic color overrides / additions (success, warning, info)
//   - Spacing scale reference
//   - Border-radius scale reference
//   - Shadow scale reference
//   - Animation duration + curve references
//
// Retrieve it anywhere in the widget tree via:
//   context.appTheme          // AppThemeExtension
//   context.appTheme.success  // Color
//
// See also:
//   - AppTheme  — builds the full FThemeData with this extension attached.
//   - AppThemeX — BuildContext extension for convenient access.

import 'package:flutter/material.dart';
import 'package:pixielity_ui/src/tokens/app_colors.dart';
import 'package:pixielity_ui/src/tokens/app_curves.dart';
import 'package:pixielity_ui/src/tokens/app_durations.dart';
import 'package:pixielity_ui/src/tokens/app_radius.dart';
import 'package:pixielity_ui/src/tokens/app_shadows.dart';
import 'package:pixielity_ui/src/tokens/app_spacing.dart';

/// Flutter [ThemeExtension] that carries Pixielity-specific design tokens.
///
/// Attach this to FThemeData via its `extensions` parameter so every widget
/// in the tree can access the full design system through `context.appTheme`.
///
/// All fields are non-nullable; defaults are provided for every token so the
/// extension is always safe to use even if not explicitly configured.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  // ── Constructor ───────────────────────────────────────────────────────────

  /// Creates an [AppThemeExtension].
  ///
  /// All parameters have sensible defaults so you only need to override what
  /// differs between light and dark themes.
  const AppThemeExtension({
    this.success = AppColors.green500,
    this.successForeground = AppColors.white,
    this.warning = AppColors.amber500,
    this.warningForeground = AppColors.neutral950,
    this.info = AppColors.blue500,
    this.infoForeground = AppColors.white,
    this.hoverOverlay = const Color(0x0A000000),
    this.pressedOverlay = const Color(0x14000000),
    this.spacing = const AppSpacingTokens(),
    this.radius = const AppRadiusTokens(),
    this.shadows = const AppShadowTokens(),
    this.durations = const AppDurationTokens(),
    this.curves = const AppCurveTokens(),
  });

  // ── Static presets ────────────────────────────────────────────────────────

  /// Pre-built light-mode extension with appropriate status colors.
  static const AppThemeExtension light = AppThemeExtension();

  /// Pre-built dark-mode extension with lighter status colors for contrast.
  static const AppThemeExtension dark = AppThemeExtension(
    success: AppColors.green400,
    successForeground: AppColors.neutral950,
    warning: AppColors.amber400,
    info: AppColors.blue400,
    infoForeground: AppColors.neutral950,
    hoverOverlay: Color(0x14FFFFFF), // 8 % white
    pressedOverlay: Color(0x1FFFFFFF), // 12 % white
  );

  // ── Semantic status colors ────────────────────────────────────────────────

  /// Color used for success states (e.g. confirmation banners, check icons).
  final Color success;

  /// Foreground color (text/icons) rendered on top of [success].
  final Color successForeground;

  /// Color used for warning states (e.g. caution banners).
  final Color warning;

  /// Foreground color (text/icons) rendered on top of [warning].
  final Color warningForeground;

  /// Color used for informational states (e.g. info banners).
  final Color info;

  /// Foreground color (text/icons) rendered on top of [info].
  final Color infoForeground;

  // ── Surface / overlay extras ──────────────────────────────────────────────

  /// Subtle overlay used for hover states on top of surfaces.
  final Color hoverOverlay;

  /// Subtle overlay used for pressed / active states.
  final Color pressedOverlay;

  // ── Token accessors ───────────────────────────────────────────────────────

  /// The spacing scale.
  ///
  /// Example: `context.appTheme.spacing.md` → 16.0
  final AppSpacingTokens spacing;

  /// The border-radius scale.
  ///
  /// Example: `context.appTheme.radius.lg` → BorderRadius.circular(12)
  final AppRadiusTokens radius;

  /// The shadow / elevation scale.
  ///
  /// Example: `context.appTheme.shadows.sm` → List<BoxShadow>
  final AppShadowTokens shadows;

  /// Animation duration tokens.
  ///
  /// Example: `context.appTheme.durations.normal`
  /// → Duration(milliseconds: 200)
  final AppDurationTokens durations;

  /// Animation curve tokens.
  ///
  /// Example: `context.appTheme.curves.enter` → Curves.easeOut
  final AppCurveTokens curves;

  // ── ThemeExtension overrides ──────────────────────────────────────────────

  @override
  AppThemeExtension copyWith({
    Color? success,
    Color? successForeground,
    Color? warning,
    Color? warningForeground,
    Color? info,
    Color? infoForeground,
    Color? hoverOverlay,
    Color? pressedOverlay,
    AppSpacingTokens? spacing,
    AppRadiusTokens? radius,
    AppShadowTokens? shadows,
    AppDurationTokens? durations,
    AppCurveTokens? curves,
  }) {
    return AppThemeExtension(
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      info: info ?? this.info,
      infoForeground: infoForeground ?? this.infoForeground,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      shadows: shadows ?? this.shadows,
      durations: durations ?? this.durations,
      curves: curves ?? this.curves,
    );
  }

  /// Linearly interpolates between two [AppThemeExtension] instances.
  ///
  /// Used by Flutter's theme animation system when switching themes.
  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      successForeground: Color.lerp(
        successForeground,
        other.successForeground,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningForeground: Color.lerp(
        warningForeground,
        other.warningForeground,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      infoForeground: Color.lerp(infoForeground, other.infoForeground, t)!,
      hoverOverlay: Color.lerp(hoverOverlay, other.hoverOverlay, t)!,
      pressedOverlay: Color.lerp(pressedOverlay, other.pressedOverlay, t)!,
      // Non-interpolatable tokens: snap at t == 1.
      spacing: t < 0.5 ? spacing : other.spacing,
      radius: t < 0.5 ? radius : other.radius,
      shadows: t < 0.5 ? shadows : other.shadows,
      durations: t < 0.5 ? durations : other.durations,
      curves: t < 0.5 ? curves : other.curves,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppThemeExtension &&
        other.success == success &&
        other.successForeground == successForeground &&
        other.warning == warning &&
        other.warningForeground == warningForeground &&
        other.info == info &&
        other.infoForeground == infoForeground &&
        other.hoverOverlay == hoverOverlay &&
        other.pressedOverlay == pressedOverlay;
  }

  @override
  int get hashCode => Object.hash(
    success,
    successForeground,
    warning,
    warningForeground,
    info,
    infoForeground,
    hoverOverlay,
    pressedOverlay,
  );
}

// ── Public token wrapper classes ──────────────────────────────────────────────
// These thin wrappers expose the static token constants as instance properties,
// making them accessible via `context.appTheme.spacing.md` etc.
// They are public so they can appear in the public API of AppThemeExtension.

/// Exposes [AppSpacing] constants as instance properties.
///
/// Access via `context.appTheme.spacing`.
@immutable
class AppSpacingTokens {
  /// Creates an [AppSpacingTokens].
  const AppSpacingTokens();

  /// 0 px.
  double get none => AppSpacing.none;

  /// 2 px.
  double get xs2 => AppSpacing.xs2;

  /// 4 px.
  double get xs => AppSpacing.xs;

  /// 8 px.
  double get sm => AppSpacing.sm;

  /// 12 px.
  double get md2 => AppSpacing.md2;

  /// 16 px.
  double get md => AppSpacing.md;

  /// 20 px.
  double get lg2 => AppSpacing.lg2;

  /// 24 px.
  double get lg => AppSpacing.lg;

  /// 32 px.
  double get xl => AppSpacing.xl;

  /// 40 px.
  double get xl2 => AppSpacing.xl2;

  /// 48 px.
  double get xl3 => AppSpacing.xl3;

  /// 64 px.
  double get xl4 => AppSpacing.xl4;
}

/// Exposes [AppRadius] pre-built [BorderRadius] objects as instance properties.
///
/// Access via `context.appTheme.radius`.
@immutable
class AppRadiusTokens {
  /// Creates an [AppRadiusTokens].
  const AppRadiusTokens();

  /// Sharp corners.
  BorderRadius get none => AppRadius.asNone;

  /// 2 px.
  BorderRadius get xs => AppRadius.asXs;

  /// 4 px.
  BorderRadius get sm => AppRadius.asSm;

  /// 6 px.
  BorderRadius get md2 => AppRadius.asMd2;

  /// 8 px.
  BorderRadius get md => AppRadius.asMd;

  /// 12 px.
  BorderRadius get lg => AppRadius.asLg;

  /// 16 px.
  BorderRadius get xl => AppRadius.asXl;

  /// 24 px.
  BorderRadius get xl2 => AppRadius.asXl2;

  /// Pill / fully rounded.
  BorderRadius get full => AppRadius.asFull;
}

/// Exposes [AppShadows] constants as instance properties.
///
/// Access via `context.appTheme.shadows`.
@immutable
class AppShadowTokens {
  /// Creates an [AppShadowTokens].
  const AppShadowTokens();

  /// No shadow.
  List<BoxShadow> get none => AppShadows.none;

  /// Extra-small shadow.
  List<BoxShadow> get xs => AppShadows.xs;

  /// Small shadow.
  List<BoxShadow> get sm => AppShadows.sm;

  /// Medium shadow.
  List<BoxShadow> get md => AppShadows.md;

  /// Large shadow.
  List<BoxShadow> get lg => AppShadows.lg;

  /// Extra-large shadow.
  List<BoxShadow> get xl => AppShadows.xl;

  /// Inner / inset shadow.
  List<BoxShadow> get inner => AppShadows.inner;
}

/// Exposes [AppDurations] constants as instance properties.
///
/// Access via `context.appTheme.durations`.
@immutable
class AppDurationTokens {
  /// Creates an [AppDurationTokens].
  const AppDurationTokens();

  /// 50 ms.
  Duration get instant => AppDurations.instant;

  /// 100 ms.
  Duration get fastest => AppDurations.fastest;

  /// 150 ms.
  Duration get fast => AppDurations.fast;

  /// 200 ms.
  Duration get normal => AppDurations.normal;

  /// 300 ms.
  Duration get medium => AppDurations.medium;

  /// 400 ms.
  Duration get slow => AppDurations.slow;

  /// 500 ms.
  Duration get slower => AppDurations.slower;

  /// 700 ms.
  Duration get slowest => AppDurations.slowest;
}

/// Exposes [AppCurves] constants as instance properties.
///
/// Access via `context.appTheme.curves`.
@immutable
class AppCurveTokens {
  /// Creates an [AppCurveTokens].
  const AppCurveTokens();

  /// Ease-in-out — standard transitions.
  Curve get standard => AppCurves.standard;

  /// Ease-out — elements entering.
  Curve get enter => AppCurves.enter;

  /// Ease-in — elements leaving.
  Curve get exit => AppCurves.exit;

  /// Fast-out slow-in — Material emphasis.
  Curve get emphasized => AppCurves.emphasized;

  /// Linear — loaders.
  Curve get linear => AppCurves.linear;

  /// Bounce-out — playful confirmations.
  Curve get bounce => AppCurves.bounce;

  /// Elastic-out — spring pop-in.
  Curve get elastic => AppCurves.elastic;

  /// Decelerate — scroll release.
  Curve get decelerate => AppCurves.decelerate;
}
