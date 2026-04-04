// ignore_for_file: lines_longer_than_80_chars

/// Response from [AccessControlProvider.can].
class CanResponse {
  /// Creates a [CanResponse].
  const CanResponse({required this.can, this.reason});

  /// Whether the action is allowed.
  final bool can;

  /// Human-readable reason if denied.
  final String? reason;
}

/// Parameters for [AccessControlProvider.can].
class CanParams {
  /// Creates a [CanParams].
  const CanParams({
    required this.action,
    this.resource,
    this.params = const {},
  });

  /// The intended action (e.g. 'create', 'edit', 'delete', 'list', 'show').
  final String action;

  /// The resource name (e.g. 'posts', 'users').
  final String? resource;

  /// Extra parameters (e.g. record id, field name).
  final Map<String, dynamic> params;
}

/// Abstract access control provider — mirrors refine.dev's
/// `AccessControlProvider` and Laravel's Policy pattern.
///
/// Implement this to enforce RBAC, ABAC, or any permission model.
///
/// ```dart
/// class MyAccessControl extends AccessControlProvider {
///   @override
///   Future<CanResponse> can(CanParams params) async {
///     final role = await getCurrentUserRole();
///     if (params.action == 'delete' && role != 'admin') {
///       return CanResponse(can: false, reason: 'Only admins can delete');
///     }
///     return CanResponse(can: true);
///   }
/// }
/// ```
abstract class AccessControlProvider {
  /// Check if the current user can perform [params.action] on
  /// [params.resource].
  Future<CanResponse> can(CanParams params);
}
