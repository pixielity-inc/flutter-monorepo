// ignore_for_file: lines_longer_than_80_chars

const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

/// Authentication and authorisation configuration.
///
/// Access values via Config.get('auth.<key>').
Map<String, dynamic> authConfig() {
  return {

    /*
    |--------------------------------------------------------------------------
    | Authentication Strategy
    |--------------------------------------------------------------------------
    |
    | This value controls the authentication mechanism used by the app.
    | "jwt" uses an access + refresh token pair. "oauth2" uses the
    | authorization code flow. "apiKey" sends a static key in a header.
    | "none" disables authentication entirely (public apps).
    |
    | Supported: "jwt", "oauth2", "apiKey", "sessionCookie", "none"
    |
    | dart-define: AUTH_STRATEGY
    |
    */

    'strategy': const String.fromEnvironment('AUTH_STRATEGY', defaultValue: 'jwt'),

    /*
    |--------------------------------------------------------------------------
    | Token Storage
    |--------------------------------------------------------------------------
    |
    | Determines where authentication tokens are persisted between app
    | launches. "secureStorage" uses the platform keychain / keystore and
    | is the only option suitable for production. "memory" stores tokens
    | in RAM only — they are lost when the app is killed.
    |
    | Supported: "secureStorage", "memory", "sharedPreferences"
    |
    | Automatically set to "memory" in development to avoid keychain noise.
    |
    */

    'tokenStorage': _env == 'development' ? 'memory' : 'secureStorage',

    /*
    |--------------------------------------------------------------------------
    | Token Refresh Threshold
    |--------------------------------------------------------------------------
    |
    | The number of seconds before access token expiry at which the client
    | will proactively request a new token. For example, a value of 300
    | means the token is refreshed when less than 5 minutes remain.
    |
    | dart-define: AUTH_REFRESH_THRESHOLD_S
    |
    */

    'refreshThresholdSeconds': const int.fromEnvironment(
      'AUTH_REFRESH_THRESHOLD_S',
      defaultValue: 300,
    ),

    /*
    |--------------------------------------------------------------------------
    | Maximum Refresh Retries
    |--------------------------------------------------------------------------
    |
    | The number of times the client will attempt to refresh an expired
    | token before giving up and forcing the user to log in again.
    |
    | dart-define: AUTH_MAX_REFRESH_RETRIES
    |
    */

    'maxRefreshRetries': const int.fromEnvironment('AUTH_MAX_REFRESH_RETRIES', defaultValue: 3),

    /*
    |--------------------------------------------------------------------------
    | Session Timeout
    |--------------------------------------------------------------------------
    |
    | The maximum duration of a user session in seconds. After this time
    | the user will be required to authenticate again regardless of activity.
    |
    | dart-define: AUTH_SESSION_TIMEOUT_S
    |
    */

    'sessionTimeoutSeconds': const int.fromEnvironment(
      'AUTH_SESSION_TIMEOUT_S',
      defaultValue: 86400, // 24 hours
    ),

    /*
    |--------------------------------------------------------------------------
    | Inactivity Timeout
    |--------------------------------------------------------------------------
    |
    | The number of seconds of user inactivity after which the app is locked
    | and requires re-authentication. Set to 0 to disable inactivity locking.
    |
    | dart-define: AUTH_INACTIVITY_TIMEOUT_S
    |
    */

    'inactivityTimeoutSeconds': const int.fromEnvironment(
      'AUTH_INACTIVITY_TIMEOUT_S',
      defaultValue: 1800, // 30 minutes
    ),

    /*
    |--------------------------------------------------------------------------
    | Biometric Authentication
    |--------------------------------------------------------------------------
    |
    | When enabled, the app will offer Face ID / fingerprint authentication
    | as an alternative to the user's password or PIN.
    |
    | dart-define: AUTH_ENABLE_BIOMETRICS
    |
    */

    'enableBiometrics': const bool.fromEnvironment('AUTH_ENABLE_BIOMETRICS'),

    /*
    |--------------------------------------------------------------------------
    | PIN Fallback
    |--------------------------------------------------------------------------
    |
    | When enabled, a PIN is required as a fallback when biometric
    | authentication fails or is unavailable. Automatically enabled
    | in production for additional security.
    |
    */

    'requirePinFallback': _env == 'production',

    /*
    |--------------------------------------------------------------------------
    | API Key Header Name
    |--------------------------------------------------------------------------
    |
    | The HTTP request header used to transmit the API key when the
    | "apiKey" authentication strategy is selected.
    |
    | dart-define: AUTH_API_KEY_HEADER
    |
    */

    'apiKeyHeaderName': const String.fromEnvironment(
      'AUTH_API_KEY_HEADER',
      defaultValue: 'X-API-Key',
    ),

    /*
    |--------------------------------------------------------------------------
    | OAuth2 / OIDC Configuration
    |--------------------------------------------------------------------------
    |
    | These values are required when the authentication strategy is set to
    | "oauth2". PKCE (Proof Key for Code Exchange) is always enabled for
    | mobile clients to prevent authorisation code interception attacks.
    |
    | dart-define: AUTH_OAUTH2_CLIENT_ID, AUTH_OAUTH2_REDIRECT_URI,
    |              AUTH_OAUTH2_AUTH_ENDPOINT, AUTH_OAUTH2_TOKEN_ENDPOINT,
    |              AUTH_OAUTH2_DISCOVERY_URL, AUTH_OAUTH2_SCOPES
    |
    */

    'oauth2': {
      'clientId':               const String.fromEnvironment('AUTH_OAUTH2_CLIENT_ID'),
      'clientSecret':           const String.fromEnvironment('AUTH_OAUTH2_CLIENT_SECRET'),
      'authorizationEndpoint':  const String.fromEnvironment('AUTH_OAUTH2_AUTH_ENDPOINT'),
      'tokenEndpoint':          const String.fromEnvironment('AUTH_OAUTH2_TOKEN_ENDPOINT'),
      'redirectUri':            const String.fromEnvironment('AUTH_OAUTH2_REDIRECT_URI'),
      'discoveryUrl':           const String.fromEnvironment('AUTH_OAUTH2_DISCOVERY_URL'),
      // Comma-separated scopes: 'openid,profile,email'
      'scopes': const String.fromEnvironment(
        'AUTH_OAUTH2_SCOPES',
        defaultValue: 'openid,profile,email',
      ),
      // Always true for mobile apps — prevents auth code interception.
      'usePkce': true,
    },

  };
}
