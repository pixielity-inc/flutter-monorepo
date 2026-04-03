// ignore_for_file: lines_longer_than_80_chars

const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

/// API / HTTP client configuration.
///
/// Equivalent to a Laravel config/services.php or config/http.php.
/// Access values via Config.get('api.<key>').
Map<String, dynamic> apiConfig() {
  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  const version = String.fromEnvironment('API_VERSION', defaultValue: 'v1');

  return {

    /*
    |--------------------------------------------------------------------------
    | Base URL
    |--------------------------------------------------------------------------
    |
    | The root URL for all API requests. Must not have a trailing slash.
    | Each environment should point to its own API server.
    |
    | dart-define: API_BASE_URL
    |
    */

    'baseUrl': baseUrl,

    /*
    |--------------------------------------------------------------------------
    | API Version
    |--------------------------------------------------------------------------
    |
    | The version segment appended to the base URL for all requests.
    | The full versioned URL becomes: baseUrl/version (e.g. .../v1).
    |
    | dart-define: API_VERSION
    |
    */

    'version': version,

    // Computed convenience value: baseUrl + '/' + version.
    'versionedBaseUrl': '$baseUrl/$version',

    /*
    |--------------------------------------------------------------------------
    | Request Timeouts
    |--------------------------------------------------------------------------
    |
    | These values control how long the HTTP client will wait at each stage
    | of a request before giving up and throwing a timeout error.
    | All values are in seconds.
    |
    | dart-define: API_CONNECT_TIMEOUT_S, API_RECEIVE_TIMEOUT_S, API_SEND_TIMEOUT_S
    |
    */

    'connectTimeoutSeconds': const int.fromEnvironment('API_CONNECT_TIMEOUT_S', defaultValue: 10),
    'receiveTimeoutSeconds': const int.fromEnvironment('API_RECEIVE_TIMEOUT_S', defaultValue: 30),
    'sendTimeoutSeconds':    const int.fromEnvironment('API_SEND_TIMEOUT_S',    defaultValue: 30),

    /*
    |--------------------------------------------------------------------------
    | Retry Policy
    |--------------------------------------------------------------------------
    |
    | Controls how failed requests are retried. The backoff strategy
    | determines the delay between attempts.
    |
    | Supported backoff: "none", "fixed", "exponential"
    |
    | Requests are retried on the following HTTP status codes by default:
    |   408 (Request Timeout), 429 (Too Many Requests),
    |   500, 502, 503, 504 (Server Errors)
    |
    | dart-define: API_MAX_RETRIES, API_RETRY_BACKOFF,
    |              API_RETRY_INITIAL_DELAY_MS, API_RETRY_MAX_DELAY_MS
    |
    */

    'maxRetries':          const int.fromEnvironment('API_MAX_RETRIES',            defaultValue: 3),
    'retryBackoff':        const String.fromEnvironment('API_RETRY_BACKOFF',        defaultValue: 'exponential'),
    'retryInitialDelayMs': const int.fromEnvironment('API_RETRY_INITIAL_DELAY_MS', defaultValue: 500),
    'retryMaxDelayMs':     const int.fromEnvironment('API_RETRY_MAX_DELAY_MS',     defaultValue: 30000),
    'retryOnStatusCodes':  const String.fromEnvironment('API_RETRY_STATUS_CODES',  defaultValue: '408,429,500,502,503,504'),

    /*
    |--------------------------------------------------------------------------
    | Request Logging
    |--------------------------------------------------------------------------
    |
    | When enabled, full request and response details are written to the
    | debug console. This must never be enabled in production as it will
    | expose sensitive headers, tokens, and response bodies.
    |
    | Automatically disabled when ENV=production.
    |
    | dart-define: API_ENABLE_LOGGING
    |
    */

    'enableLogging': _env != 'production',

    /*
    |--------------------------------------------------------------------------
    | Certificate Pinning
    |--------------------------------------------------------------------------
    |
    | When enabled, the HTTP client will only accept the server certificate
    | that matches the pinned public key. This prevents man-in-the-middle
    | attacks but must be disabled when using a proxy tool like Charles.
    |
    | dart-define: API_ENABLE_CERT_PINNING
    |
    */

    'enableCertificatePinning': const bool.fromEnvironment('API_ENABLE_CERT_PINNING'),

    /*
    |--------------------------------------------------------------------------
    | Concurrency Limit
    |--------------------------------------------------------------------------
    |
    | The maximum number of HTTP requests that may be in-flight at the same
    | time. Requests beyond this limit are queued until a slot is free.
    |
    | dart-define: API_MAX_CONCURRENT
    |
    */

    'maxConcurrentRequests': const int.fromEnvironment('API_MAX_CONCURRENT', defaultValue: 10),

    /*
    |--------------------------------------------------------------------------
    | HTTP Proxy
    |--------------------------------------------------------------------------
    |
    | Set a proxy host and port to route all HTTP traffic through a debugging
    | proxy such as Charles Proxy (8888) or Proxyman (9090).
    | Leave both empty to use the system network directly.
    |
    | dart-define: API_PROXY_HOST, API_PROXY_PORT
    |
    */

    'proxyHost': const String.fromEnvironment('API_PROXY_HOST'),
    'proxyPort': const int.fromEnvironment('API_PROXY_PORT'),

    /*
    |--------------------------------------------------------------------------
    | Default Headers
    |--------------------------------------------------------------------------
    |
    | These headers are merged into every outgoing request. Individual
    | requests may override them by providing their own headers.
    |
    */

    'headers': <String, String>{
      'Accept':        'application/json',
      'Content-Type':  'application/json',
      'X-App-Version': const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0'),
    },

  };
}
