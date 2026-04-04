// lib/src/log_entry.dart
//
// LogEntry — an immutable record of a single log event.
//
// Created by Logger and passed to every registered transport.
// Contains all metadata needed for formatting and filtering.

import 'package:flutter/foundation.dart';
import 'package:logger/src/enums/log_level.dart';

/// An immutable record of a single log event.
///
/// Created by [Logger] and passed to every registered [LogTransport].
/// Transports format and emit the entry according to their configuration.
@immutable
class LogEntry {
  /// Creates a [LogEntry].
  const LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.tag,
    this.error,
    this.stackTrace,
    this.extra = const {},
  });

  /// The severity level of this entry.
  final LogLevel level;

  /// The human-readable log message.
  final String message;

  /// When this entry was created.
  final DateTime timestamp;

  /// Optional tag / channel name (e.g. 'Auth', 'Api', 'Storage').
  final String? tag;

  /// Optional error object associated with this entry.
  final Object? error;

  /// Optional stack trace associated with [error].
  final StackTrace? stackTrace;

  /// Optional structured key/value metadata.
  final Map<String, dynamic> extra;

  /// Returns a copy of this entry with [message] replaced.
  LogEntry withMessage(String message) => LogEntry(
    level:      level,
    message:    message,
    timestamp:  timestamp,
    tag:        tag,
    error:      error,
    stackTrace: stackTrace,
    extra:      extra,
  );

  /// Converts this entry to a JSON-serialisable map.
  Map<String, dynamic> toJson() => {
    'level':     level.name,
    'message':   message,
    'timestamp': timestamp.toIso8601String(),
    if (tag != null)        'tag':        tag,
    if (error != null)      'error':      error.toString(),
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    if (extra.isNotEmpty)   'extra':      extra,
  };

  @override
  String toString() => '[${level.name.toUpperCase()}] $message';
}
