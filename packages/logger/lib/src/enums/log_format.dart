// lib/src/enums/log_format.dart
//
// LogFormat — output format options for log messages.

/// The output format for log messages.
///
/// Configure via `Config.get('logging.format')`.
enum LogFormat {
  /// Coloured, human-readable output for development consoles.
  pretty,

  /// Single-line compact format without ANSI colours — suitable for staging.
  compact,

  /// Structured JSON for log aggregation services (Datadog, Loki, Logtail).
  json;

  // ── Parsing ───────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | fromString
  |--------------------------------------------------------------------------
  |
  | Parses a LogFormat from a string (case-insensitive).
  | Returns LogFormat.pretty if the string does not match any format.
  |
  */

  /// Parses a [LogFormat] from a string (case-insensitive).
  static LogFormat fromString(String value) {
    return LogFormat.values.firstWhere(
      (f) => f.name == value.toLowerCase(),
      orElse: () => LogFormat.pretty,
    );
  }
}
