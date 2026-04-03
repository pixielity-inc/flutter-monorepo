// ignore_for_file: lines_longer_than_80_chars

const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

/// Application configuration.
///
/// Equivalent to Laravel's config/app.php.
/// Access values via Config.get('app.<key>').
Map<String, dynamic> appConfig() {
  return {

    /*
    |--------------------------------------------------------------------------
    | Application Name
    |--------------------------------------------------------------------------
    |
    | This value is the name of your application. It will be used when the
    | framework needs to place the application name in a notification or
    | any other location as required by the application or its packages.
    |
    | dart-define: APP_NAME
    |
    */

    'name': const String.fromEnvironment('APP_NAME', defaultValue: 'Pixielity'),

    /*
    |--------------------------------------------------------------------------
    | Application Version
    |--------------------------------------------------------------------------
    |
    | The semantic version string of this build, e.g. "1.2.3". Used in
    | about screens, update checks, and request headers.
    |
    | dart-define: APP_VERSION
    |
    */

    'version': const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0'),

    /*
    |--------------------------------------------------------------------------
    | Application Build Number
    |--------------------------------------------------------------------------
    |
    | A monotonically increasing integer that identifies this specific build.
    | Used by app stores and update-check logic to compare builds.
    |
    | dart-define: APP_BUILD_NUMBER
    |
    */

    'buildNumber': const int.fromEnvironment('APP_BUILD_NUMBER', defaultValue: 1),

    /*
    |--------------------------------------------------------------------------
    | Application Environment
    |--------------------------------------------------------------------------
    |
    | This value determines the "environment" your application is currently
    | running in. This may determine how you prefer to configure various
    | services the application utilises. Set this via --dart-define=ENV=<value>.
    |
    | Supported: "development", "staging", "production"
    |
    | dart-define: ENV
    |
    */

    'environment': _env,
    'isDevelopment': _env == 'development',
    'isStaging':     _env == 'staging',
    'isProduction':  _env == 'production',

    /*
    |--------------------------------------------------------------------------
    | Debug Mode
    |--------------------------------------------------------------------------
    |
    | When your application is in debug mode the Flutter debug banner is
    | shown and additional developer tooling is enabled. This is derived
    | automatically from the environment — never enable in production.
    |
    */

    'showDebugBanner': _env == 'development',
    'showDebugTools':  _env != 'production',

    /*
    |--------------------------------------------------------------------------
    | Application Flavor
    |--------------------------------------------------------------------------
    |
    | The flavor controls which feature set is active. Useful for white-label
    | apps or free / pro / enterprise variants of the same codebase.
    |
    | Supported: "standard", "free", "pro", "enterprise"
    |
    | dart-define: APP_FLAVOR
    |
    */

    'flavor': const String.fromEnvironment('APP_FLAVOR', defaultValue: 'standard'),

    /*
    |--------------------------------------------------------------------------
    | Deep Link Scheme
    |--------------------------------------------------------------------------
    |
    | The custom URL scheme used for deep links into the app.
    | For example, a scheme of "pixielity" produces links like pixielity://...
    |
    | dart-define: APP_DEEP_LINK_SCHEME
    |
    */

    'deepLinkScheme': const String.fromEnvironment(
      'APP_DEEP_LINK_SCHEME',
      defaultValue: 'pixielity',
    ),

    /*
    |--------------------------------------------------------------------------
    | Sentry DSN
    |--------------------------------------------------------------------------
    |
    | The Data Source Name used to connect to Sentry for crash reporting and
    | performance monitoring. An empty string disables Sentry entirely.
    | It is strongly recommended to set this in production builds.
    |
    | dart-define: APP_SENTRY_DSN
    |
    */

    'sentryDsn': const String.fromEnvironment('APP_SENTRY_DSN'),

    /*
    |--------------------------------------------------------------------------
    | Support Email
    |--------------------------------------------------------------------------
    |
    | The email address displayed in the app's help and support screens.
    | Users will be directed here when they need assistance.
    |
    | dart-define: APP_SUPPORT_EMAIL
    |
    */

    'supportEmail': const String.fromEnvironment(
      'APP_SUPPORT_EMAIL',
      defaultValue: 'support@pixielity.com',
    ),

    /*
    |--------------------------------------------------------------------------
    | Privacy Policy URL
    |--------------------------------------------------------------------------
    |
    | The URL to the application's privacy policy page. Shown during
    | onboarding and in the settings screen.
    |
    | dart-define: APP_PRIVACY_URL
    |
    */

    'privacyPolicyUrl': const String.fromEnvironment(
      'APP_PRIVACY_URL',
      defaultValue: 'https://pixielity.com/privacy',
    ),

    /*
    |--------------------------------------------------------------------------
    | Terms of Service URL
    |--------------------------------------------------------------------------
    |
    | The URL to the application's terms of service page. Shown during
    | onboarding and in the settings screen.
    |
    | dart-define: APP_TERMS_URL
    |
    */

    'termsUrl': const String.fromEnvironment(
      'APP_TERMS_URL',
      defaultValue: 'https://pixielity.com/terms',
    ),

  };
}
