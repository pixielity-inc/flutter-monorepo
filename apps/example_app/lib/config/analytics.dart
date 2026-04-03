// ignore_for_file: lines_longer_than_80_chars

const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

/// Analytics and crash reporting configuration.
///
/// Access values via Config.get('analytics.<key>').
Map<String, dynamic> analyticsConfig() {
  return {

    /*
    |--------------------------------------------------------------------------
    | Analytics
    |--------------------------------------------------------------------------
    |
    | Master switch for all event tracking. When disabled, no events are
    | sent to any analytics provider regardless of individual provider
    | settings. Disabled by default — enable explicitly in staging/production.
    |
    | dart-define: ANALYTICS_ENABLED
    |
    */

    'enabled': const bool.fromEnvironment('ANALYTICS_ENABLED'),

    /*
    |--------------------------------------------------------------------------
    | Crash Reporting
    |--------------------------------------------------------------------------
    |
    | Master switch for crash and error reporting. When disabled, no crash
    | reports are sent to any provider. Disabled by default — enable
    | explicitly in staging/production.
    |
    | dart-define: ANALYTICS_CRASH_ENABLED
    |
    */

    'crashReportingEnabled': const bool.fromEnvironment('ANALYTICS_CRASH_ENABLED'),

    /*
    |--------------------------------------------------------------------------
    | Screen Tracking
    |--------------------------------------------------------------------------
    |
    | When enabled, screen views and route changes are automatically tracked
    | and sent to the configured analytics providers.
    |
    */

    'screenTrackingEnabled': _env != 'development',

    /*
    |--------------------------------------------------------------------------
    | Sampling Rate
    |--------------------------------------------------------------------------
    |
    | The fraction of user sessions to track, between 0.0 and 1.0.
    | 1.0 tracks all sessions. 0.1 tracks 10% of sessions, which is useful
    | for high-traffic applications to reduce cost and noise.
    |
    */

    'samplingRate': _env == 'production' ? 1.0 : 0.1,

    /*
    |--------------------------------------------------------------------------
    | PII Scrubbing
    |--------------------------------------------------------------------------
    |
    | When enabled, personally identifiable information is automatically
    | removed from event properties before they are sent to any provider.
    | The piiFields list defines which property names are considered PII.
    |
    */

    'scrubPii':  true,
    'piiFields': ['email', 'phone', 'name', 'address', 'ip_address'],

    /*
    |--------------------------------------------------------------------------
    | Session Timeout
    |--------------------------------------------------------------------------
    |
    | The number of minutes of inactivity after which a new analytics
    | session is started. This affects session-level metrics and funnels.
    |
    */

    'sessionTimeoutMinutes': 30,

    /*
    |--------------------------------------------------------------------------
    | Analytics Providers
    |--------------------------------------------------------------------------
    |
    | Enable one or more analytics providers. Multiple providers can be
    | active simultaneously — events are forwarded to all enabled providers.
    |
    | dart-define: ANALYTICS_FIREBASE, ANALYTICS_MIXPANEL,
    |              ANALYTICS_AMPLITUDE, ANALYTICS_SEGMENT, ANALYTICS_POSTHOG
    |
    */

    'providers': {
      'firebaseAnalytics': const bool.fromEnvironment('ANALYTICS_FIREBASE'),
      'mixpanel':          const bool.fromEnvironment('ANALYTICS_MIXPANEL'),
      'amplitude':         const bool.fromEnvironment('ANALYTICS_AMPLITUDE'),
      'segment':           const bool.fromEnvironment('ANALYTICS_SEGMENT'),
      'posthog':           const bool.fromEnvironment('ANALYTICS_POSTHOG'),
    },

    /*
    |--------------------------------------------------------------------------
    | Crash Reporting Providers
    |--------------------------------------------------------------------------
    |
    | Enable one or more crash reporting providers. Both can be active
    | simultaneously if needed.
    |
    | dart-define: ANALYTICS_SENTRY, ANALYTICS_CRASHLYTICS
    |
    */

    'crash': {
      'sentry':               const bool.fromEnvironment('ANALYTICS_SENTRY'),
      'firebaseCrashlytics':  const bool.fromEnvironment('ANALYTICS_CRASHLYTICS'),
    },

  };
}
