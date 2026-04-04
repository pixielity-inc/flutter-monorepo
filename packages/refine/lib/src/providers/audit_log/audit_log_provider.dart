// ignore_for_file: lines_longer_than_80_chars

/// Parameters for creating an audit log entry.
class AuditLogCreateParams {
  /// Creates an [AuditLogCreateParams].
  const AuditLogCreateParams({
    required this.resource,
    required this.action,
    this.data,
    this.previousData,
    this.author,
    this.meta = const {},
  });

  /// Resource name (e.g. 'posts').
  final String resource;

  /// Action performed (e.g. 'create', 'update', 'delete').
  final String action;

  /// The new data (after mutation).
  final dynamic data;

  /// The previous data (before mutation). Relevant for updates.
  final dynamic previousData;

  /// The user who performed the action.
  final Map<String, dynamic>? author;

  /// Extra metadata.
  final Map<String, dynamic> meta;
}

/// Parameters for querying audit log entries.
class AuditLogGetParams {
  /// Creates an [AuditLogGetParams].
  const AuditLogGetParams({
    required this.resource,
    this.action,
    this.author,
    this.meta = const {},
  });

  /// Resource name to filter by.
  final String resource;

  /// Optional action to filter by.
  final String? action;

  /// Optional author to filter by.
  final Map<String, dynamic>? author;

  /// Extra metadata.
  final Map<String, dynamic> meta;
}

/// A single audit log entry.
class AuditLogEntry {
  /// Creates an [AuditLogEntry].
  const AuditLogEntry({
    required this.id,
    required this.resource,
    required this.action,
    required this.createdAt,
    this.data,
    this.previousData,
    this.author,
    this.meta = const {},
  });

  /// Entry ID.
  final dynamic id;

  /// Resource name.
  final String resource;

  /// Action performed.
  final String action;

  /// When the action occurred.
  final DateTime createdAt;

  /// The data after the action.
  final dynamic data;

  /// The data before the action.
  final dynamic previousData;

  /// The user who performed the action.
  final Map<String, dynamic>? author;

  /// Extra metadata.
  final Map<String, dynamic> meta;
}

/// Abstract audit log provider — mirrors refine.dev's `AuditLogProvider`.
///
/// Implement this to record and query mutation history for compliance,
/// debugging, or undo functionality.
///
/// ```dart
/// class ApiAuditLogProvider extends AuditLogProvider {
///   final ApiClient _client;
///   ApiAuditLogProvider(this._client);
///
///   @override
///   Future<void> create(AuditLogCreateParams params) async {
///     await _client.post('/audit-logs', {
///       'resource': params.resource,
///       'action': params.action,
///       'data': params.data,
///     });
///   }
///   // ...
/// }
/// ```
abstract class AuditLogProvider {
  /// Create an audit log entry.
  Future<void> create(AuditLogCreateParams params);

  /// Query audit log entries.
  Future<List<AuditLogEntry>> get(AuditLogGetParams params);

  /// Update an audit log entry (e.g. rename).
  Future<void> update({
    required dynamic id,
    required String name,
    Map<String, dynamic> extra = const {},
  });
}
