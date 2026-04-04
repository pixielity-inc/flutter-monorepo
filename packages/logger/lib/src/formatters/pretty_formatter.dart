// lib/src/formatters/pretty_formatter.dart
//
// PrettyFormatter — coloured, human-readable output for development consoles.
//
// Example output:
//   2026-04-03 14:22:01.123 [INFO   ] [Auth] User logged in
//   2026-04-03 14:22:05.456 [ERROR  ] [Api] Request failed
//     ↳ SocketException: Connection refused

import 'package:logger/src/enums/log_level.dart';
import 'package:logger/src/interfaces/log_formatter_interface.dart';
import 'package:logger/src/log_entry.dart';

/// Coloured, human-readable formatter for development consoles.
///
/// Uses ANSI escape codes to colour each level differently.
/// Includes timestamp, level, optional tag, message, error, and stack trace.
///
/// ```dart
/// Logger.setFormatter(PrettyFormatter());
/// ```
class PrettyFormatter implements LogFormatterInterface {
  /// Creates a [PrettyFormatter].
  const PrettyFormatter({
    this.includeTimestamp = true,
    this.includeStackTrace = false,
  });

  /// Whether to include the timestamp in each line.
  final bool includeTimestamp;

  /// Whether to include the stack trace for error-level entries.
  final bool includeStackTrace;

  @override
  String format(LogEntry entry) {
    final color  = entry.level.ansiColor;
    final reset  = LogLevel.ansiReset;
    final level  = entry.level.name.toUpperCase().padRight(7);
    final tag    = entry.tag != null ? ' [${entry.tag}]' : '';
    final time   = includeTimestamp ? '${_formatTime(entry.timestamp)} ' : '';
    final buffer = StringBuffer('$color$time[$level]$tag ${entry.message}$reset');

    if (entry.error != null) {
      buffer.write('\n$color  ↳ ${entry.error}$reset');
    }
    if (includeStackTrace && entry.stackTrace != null) {
      buffer.write('\n$color${entry.stackTrace}$reset');
    }
    if (entry.extra.isNotEmpty) {
      buffer.write('\n${color}  extra: ${entry.extra}$reset');
    }
    return buffer.toString();
  }

  String _formatTime(DateTime dt) {
    final y  = dt.year.toString().padLeft(4, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    final d  = dt.day.toString().padLeft(2, '0');
    final h  = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final s  = dt.second.toString().padLeft(2, '0');
    final ms = dt.millisecond.toString().padLeft(3, '0');
    return '$y-$mo-$d $h:$mi:$s.$ms';
  }
}
