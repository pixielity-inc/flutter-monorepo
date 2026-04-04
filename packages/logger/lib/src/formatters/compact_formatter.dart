// lib/src/formatters/compact_formatter.dart
//
// CompactFormatter — single-line format without ANSI colours.
//
// Example output:
//   14:22:01 I [Auth] User logged in
//   14:22:05 E [Api] Request failed | SocketException: Connection refused

import 'package:logger/src/interfaces/log_formatter_interface.dart';
import 'package:logger/src/log_entry.dart';

/// Single-line compact formatter without ANSI colours.
///
/// Suitable for staging environments and log files where colour codes
/// would appear as raw escape sequences.
///
/// ```dart
/// Logger.setFormatter(CompactFormatter());
/// ```
class CompactFormatter implements LogFormatterInterface {
  /// Creates a [CompactFormatter].
  const CompactFormatter({this.includeTimestamp = true});

  /// Whether to include the short timestamp (HH:mm:ss).
  final bool includeTimestamp;

  @override
  String format(LogEntry entry) {
    final time  = includeTimestamp ? '${_formatTime(entry.timestamp)} ' : '';
    final level = entry.level.label;
    final tag   = entry.tag != null ? ' [${entry.tag}]' : '';
    final err   = entry.error != null ? ' | ${entry.error}' : '';
    final extra = entry.extra.isNotEmpty ? ' | ${entry.extra}' : '';
    return '$time$level$tag ${entry.message}$err$extra';
  }

  String _formatTime(DateTime dt) {
    final h  = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final s  = dt.second.toString().padLeft(2, '0');
    return '$h:$mi:$s';
  }
}
