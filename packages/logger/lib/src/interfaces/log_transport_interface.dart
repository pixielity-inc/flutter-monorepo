// lib/src/interfaces/log_transport_interface.dart
//
// LogTransportInterface — contract for all log output destinations.
//
// Implement this to add a new transport (file, Crashlytics, Sentry, etc.).

import 'package:logger/src/log_entry.dart';
import 'package:logger/src/enums/log_level.dart';

/// Contract for a log output destination.
///
/// Each transport receives a [LogEntry] and decides how to emit it.
/// Transports can filter by level, format the entry, and write to any sink.
///
/// ```dart
/// class CrashlyticsTransport implements LogTransportInterface {
///   @override
///   LogLevel get minLevel => LogLevel.error;
///
///   @override
///   Future<void> write(LogEntry entry) async {
///     await FirebaseCrashlytics.instance.recordError(
///       entry.error,
///       entry.stackTrace,
///       reason: entry.message,
///     );
///   }
/// }
/// ```
abstract interface class LogTransportInterface {
  /*
  |--------------------------------------------------------------------------
  | minLevel
  |--------------------------------------------------------------------------
  |
  | The minimum level this transport will accept.
  | Entries below this level are silently ignored.
  | Defaults to LogLevel.verbose (accepts everything).
  |
  */

  /// The minimum [LogLevel] this transport accepts.
  LogLevel get minLevel => LogLevel.verbose;

  /*
  |--------------------------------------------------------------------------
  | write
  |--------------------------------------------------------------------------
  |
  | Writes [entry] to this transport's output sink.
  | Called by Logger after level filtering and PII redaction.
  |
  */

  /// Writes [entry] to this transport's output sink.
  Future<void> write(LogEntry entry);

  /*
  |--------------------------------------------------------------------------
  | flush
  |--------------------------------------------------------------------------
  |
  | Flushes any buffered entries. No-op for unbuffered transports.
  | Called on app shutdown or foreground/background transitions.
  |
  */

  /// Flushes any buffered entries.
  Future<void> flush() async {}

  /*
  |--------------------------------------------------------------------------
  | close
  |--------------------------------------------------------------------------
  |
  | Closes the transport and releases resources (file handles, HTTP clients).
  | Called when the Logger is disposed.
  |
  */

  /// Closes the transport and releases resources.
  Future<void> close() async {}
}
