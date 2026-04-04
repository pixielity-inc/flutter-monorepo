// lib/src/enums/log_level.dart
//
// LogLevel — severity levels in ascending order.

/// Log severity levels in ascending order.
///
/// Configure the minimum level via `Config.get('logging.level')`.
/// Messages below the minimum are discarded without processing.
enum LogLevel {
  /// Highly detailed diagnostic output — development only.
  verbose,

  /// Standard debug information.
  debug,

  /// Informational messages about normal app flow.
  info,

  /// Potentially harmful situations that don't stop execution.
  warning,

  /// Errors that affect functionality but don't crash the app.
  error,

  /// Critical failures — app cannot continue.
  fatal,

  /// Disable all logging.
  none;

  // ── Parsing ───────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | fromString
  |--------------------------------------------------------------------------
  |
  | Parses a LogLevel from a string (case-insensitive).
  | Returns LogLevel.info if the string does not match any level.
  |
  */

  /// Parses a [LogLevel] from a string (case-insensitive).
  static LogLevel fromString(String value) {
    return LogLevel.values.firstWhere(
      (l) => l.name == value.toLowerCase(),
      orElse: () => LogLevel.info,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns `true` if this level is at or above [minimum].
  bool isAtLeast(LogLevel minimum) => index >= minimum.index;

  /// Single-character label used in compact log output.
  String get label => switch (this) {
    LogLevel.verbose => 'V',
    LogLevel.debug   => 'D',
    LogLevel.info    => 'I',
    LogLevel.warning => 'W',
    LogLevel.error   => 'E',
    LogLevel.fatal   => 'F',
    LogLevel.none    => '-',
  };

  /// ANSI colour code for pretty console output.
  String get ansiColor => switch (this) {
    LogLevel.verbose => '\x1B[37m',   // white
    LogLevel.debug   => '\x1B[36m',   // cyan
    LogLevel.info    => '\x1B[32m',   // green
    LogLevel.warning => '\x1B[33m',   // yellow
    LogLevel.error   => '\x1B[31m',   // red
    LogLevel.fatal   => '\x1B[35m',   // magenta
    LogLevel.none    => '\x1B[0m',    // reset
  };

  /// ANSI reset escape code.
  static const String ansiReset = '\x1B[0m';
}
