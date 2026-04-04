// lib/src/formatters/json_formatter.dart
//
// JsonFormatter — structured JSON output for log aggregation services.
//
// Example output (single line):
//   {"level":"info","message":"User logged in","timestamp":"2026-04-03T14:22:01.123Z","tag":"Auth"}

import 'dart:convert';

import 'package:logger/src/interfaces/log_formatter_interface.dart';
import 'package:logger/src/log_entry.dart';

/// Structured JSON formatter for log aggregation services.
///
/// Outputs a single JSON object per log entry. Compatible with Datadog,
/// Loki, Logtail, and any service that accepts newline-delimited JSON.
///
/// ```dart
/// Logger.setFormatter(JsonFormatter());
/// ```
class JsonFormatter implements LogFormatterInterface {
  /// Creates a [JsonFormatter].
  const JsonFormatter({this.prettyPrint = false});

  /// Whether to pretty-print the JSON (adds indentation).
  ///
  /// Set to `false` (default) for production — one entry per line.
  /// Set to `true` for debugging the JSON output itself.
  final bool prettyPrint;

  @override
  String format(LogEntry entry) {
    final map = entry.toJson();
    if (prettyPrint) {
      return const JsonEncoder.withIndent('  ').convert(map);
    }
    return jsonEncode(map);
  }
}
