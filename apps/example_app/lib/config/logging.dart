// ignore_for_file: lines_longer_than_80_chars

const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

/// Logging configuration.
///
/// Access values via Config.get('logging.<key>').
Map<String, dynamic> loggingConfig() {
  return {

    /*
    |--------------------------------------------------------------------------
    | Log Level
    |--------------------------------------------------------------------------
    |
    | The minimum severity level required for a message to be emitted.
    | Messages below this level are silently discarded. Defaults to "verbose"
    | in development, "info" in staging, and "warning" in production.
    |
    | Supported: "verbose", "debug", "info", "warning", "error", "fatal", "none"
    |
    | dart-define: LOG_LEVEL
    |
    */

    'level': const String.fromEnvironment(
      'LOG_LEVEL',
      defaultValue: _env == 'production'
          ? 'warning'
          : _env == 'staging'
          ? 'info'
          : 'verbose',
    ),

    /*
    |--------------------------------------------------------------------------
    | Console Output
    |--------------------------------------------------------------------------
    |
    | When enabled, log messages are written to the debug console (stdout).
    | Automatically disabled in production to avoid leaking information
    | through device logs.
    |
    */

    'enableConsole': _env != 'production',

    /*
    |--------------------------------------------------------------------------
    | File Output
    |--------------------------------------------------------------------------
    |
    | When enabled, log messages are written to a rotating set of files on
    | the device. Useful for capturing logs from field devices or QA testers.
    |
    | dart-define: LOG_ENABLE_FILE
    |
    */

    'enableFile': const bool.fromEnvironment('LOG_ENABLE_FILE'),

    /*
    |--------------------------------------------------------------------------
    | Log Format
    |--------------------------------------------------------------------------
    |
    | Controls the output format of log messages.
    | "pretty"  — coloured, human-readable output for development consoles.
    | "compact" — single-line format suitable for staging.
    | "json"    — structured JSON for log aggregation services (Datadog, Loki).
    |
    | Supported: "pretty", "compact", "json"
    |
    | dart-define: LOG_FORMAT
    |
    */

    'format': const String.fromEnvironment(
      'LOG_FORMAT',
      defaultValue: _env == 'production'
          ? 'json'
          : _env == 'staging'
          ? 'compact'
          : 'pretty',
    ),

    /*
    |--------------------------------------------------------------------------
    | PII Redaction
    |--------------------------------------------------------------------------
    |
    | When enabled, patterns matching personally identifiable information
    | (email addresses, phone numbers) are automatically redacted from log
    | output before it is written to any transport.
    |
    */

    'redactPii': true,

    /*
    |--------------------------------------------------------------------------
    | Log Metadata
    |--------------------------------------------------------------------------
    |
    | Controls which metadata fields are included in each log entry.
    | Stack traces are included for error-level and above in non-production
    | environments to aid debugging without cluttering production logs.
    |
    */

    'includeTimestamp':  true,
    'includeStackTrace': _env != 'production',

    /*
    |--------------------------------------------------------------------------
    | File Rotation
    |--------------------------------------------------------------------------
    |
    | Controls the rotating log file behaviour when file output is enabled.
    | Once a file reaches maxFileSizeMb it is rotated. At most maxFileCount
    | files are kept on disk — older files are deleted automatically.
    |
    */

    'maxFileSizeMb': 10,
    'maxFileCount':  5,

    /*
    |--------------------------------------------------------------------------
    | Remote Transport
    |--------------------------------------------------------------------------
    |
    | Sends log entries to a remote log aggregation service such as Datadog,
    | Logtail, or a self-hosted Loki instance. An empty endpoint disables
    | the remote transport entirely.
    |
    | Only entries at or above minLevel are forwarded to reduce cost.
    |
    | dart-define: LOG_REMOTE_ENDPOINT, LOG_REMOTE_API_KEY
    |
    */

    'remote': {
      'endpoint':             const String.fromEnvironment('LOG_REMOTE_ENDPOINT'),
      'apiKey':               const String.fromEnvironment('LOG_REMOTE_API_KEY'),
      'batchSize':            50,
      'flushIntervalSeconds': 10,
      'minLevel':             'warning',
    },

  };
}
