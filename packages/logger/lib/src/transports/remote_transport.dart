// ignore_for_file: lines_longer_than_80_chars
// lib/src/transports/remote_transport.dart
//
// RemoteTransport — batches log entries and sends them to an HTTP endpoint.
//
// Entries are queued and flushed when batchSize is reached or flushInterval
// elapses. Uses JsonFormatter by default since remote services expect JSON.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/src/enums/log_level.dart';
import 'package:logger/src/formatters/json_formatter.dart';
import 'package:logger/src/interfaces/log_formatter_interface.dart';
import 'package:logger/src/interfaces/log_transport_interface.dart';
import 'package:logger/src/log_entry.dart';

/// Batches log entries and sends them to a remote HTTP endpoint.
///
/// Entries are queued and flushed when [batchSize] is reached or
/// [flushInterval] elapses. Defaults to [JsonFormatter].
///
/// ```dart
/// RemoteTransport(
///   endpoint: 'https://logs.pixielity.com/ingest',
///   apiKey: 'my-api-key',
///   minLevel: LogLevel.warning,
/// )
/// ```
class RemoteTransport implements LogTransportInterface {
  /// Creates a [RemoteTransport].
  RemoteTransport({
    required this.endpoint,
    this.apiKey,
    LogFormatterInterface? formatter,
    LogLevel minLevel = LogLevel.warning,
    this.batchSize = 50,
    this.flushInterval = const Duration(seconds: 10),
  })  : _formatter = formatter ?? const JsonFormatter(),
        _minLevel  = minLevel {
    _startFlushTimer();
  }

  /// The HTTP endpoint to send log batches to.
  final String endpoint;

  /// Optional API key sent in the `X-Api-Key` header.
  final String? apiKey;

  /// Number of entries to accumulate before flushing.
  final int batchSize;

  /// How often to flush even if [batchSize] is not reached.
  final Duration flushInterval;

  final LogFormatterInterface _formatter;
  final LogLevel _minLevel;
  final List<LogEntry> _queue = [];
  Timer? _timer;

  @override
  LogLevel get minLevel => _minLevel;

  @override
  Future<void> write(LogEntry entry) async {
    if (!entry.level.isAtLeast(_minLevel)) return;
    _queue.add(entry);
    if (_queue.length >= batchSize) await flush();
  }

  @override
  Future<void> flush() async {
    if (_queue.isEmpty) return;
    final batch = List<LogEntry>.from(_queue);
    _queue.clear();
    await _send(batch);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await flush();
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _startFlushTimer() {
    _timer = Timer.periodic(flushInterval, (_) => flush());
  }

  Future<void> _send(List<LogEntry> batch) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (apiKey != null && apiKey!.isNotEmpty) 'X-Api-Key': apiKey!,
      };
      // Format each entry using the configured formatter, then wrap in array.
      final formatted = batch.map((e) => _formatter.format(e)).toList();
      final body = jsonEncode(formatted);
      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: body,
      );
      if (response.statusCode >= 400) {
        debugPrint('[RemoteTransport] Failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('[RemoteTransport] Error: $e');
    }
  }
}
