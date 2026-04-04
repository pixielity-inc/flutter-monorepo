// ignore_for_file: lines_longer_than_80_chars

/// Parameters for opening a notification.
class OpenNotificationParams {
  /// Creates an [OpenNotificationParams].
  const OpenNotificationParams({
    required this.message,
    required this.type,
    this.key,
    this.description,
    this.undoableTimeout,
    this.cancelMutation,
  });

  /// Unique key for this notification (used for close/replace).
  final String? key;

  /// The notification message.
  final String message;

  /// Notification type: 'success', 'error', or 'progress'.
  final String type;

  /// Optional description shown below the message.
  final String? description;

  /// For undoable mutations — timeout in seconds.
  final int? undoableTimeout;

  /// For undoable mutations — callback to cancel the mutation.
  final void Function()? cancelMutation;
}

/// Abstract notification provider — mirrors refine.dev's
/// `NotificationProvider`.
///
/// Implement this to wire up your notification system (ForeUI toasts,
/// SnackBar, custom overlay, etc.).
///
/// ```dart
/// class ForuiNotificationProvider extends NotificationProvider {
///   final BuildContext context;
///   ForuiNotificationProvider(this.context);
///
///   @override
///   void open(OpenNotificationParams params) {
///     showFToast(
///       context: context,
///       variant: params.type == 'error' ? .destructive : .primary,
///       title: Text(params.message),
///       description: params.description != null
///           ? Text(params.description!) : null,
///     );
///   }
///
///   @override
///   void close(String key) {
///     // Dismiss toast by key if your system supports it.
///   }
/// }
/// ```
abstract class NotificationProvider {
  /// Show a notification.
  void open(OpenNotificationParams params);

  /// Close/dismiss a notification by [key].
  void close(String key);
}
