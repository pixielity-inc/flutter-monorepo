// lib/src/interfaces/log_formatter_interface.dart
//
// LogFormatterInterface — contract for all log formatters.
//
// Implement this to create a custom formatter.
// Register it via Logger.setFormatter() or LoggerServiceProvider.

import 'package:logger/src/log_entry.dart';

/// Contract for log message formatters.
///
/// A formatter converts a [LogEntry] into a string ready for output.
/// Implement this interface to create a custom format.
///
/// ```dart
/// class XmlFormatter implements LogFormatterInterface {
///   @override
///   String format(LogEntry entry) =>
///     '<log level="${entry.level.name}">${entry.message}</log>';
/// }
/// ```
abstract interface class LogFormatterInterface {
  /*
  |--------------------------------------------------------------------------
  | format
  |--------------------------------------------------------------------------
  |
  | Converts [entry] to a formatted string for output.
  | Called by Logger before passing the string to a transport.
  |
  */

  /// Converts [entry] to a formatted output string.
  String format(LogEntry entry);
}
