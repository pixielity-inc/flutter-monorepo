// ignore_for_file: lines_longer_than_80_chars

const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

/// Feature flag configuration.
///
/// All flags default to false (fail-closed / safe default).
/// Enable flags explicitly via --dart-define or a remote provider.
///
/// Access values via Config.get('feature_flags.<key>', fallback: false).
Map<String, dynamic> featureFlagsConfig() {
  return {

    /*
    |--------------------------------------------------------------------------
    | New Onboarding Flow
    |--------------------------------------------------------------------------
    |
    | Enables the redesigned onboarding experience. When disabled, the
    | legacy onboarding flow is shown. Roll out gradually by enabling in
    | staging first, then production.
    |
    | dart-define: FLAG_NEW_ONBOARDING
    |
    */

    'new_onboarding': const bool.fromEnvironment('FLAG_NEW_ONBOARDING'),

    /*
    |--------------------------------------------------------------------------
    | AI Assistant
    |--------------------------------------------------------------------------
    |
    | Enables the in-app AI assistant feature. Requires a valid API key
    | to be configured in the api config. Disabled by default until the
    | feature is ready for general availability.
    |
    | dart-define: FLAG_AI_ASSISTANT
    |
    */

    'ai_assistant': const bool.fromEnvironment('FLAG_AI_ASSISTANT'),

    /*
    |--------------------------------------------------------------------------
    | Premium Themes
    |--------------------------------------------------------------------------
    |
    | Unlocks the premium theme selection screen. Should only be enabled
    | for users with an active pro or enterprise subscription.
    |
    | dart-define: FLAG_PREMIUM_THEMES
    |
    */

    'premium_themes': const bool.fromEnvironment('FLAG_PREMIUM_THEMES'),

    /*
    |--------------------------------------------------------------------------
    | New Dashboard
    |--------------------------------------------------------------------------
    |
    | Enables the redesigned dashboard layout. The legacy dashboard is
    | shown when this flag is disabled.
    |
    | dart-define: FLAG_NEW_DASHBOARD
    |
    */

    'new_dashboard': const bool.fromEnvironment('FLAG_NEW_DASHBOARD'),

    /*
    |--------------------------------------------------------------------------
    | Offline Mode
    |--------------------------------------------------------------------------
    |
    | Enables full offline support with local-first data sync. Requires
    | the database and sync engine to be configured in storage config.
    |
    | dart-define: FLAG_OFFLINE_MODE
    |
    */

    'offline_mode': const bool.fromEnvironment('FLAG_OFFLINE_MODE'),

    /*
    |--------------------------------------------------------------------------
    | Debug Overrides
    |--------------------------------------------------------------------------
    |
    | When enabled, individual feature flags can be toggled at runtime via
    | the in-app debug menu. Overrides are stored in SharedPreferences and
    | take precedence over both static and remote values.
    | Automatically disabled in production.
    |
    */

    'enableDebugOverrides': _env != 'production',

    /*
    |--------------------------------------------------------------------------
    | Remote Feature Flag Provider
    |--------------------------------------------------------------------------
    |
    | Configures a remote feature flag service. Static flags defined above
    | act as safe defaults until the first successful remote fetch.
    | Set provider to "none" to use static flags only.
    |
    | Supported providers: "none", "launchDarkly", "unleash",
    |                       "firebaseRemoteConfig", "custom"
    |
    | dart-define: FLAGS_REMOTE_PROVIDER, FLAGS_REMOTE_SDK_KEY,
    |              FLAGS_REMOTE_ENDPOINT, FLAGS_FETCH_INTERVAL_M,
    |              FLAGS_FETCH_TIMEOUT_S, FLAGS_ENABLE_STREAMING
    |
    */

    'remote': {
      'provider':             const String.fromEnvironment('FLAGS_REMOTE_PROVIDER', defaultValue: 'none'),
      'sdkKey':               const String.fromEnvironment('FLAGS_REMOTE_SDK_KEY'),
      'endpoint':             const String.fromEnvironment('FLAGS_REMOTE_ENDPOINT'),
      'fetchIntervalMinutes': const int.fromEnvironment('FLAGS_FETCH_INTERVAL_M',  defaultValue: 5),
      'fetchTimeoutSeconds':  const int.fromEnvironment('FLAGS_FETCH_TIMEOUT_S',   defaultValue: 10),
      // Use SSE streaming instead of polling (LaunchDarkly, some Unleash configs).
      'enableStreaming':       const bool.fromEnvironment('FLAGS_ENABLE_STREAMING'),
    },

  };
}
