// ignore_for_file: lines_longer_than_80_chars

/// Theme and visual design configuration.
///
/// This is the single source of truth for every visual decision in the app.
/// It covers Forui's FColors, FTypography, FStyle, and our AppThemeExtension.
///
/// AppTheme.fromConfig() reads this map to build the final FThemeData.
/// Access values via Config.get('theme.<key>').
Map<String, dynamic> themeConfig() {
  return {

    /*
    |--------------------------------------------------------------------------
    | Base Color Palette
    |--------------------------------------------------------------------------
    |
    | The Forui color palette used as the foundation for both light and dark
    | themes. This maps directly to the FThemes presets in the Forui library.
    |
    | Supported: "neutral", "zinc", "slate", "blue", "green", "orange",
    |            "red", "rose", "violet", "yellow"
    |
    | dart-define: THEME_BASE
    |
    */

    'base': const String.fromEnvironment('THEME_BASE', defaultValue: 'violet'),

    /*
    |--------------------------------------------------------------------------
    | Brightness Strategy
    |--------------------------------------------------------------------------
    |
    | Controls how the app resolves light vs dark mode. "system" follows the
    | operating system setting automatically. "light" and "dark" force a
    | specific mode regardless of the system preference.
    |
    | Supported: "system", "light", "dark"
    |
    | dart-define: THEME_BRIGHTNESS
    |
    */

    'brightness': const String.fromEnvironment('THEME_BRIGHTNESS', defaultValue: 'system'),

    /*
    |--------------------------------------------------------------------------
    | Platform Variant
    |--------------------------------------------------------------------------
    |
    | Forces a specific Forui platform variant. Touch variants use larger
    | hit targets and font sizes optimised for mobile. Desktop variants are
    | more compact. "auto" detects from the current platform automatically.
    |
    | Supported: "auto", "touch", "desktop"
    |
    | dart-define: THEME_PLATFORM_VARIANT
    |
    */

    'platformVariant': const String.fromEnvironment('THEME_PLATFORM_VARIANT', defaultValue: 'auto'),

    // =========================================================================
    // TYPOGRAPHY
    // =========================================================================
    //
    // Controls the font family and size scale applied to all text styles.
    // Forui's FTypography uses Tailwind CSS-inspired size names (xs → xl8).
    // All sizes are in logical pixels. Heights are line-height multipliers.
    //
    // See: https://forui.dev/docs/concepts/themes#typography
    //
    // =========================================================================

    'typography': {

      /*
      |------------------------------------------------------------------------
      | Font Family
      |------------------------------------------------------------------------
      |
      | The default font family applied to all text styles.
      | Leave empty to use the Forui default (packages/forui/Inter).
      | For Google Fonts: 'packages/google_fonts/Geist'
      |
      | dart-define: THEME_FONT_FAMILY
      |
      */

      'fontFamily': const String.fromEnvironment('THEME_FONT_FAMILY', defaultValue: 'packages/forui/Inter'),

      /*
      |------------------------------------------------------------------------
      | Font Size Scalar
      |------------------------------------------------------------------------
      |
      | A multiplier applied to all font sizes via FTypography.scale().
      | 1.0 = no change. 0.9 = 10% smaller. 1.1 = 10% larger.
      | Useful for accessibility or brand-specific sizing.
      |
      */

      'sizeScalar': 1.0,

      /*
      |------------------------------------------------------------------------
      | Touch Font Sizes (logical pixels)
      |------------------------------------------------------------------------
      |
      | Font sizes used on touch devices (Android, iOS, Fuchsia).
      | These are larger than desktop sizes for better readability on mobile.
      | Set to 0 to use the Forui default for that size.
      |
      | Forui touch defaults:
      |   xs3=10  xs2=12  xs=14  sm=16  md=18  lg=20
      |   xl=22   xl2=30  xl3=36 xl4=48 xl5=60 xl6=72 xl7=96 xl8=108
      |
      */

      'touch': {
        'xs3': 0.0,   // 10 default
        'xs2': 0.0,   // 12 default
        'xs':  0.0,   // 14 default
        'sm':  0.0,   // 16 default
        'md':  0.0,   // 18 default
        'lg':  0.0,   // 20 default
        'xl':  0.0,   // 22 default
        'xl2': 0.0,   // 30 default
        'xl3': 0.0,   // 36 default
        'xl4': 0.0,   // 48 default
        'xl5': 0.0,   // 60 default
        'xl6': 0.0,   // 72 default
        'xl7': 0.0,   // 96 default
        'xl8': 0.0,   // 108 default
      },

      /*
      |------------------------------------------------------------------------
      | Desktop Font Sizes (logical pixels)
      |------------------------------------------------------------------------
      |
      | Font sizes used on desktop / web (Windows, macOS, Linux).
      | These are more compact than touch sizes.
      | Set to 0 to use the Forui default for that size.
      |
      | Forui desktop defaults:
      |   xs3=8   xs2=10  xs=12  sm=14  md=16  lg=18
      |   xl=20   xl2=22  xl3=30 xl4=36 xl5=48 xl6=60 xl7=72 xl8=96
      |
      */

      'desktop': {
        'xs3': 0.0,   // 8 default
        'xs2': 0.0,   // 10 default
        'xs':  0.0,   // 12 default
        'sm':  0.0,   // 14 default
        'md':  0.0,   // 16 default
        'lg':  0.0,   // 18 default
        'xl':  0.0,   // 20 default
        'xl2': 0.0,   // 22 default
        'xl3': 0.0,   // 30 default
        'xl4': 0.0,   // 36 default
        'xl5': 0.0,   // 48 default
        'xl6': 0.0,   // 60 default
        'xl7': 0.0,   // 72 default
        'xl8': 0.0,   // 96 default
      },
    },

    // =========================================================================
    // STYLE (FStyle)
    // =========================================================================
    //
    // Miscellaneous styling options that apply globally to all widgets.
    // These map to Forui's FStyle class.
    //
    // See: https://forui.dev/docs/concepts/themes#style
    //
    // =========================================================================

    'style': {

      /*
      |------------------------------------------------------------------------
      | Border Width
      |------------------------------------------------------------------------
      |
      | The default border width in logical pixels used by all bordered
      | widgets (cards, inputs, dividers, etc.).
      |
      */

      'borderWidth': 1.0,

      /*
      |------------------------------------------------------------------------
      | Border Radius Scale
      |------------------------------------------------------------------------
      |
      | The border radius values used by all rounded widgets.
      | These map to FBorderRadius.sm / .md / .lg in Forui.
      |
      | Forui defaults: sm=4, md=8, lg=12
      |
      */

      'borderRadius': {
        'sm': 4.0,
        'md': 8.0,
        'lg': 12.0,
      },

      /*
      |------------------------------------------------------------------------
      | Icon Size
      |------------------------------------------------------------------------
      |
      | The default icon size in logical pixels. Forui derives this from
      | the lg typography font size by default.
      | Set to 0 to use the Forui default.
      |
      */

      'iconSize': 0.0,

      /*
      |------------------------------------------------------------------------
      | Page Padding
      |------------------------------------------------------------------------
      |
      | The default horizontal and vertical padding applied to page-level
      | content by FScaffold and similar layout widgets.
      |
      */

      'pagePaddingHorizontal': 12.0,
      'pagePaddingVertical':   8.0,
    },

    // =========================================================================
    // COLORS — LIGHT THEME (FColors)
    // =========================================================================
    //
    // Override individual colors in the light theme's FColors palette.
    // Colors are 0xAARRGGBB integers. Set to 0 to use the base theme default.
    //
    // Forui color pairs: each color has a matching *Foreground for text/icons.
    //   primary + primaryForeground
    //   secondary + secondaryForeground
    //   muted + mutedForeground
    //   destructive + destructiveForeground
    //   error + errorForeground
    //   card (surface color)
    //   background + foreground
    //   border
    //
    // See: https://forui.dev/docs/concepts/themes#colors
    //
    // =========================================================================

    'colors': {
      'light': {

        /*
        |----------------------------------------------------------------------
        | Primary
        |----------------------------------------------------------------------
        |
        | The main brand color. Used for primary buttons, active states,
        | focused outlines, and key interactive elements.
        |
        */

        'primary':            0,   // 0 = use base theme default
        'primaryForeground':  0,

        /*
        |----------------------------------------------------------------------
        | Secondary
        |----------------------------------------------------------------------
        |
        | Used for secondary buttons, badges, and less prominent UI elements.
        |
        */

        'secondary':           0,
        'secondaryForeground': 0,

        /*
        |----------------------------------------------------------------------
        | Muted
        |----------------------------------------------------------------------
        |
        | Used for subtle backgrounds (input fields, code blocks) and
        | de-emphasised text (placeholders, captions).
        |
        */

        'muted':           0,
        'mutedForeground': 0,

        /*
        |----------------------------------------------------------------------
        | Destructive
        |----------------------------------------------------------------------
        |
        | Used for destructive actions (delete buttons, error states).
        |
        */

        'destructive':           0,
        'destructiveForeground': 0,

        /*
        |----------------------------------------------------------------------
        | Error
        |----------------------------------------------------------------------
        |
        | Used for form validation errors and error banners.
        |
        */

        'error':           0,
        'errorForeground': 0,

        /*
        |----------------------------------------------------------------------
        | Background & Foreground
        |----------------------------------------------------------------------
        |
        | The page background color and the default text/icon color.
        |
        */

        'background': 0,
        'foreground': 0,

        /*
        |----------------------------------------------------------------------
        | Card
        |----------------------------------------------------------------------
        |
        | The surface color used for cards, popovers, and elevated containers.
        |
        */

        'card': 0,

        /*
        |----------------------------------------------------------------------
        | Border
        |----------------------------------------------------------------------
        |
        | The default border color used by inputs, dividers, and cards.
        |
        */

        'border': 0,
      },

      // ── Dark theme color overrides ─────────────────────────────────────────
      // Same keys as light — 0 means use the base theme default.

      'dark': {
        'primary':               0,
        'primaryForeground':     0,
        'secondary':             0,
        'secondaryForeground':   0,
        'muted':                 0,
        'mutedForeground':       0,
        'destructive':           0,
        'destructiveForeground': 0,
        'error':                 0,
        'errorForeground':       0,
        'background':            0,
        'foreground':            0,
        'card':                  0,
        'border':                0,
      },
    },

    // =========================================================================
    // STATUS COLORS (AppThemeExtension)
    // =========================================================================
    //
    // Semantic status colors used by AppStatusBadge, alerts, and banners.
    // These extend Forui's palette with success, warning, and info colors.
    // Colors are 0xAARRGGBB integers. Set to 0 to use the AppTheme default.
    //
    // =========================================================================

    'statusColors': {

      /*
      |------------------------------------------------------------------------
      | Light Mode Status Colors
      |------------------------------------------------------------------------
      */

      'light': {
        'success':           0,   // default: 0xFF22C55E
        'successForeground': 0,   // default: 0xFFFFFFFF
        'warning':           0,   // default: 0xFFF59E0B
        'warningForeground': 0,   // default: 0xFF0A0A0A
        'info':              0,   // default: 0xFF3B82F6
        'infoForeground':    0,   // default: 0xFFFFFFFF
        'hoverOverlay':      0,   // default: 0x0A000000 (4% black)
        'pressedOverlay':    0,   // default: 0x14000000 (8% black)
      },

      /*
      |------------------------------------------------------------------------
      | Dark Mode Status Colors
      |------------------------------------------------------------------------
      */

      'dark': {
        'success':           0,   // default: 0xFF4ADE80
        'successForeground': 0,   // default: 0xFF0A0A0A
        'warning':           0,   // default: 0xFFFBBF24
        'warningForeground': 0,   // default: 0xFF0A0A0A
        'info':              0,   // default: 0xFF60A5FA
        'infoForeground':    0,   // default: 0xFF0A0A0A
        'hoverOverlay':      0,   // default: 0x14FFFFFF (8% white)
        'pressedOverlay':    0,   // default: 0x1FFFFFFF (12% white)
      },
    },

    // =========================================================================
    // ANIMATION
    // =========================================================================

    'animation': {

      /*
      |------------------------------------------------------------------------
      | Animation Scale
      |------------------------------------------------------------------------
      |
      | A global multiplier for all animation durations.
      | 1.0 = default speed. 0.5 = twice as fast. 2.0 = twice as slow.
      | 0.0 = disable all animations (accessibility / reduce motion).
      |
      */

      'scale': 1.0,

      /*
      |------------------------------------------------------------------------
      | Duration Overrides (milliseconds)
      |------------------------------------------------------------------------
      |
      | Override individual animation durations. Set to 0 to use the default.
      |
      | Defaults: instant=50, fastest=100, fast=150, normal=200,
      |           medium=300, slow=400, slower=500, slowest=700
      |
      */

      'durations': {
        'instant': 0,
        'fastest': 0,
        'fast':    0,
        'normal':  0,
        'medium':  0,
        'slow':    0,
        'slower':  0,
        'slowest': 0,
      },
    },

  };
}
