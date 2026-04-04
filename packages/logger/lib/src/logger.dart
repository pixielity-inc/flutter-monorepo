// ignore_for_file: lines_longer_than_80_chars
// lib/src/logger.dart
//
// Logger — the central logging class.
//
// Reads configuration from Config.get('logging.*') and routes log entries
// to all registered transports after level filtering and PII redaction.
//
// Supports Laravel-style context:
//   Logger('Auth').withContext({'userId': '42'}).info('Logged in')
//   Logger('Auth').withoutContext().info('No context')
//   Logger('Auth').withTag('OAuth').info('Token refreshed')

import 'package:config/pixielity_config.dart';
import 'package:logger/src/context/log_context.dart';
import 'package:logger/src/enums/log_level.dart';
import 'package:logger/src/interfaces/log_transport_interface.dart';
import 'package:logger/src/log_entry.dart';
import 'package:logger/src/pii_redactor.dart';

/// The central logging class.
///
/// Create a tagged instance per feature/layer:
/// ```dart
/// final _log = Logger('Auth');
/// _log.info('User logged in');
/// _log.error('Login failed', error: e, stackTrace: st);
/// ```
///
/// Attach context (merged into every entry's `extra`):
/// ```dart
/// final _log = Logger('Api')
///     .withContext({'requestId': id, 'userId': userId});
/// _log.info('Request received');   // extra includes requestId + userId
/// _log.error('Handler failed', error: e);
/// ```
///
/// Use the global [Log] facade for quick logging:
/// ```dart
/// Log.info('App started');
/// Log.warning('Low memory');
/// ```
class Logger {
  /// Creates a [Logger] with an optional [tag].
  Logger([this.tag]);

  /// Optional tag / channel name for this logger instance.
  final String? tag;

  // ── Static configuration ──────────────────────────────────────────────────

  static final List<LogTransportInterface> _transports = [];
  static LogLevel _minLevel          = LogLevel.info;
  static bool _redactPii             = true;
  static bool _includeTimestamp      = true;
  static bool _includeStackTrace     = false;

  /*
  |--------------------------------------------------------------------------
  | configure
  |--------------------------------------------------------------------------
  |
  | Reads logging.* config values and applies them.
  | Called by LoggerServiceProvider.boot() after Config.load().
  |
  */

  /// Configures the logger from the loaded Config registry.
  static void configure() {
    _minLevel = LogLevel.fromString(
      Config.get<String>('logging.level', fallback: 'info'),
    );
    _redactPii         = Config.get<bool>('logging.redactPii',         fallback: true);
    _includeTimestamp  = Config.get<bool>('logging.includeTimestamp',  fallback: true);
    _includeStackTrace = Config.get<bool>('logging.includeStackTrace', fallback: false);
  }

  /*
  |--------------------------------------------------------------------------
  | addTransport / clearTransports
  |--------------------------------------------------------------------------
  */

  /// Registers a [LogTransportInterface].
  static void addTransport(LogTransportInterface transport) =>
      _transports.add(transport);

  /// Removes all registered transports.
  static void clearTransports() => _transports.clear();

  /// Returns `true` if [level] should be emitted.
  static bool shouldLog(LogLevel level) => level.isAtLeast(_minLevel);

  // ── Context / tag builders ────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | withContext
  |--------------------------------------------------------------------------
  |
  | Returns a ContextualLogger with [context] merged into every entry.
  | Mirrors Laravel's Logger::withContext().
  |
  */

  /// Returns a [ContextualLogger] with [context] attached.
  ///
  /// ```dart
  /// final log = Logger('Auth').withContext({'userId': '42'});
  /// log.info('Logged in');  // extra = {'userId': '42'}
  /// ```
  ContextualLogger withContext(Map<String, dynamic> context) =>
      ContextualLogger(
        tag:               tag,
        context:           LogContext(context),
        transports:        _transports,
        minLevel:          _minLevel,
        redactPii:         _redactPii,
        includeTimestamp:  _includeTimestamp,
        includeStackTrace: _includeStackTrace,
      );

  /*
  |--------------------------------------------------------------------------
  | withoutContext
  |--------------------------------------------------------------------------
  |
  | Returns a ContextualLogger with an empty context.
  |
  */

  /// Returns a [ContextualLogger] with no context.
  ContextualLogger withoutContext() => ContextualLogger(
    tag:               tag,
    context:           LogContext.empty,
    transports:        _transports,
    minLevel:          _minLevel,
    redactPii:         _redactPii,
    includeTimestamp:  _includeTimestamp,
    includeStackTrace: _includeStackTrace,
  );

  /*
  |--------------------------------------------------------------------------
  | withTag
  |--------------------------------------------------------------------------
  |
  | Returns a ContextualLogger with a different tag.
  |
  */

  /// Returns a [ContextualLogger] with [newTag].
  ContextualLogger withTag(String newTag) => ContextualLogger(
    tag:               newTag,
    context:           LogContext.empty,
    transports:        _transports,
    minLevel:          _minLevel,
    redactPii:         _redactPii,
    includeTimestamp:  _includeTimestamp,
    includeStackTrace: _includeStackTrace,
  );

  // ── Instance logging methods ──────────────────────────────────────────────

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

  // ── Core dispatch ─────────────────────────────────────────────────────────

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic> extra = const {},
  }) {
    if (!shouldLog(level)) return;
    if (_transports.isEmpty) return;

    final safeMessage = _redactPii ? PiiRedactor.redact(message) : message;

    final entry = LogEntry(
      level:      level,
      message:    safeMessage,
      timestamp:  _includeTimestamp ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(0),
      tag:        tag,
      error:      error,
      stackTrace: _includeStackTrace ? stackTrace : null,
      extra:      extra,
    );

    for (final transport in _transports) {
      if (entry.level.isAtLeast(transport.minLevel)) {
        transport.write(entry);
      }
    }
  }

  // ── Flush / close ─────────────────────────────────────────────────────────

  /// Flushes all transports (call on app background/shutdown).
  static Future<void> flush() async {
    for (final t in _transports) { await t.flush(); }
  }

  /// Closes all transports and releases resources.
  static Future<void> close() async {
    for (final t in _transports) { await t.close(); }
    _transports.clear();
  }
}

// ── Global facade ─────────────────────────────────────────────────────────────

/// Global logger facade — quick access without creating an instance.
///
/// ```dart
/// Log.info('App started');
/// Log.error('Unhandled exception', error: e, stackTrace: st);
/// Log.withContext({'requestId': id}).info('Request received');
/// ```
// ignore: non_constant_identifier_names
final Log = Logger();
