// ignore_for_file: lines_longer_than_80_chars
// lib/src/context/log_context.dart
//
// LogContext — contextual data attached to a logger instance.
//
// Mirrors Laravel's Logger::withContext() pattern. A context is a map of
// key/value pairs automatically merged into every log entry's `extra` field.
//
// Usage:
//   final log = Logger('Auth').withContext({'userId': '42', 'ip': '127.0.0.1'});
//   log.info('User logged in');
//   // entry.extra = {'userId': '42', 'ip': '127.0.0.1'}
//
//   final clean = log.withoutContext();
//   clean.info('Context cleared');
//   // entry.extra = {}

import 'package:logger/src/log_entry.dart';
import 'package:logger/src/enums/log_level.dart';
import 'package:logger/src/pii_redactor.dart';
import 'package:logger/src/interfaces/log_transport_interface.dart';

/// Holds contextual key/value pairs that are merged into every log entry.
///
/// Created via [Logger.withContext] — returns a new logger instance with
/// the context attached. The original logger is not modified.
///
/// ```dart
/// // Attach request context for the duration of a request
/// final log = Logger('Api').withContext({
///   'requestId': request.id,
///   'userId':    currentUser.id,
///   'path':      request.path,
/// });
///
/// log.info('Request received');
/// log.error('Handler failed', error: e);
/// // Both entries include requestId, userId, path in extra.
///
/// // Remove all context
/// final clean = log.withoutContext();
///
/// // Add more context on top of existing
/// final enriched = log.withContext({'traceId': 'abc123'});
/// ```
class LogContext {
  /// Creates a [LogContext] with the given [data].
  const LogContext(this.data);

  /// The contextual key/value pairs.
  final Map<String, dynamic> data;

  /// Returns a new [LogContext] with [additional] merged in.
  LogContext merge(Map<String, dynamic> additional) =>
      LogContext({...data, ...additional});

  /// Returns an empty [LogContext].
  static const LogContext empty = LogContext({});
}

/// A logger instance that carries a [LogContext] and optional [tag].
///
/// Created via [Logger.withContext], [Logger.withTag], or [Logger.withoutContext].
/// All log methods automatically merge the context into every entry's `extra`.
class ContextualLogger {
  /// Creates a [ContextualLogger].
  const ContextualLogger({
    required this.tag,
    required this.context,
    required this.transports,
    required this.minLevel,
    required this.redactPii,
    required this.includeTimestamp,
    required this.includeStackTrace,
  });

  /// Optional tag / channel name.
  final String? tag;

  /// The context attached to this logger.
  final LogContext context;

  /// Transports to write to (shared with the parent Logger).
  final List<LogTransportInterface> transports;

  /// Minimum log level.
  final LogLevel minLevel;

  /// Whether to redact PII from messages.
  final bool redactPii;

  /// Whether to include timestamps.
  final bool includeTimestamp;

  /// Whether to include stack traces.
  final bool includeStackTrace;

  // ── Context manipulation ──────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | withContext
  |--------------------------------------------------------------------------
  |
  | Returns a new ContextualLogger with [additional] merged into the
  | existing context. The original logger is not modified.
  |
  */

  /// Returns a new logger with [additional] merged into the context.
  ContextualLogger withContext(Map<String, dynamic> additional) =>
      ContextualLogger(
        tag:                tag,
        context:            context.merge(additional),
        transports:         transports,
        minLevel:           minLevel,
        redactPii:          redactPii,
        includeTimestamp:   includeTimestamp,
        includeStackTrace:  includeStackTrace,
      );

  /*
  |--------------------------------------------------------------------------
  | withoutContext
  |--------------------------------------------------------------------------
  |
  | Returns a new ContextualLogger with the context cleared.
  |
  */

  /// Returns a new logger with the context cleared.
  ContextualLogger withoutContext() => ContextualLogger(
    tag:                tag,
    context:            LogContext.empty,
    transports:         transports,
    minLevel:           minLevel,
    redactPii:          redactPii,
    includeTimestamp:   includeTimestamp,
    includeStackTrace:  includeStackTrace,
  );

  /*
  |--------------------------------------------------------------------------
  | withTag
  |--------------------------------------------------------------------------
  |
  | Returns a new ContextualLogger with a different tag.
  |
  */

  /// Returns a new logger with [newTag] replacing the current tag.
  ContextualLogger withTag(String newTag) => ContextualLogger(
    tag:                newTag,
    context:            context,
    transports:         transports,
    minLevel:           minLevel,
    redactPii:          redactPii,
    includeTimestamp:   includeTimestamp,
    includeStackTrace:  includeStackTrace,
  );

  // ── Logging methods ───────────────────────────────────────────────────────

  /// Logs a verbose message.
  void verbose(String message, {Map<String, dynamic> extra = const {}}) =>
      _log(LogLevel.verbose, message, extra: extra);

  /// Logs a debug message.
  void debug(String message, {Map<String, dynamic> extra = const {}}) =>
      _log(LogLevel.debug, message, extra: extra);

  /// Logs an informational message.
  void info(String message, {Map<String, dynamic> extra = const {}}) =>
      _log(LogLevel.info, message, extra: extra);

  /// Logs a warning message.
  void warning(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic> extra = const {}}) =>
      _log(LogLevel.warning, message, error: error, stackTrace: stackTrace, extra: extra);

  /// Logs an error message.
  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic> extra = const {}}) =>
      _log(LogLevel.error, message, error: error, stackTrace: stackTrace, extra: extra);

  /// Logs a fatal message.
  void fatal(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic> extra = const {}}) =>
      _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace, extra: extra);

  // ── Internal ──────────────────────────────────────────────────────────────

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> extra = const {},
  }) {
    if (!level.isAtLeast(minLevel)) return;
    if (transports.isEmpty) return;

    final safeMessage = redactPii ? PiiRedactor.redact(message) : message;

    // Merge context + call-site extra (call-site wins on key conflict).
    final mergedExtra = {...context.data, ...extra};

    final entry = LogEntry(
      level:      level,
      message:    safeMessage,
      timestamp:  includeTimestamp ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(0),
      tag:        tag,
      error:      error,
      stackTrace: includeStackTrace ? stackTrace : null,
      extra:      mergedExtra,
    );

    for (final transport in transports) {
      if (entry.level.isAtLeast(transport.minLevel)) {
        transport.write(entry);
      }
    }
  }
}
