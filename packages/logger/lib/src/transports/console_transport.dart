// lib/src/transports/console_transport.dart
//
// ConsoleTransport — writes log entries to the Flutter debug console.
//
// Uses debugPrint() which is safe on all platforms and respects Flutter's
// output throttling. Accepts any LogFormatterInterface implementation.

import 'package:flutter/foundation.dart';
import 'package:logger/src/enums/log_level.dart';
import 'package:logger/src/formatters/pretty_formatter.dart';
import 'package:logger/src/interfaces/log_formatter_interface.dart';
import 'package:logger/src/interfaces/log_transport_interface.dart';
import 'package:logger/src/log_entry.dart';

/// Writes log entries to the Flutter debug console via [debugPrint].
///
/// Accepts any [LogFormatterInterface] — defaults to [PrettyFormatter].
///
/// ```dart
/// // Default pretty format
/// ConsoleTransport()
///
/// // Compact format
/// ConsoleTransport(formatter: CompactFormatter())
///
/// // JSON format
/// ConsoleTransport(formatter: JsonFormatter())
/// ```
class ConsoleTransport implements LogTransportInterface {
  /// Creates a [ConsoleTransport].
  ConsoleTransport({
    LogFormatterInterface? formatter,
    LogLevel minLevel = LogLevel.verbose,
  })  : _formatter = formatter ?? const PrettyFormatter(),
        _minLevel  = minLevel;

  final LogFormatterInterface _formatter;
  final LogLevel _minLevel;

  @override
  LogLevel get minLevel => _minLevel;

  @override
  Future<void> write(LogEntry entry) async {
    if (!entry.level.isAtLeast(_minLevel)) return;
    debugPrint(_formatter.format(entry));
  }

  @override
  Future<void> flush() async {}  // unbuffered — nothing to flush

  @override
  Future<void> close() async {}  // no resources to release
}
