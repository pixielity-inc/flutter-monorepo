// ignore_for_file: lines_longer_than_80_chars

/// A real-time event received from the live provider.
class LiveEvent {
  /// Creates a [LiveEvent].
  const LiveEvent({
    required this.channel,
    required this.type,
    required this.date,
    this.payload = const {},
    this.meta = const {},
  });

  /// The channel this event was published on (e.g. 'resources/posts').
  final String channel;

  /// Event type: 'created', 'updated', 'deleted', or '*'.
  final String type;

  /// When the event occurred.
  final DateTime date;

  /// Event payload (e.g. `{'ids': [1, 2]}`).
  final Map<String, dynamic> payload;

  /// Extra metadata.
  final Map<String, dynamic> meta;
}

/// Subscription options passed to [LiveProvider.subscribe].
class LiveSubscribeOptions {
  /// Creates a [LiveSubscribeOptions].
  const LiveSubscribeOptions({
    required this.channel,
    required this.types,
    required this.callback,
    this.params = const {},
    this.meta = const {},
  });

  /// Channel to subscribe to (e.g. 'resources/posts').
  final String channel;

  /// Event types to listen for (e.g. ['created', 'updated'] or ['*']).
  final List<String> types;

  /// Callback invoked when a matching event is received.
  final void Function(LiveEvent event) callback;

  /// Extra params (e.g. filters, pagination).
  final Map<String, dynamic> params;

  /// Extra metadata.
  final Map<String, dynamic> meta;
}

/// Abstract live provider — mirrors refine.dev's `LiveProvider`.
///
/// Implement this to add real-time updates via WebSocket, SSE,
/// Supabase Realtime, Ably, Pusher, etc.
///
/// ```dart
/// class WebSocketLiveProvider extends LiveProvider {
///   final WebSocketChannel _channel;
///
///   @override
///   dynamic subscribe(LiveSubscribeOptions options) {
///     _channel.stream.listen((msg) {
///       final event = LiveEvent.fromJson(jsonDecode(msg));
///       if (options.types.contains('*') ||
///           options.types.contains(event.type)) {
///         options.callback(event);
///       }
///     });
///     return _channel;
///   }
///
///   @override
///   void unsubscribe(dynamic subscription) {
///     (subscription as WebSocketChannel).sink.close();
///   }
/// }
/// ```
abstract class LiveProvider {
  /// Subscribe to real-time events. Returns a subscription handle
  /// that can be passed to [unsubscribe].
  dynamic subscribe(LiveSubscribeOptions options);

  /// Unsubscribe from a previous subscription.
  void unsubscribe(dynamic subscription);

  /// Publish an event. Optional — not all backends support client-side publish.
  Future<void> publish(LiveEvent event) async {}
}
