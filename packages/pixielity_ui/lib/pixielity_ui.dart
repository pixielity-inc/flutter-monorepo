/// pixielity_ui
///
/// Centralised theming system and component library for the Pixielity Flutter
/// monorepo.
///
/// ## Design Tokens
/// - [AppColors]    — full color palette (raw hex values).
/// - [AppSpacing]   — 4-point spacing scale.
/// - [AppRadius]    — border-radius scale + pre-built BorderRadius objects.
/// - [AppShadows]   — elevation / shadow presets.
/// - [AppDurations] — animation duration constants.
/// - [AppCurves]    — animation curve constants.
///
/// ## Theme
/// - [AppTheme]          — builds FThemeData for light/dark x touch/desktop.
/// - [AppThemeExtension] — ThemeExtension that adds Pixielity tokens to Forui.
/// - [AppThemeX]         — BuildContext extension: `context.appTheme`.
/// - [ConfigBridge]      — adapter for reading theme config from Config.
///
/// ## General Widgets
/// - [AppStatusBadge]      — semantic status pill (success/warning/error/info).
/// - [AppSurface]          — themed container with border, radius, and shadow.
/// - [AppSectionHeader]    — section title + optional subtitle + trailing.
/// - [AppEmptyState]       — full-area empty-state with icon, title, and CTA.
/// - [AppLoadingIndicator] — themed circular spinner.
/// - [AppDividerLabel]     — horizontal rule with centred text label.
/// - [AppSkeleton]         — animated shimmer placeholder for loading states.
/// - [AppThemeBuilder]     — builder widget exposing theme + extension.
///
/// ## Theme Control Widgets
/// - [AppBrightnessSelector]    — system/light/dark segmented toggle.
/// - [AppPaletteSelector]       — color swatch grid for picking base palette.
/// - [AppFontScaleSelector]     — slider for global font size scalar.
/// - [AppAnimationScaleSelector]— segmented control for animation speed.
/// - [AppThemeModeSelector]     — combined palette + brightness selector.
/// - [AppThemeSettingsPanel]    — full settings panel with all four controls.
///
/// ## Usage
///
/// ```dart
/// import 'package:pixielity_ui/pixielity_ui.dart';
/// ```
// ignore_for_file: comment_references

library;

// ── Theme ─────────────────────────────────────────────────────────────────────
export 'src/theme/app_theme.dart';
export 'src/theme/app_theme_context.dart';
export 'src/theme/app_theme_extension.dart';
// ── Design tokens ─────────────────────────────────────────────────────────────
export 'src/tokens/app_colors.dart';
export 'src/tokens/app_curves.dart';
export 'src/tokens/app_durations.dart';
export 'src/tokens/app_radius.dart';
export 'src/tokens/app_shadows.dart';
export 'src/tokens/app_spacing.dart';
// ── General widgets ───────────────────────────────────────────────────────────
export 'src/widgets/app_divider_label.dart';
export 'src/widgets/app_empty_state.dart';
export 'src/widgets/app_loading_indicator.dart';
export 'src/widgets/app_section_header.dart';
export 'src/widgets/app_skeleton.dart';
export 'src/widgets/app_status_badge.dart';
export 'src/widgets/app_surface.dart';
export 'src/widgets/app_theme_builder.dart';
// ── Theme control widgets ─────────────────────────────────────────────────────
export 'src/widgets/theme/app_animation_scale_selector.dart';
export 'src/widgets/theme/app_brightness_selector.dart';
export 'src/widgets/theme/app_font_scale_selector.dart';
export 'src/widgets/theme/app_palette_selector.dart';
export 'src/widgets/theme/app_theme_mode_selector.dart';
export 'src/widgets/theme/app_theme_settings_panel.dart';
