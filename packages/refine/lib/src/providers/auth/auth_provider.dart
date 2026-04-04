// ignore_for_file: lines_longer_than_80_chars

/// Response from an auth action (login, register, logout, etc.).
class AuthActionResponse {
  /// Creates an [AuthActionResponse].
  const AuthActionResponse({
    required this.success,
    this.redirectTo,
    this.error,
    this.extra = const {},
  });

  /// Whether the action succeeded.
  final bool success;

  /// Optional route to redirect to after the action.
  final String? redirectTo;

  /// Error if the action failed.
  final Object? error;

  /// Arbitrary extra data returned by the provider.
  final Map<String, dynamic> extra;
}

/// Response from [AuthProvider.check].
class CheckResponse {
  /// Creates a [CheckResponse].
  const CheckResponse({
    required this.authenticated,
    this.redirectTo,
    this.logout = false,
    this.error,
  });

  /// Whether the user is currently authenticated.
  final bool authenticated;

  /// Route to redirect to if not authenticated.
  final String? redirectTo;

  /// Whether to trigger a logout.
  final bool logout;

  /// Error if the check failed.
  final Object? error;
}

/// Response from [AuthProvider.onError].
class OnErrorResponse {
  /// Creates an [OnErrorResponse].
  const OnErrorResponse({this.redirectTo, this.logout = false, this.error});

  /// Route to redirect to.
  final String? redirectTo;

  /// Whether to trigger a logout.
  final bool logout;

  /// The original error.
  final Object? error;
}

/// Abstract auth provider — mirrors refine.dev's `AuthProvider`.
///
/// Implement this to wire up your authentication backend (JWT, OAuth2,
/// Firebase Auth, Supabase, etc.).
///
/// ```dart
/// class MyAuthProvider extends AuthProvider {
///   @override
///   Future<AuthActionResponse> login(Map<String, dynamic> params) async {
///     final token = await api.login(params['email'], params['password']);
///     await storage.write('token', token);
///     return AuthActionResponse(success: true, redirectTo: '/');
///   }
///   // ...
/// }
/// ```
abstract class AuthProvider {
  /// Log the user in.
  Future<AuthActionResponse> login(Map<String, dynamic> params);

  /// Log the user out.
  Future<AuthActionResponse> logout([Map<String, dynamic>? params]);

  /// Check if the user is authenticated.
  Future<CheckResponse> check([Map<String, dynamic>? params]);

  /// Handle an auth error (e.g. 401 from API).
  Future<OnErrorResponse> onError(Object error);

  /// Register a new user. Optional.
  Future<AuthActionResponse> register(Map<String, dynamic> params) async =>
      const AuthActionResponse(success: false, error: 'Not implemented');

  /// Send a forgot-password email. Optional.
  Future<AuthActionResponse> forgotPassword(
    Map<String, dynamic> params,
  ) async =>
      const AuthActionResponse(success: false, error: 'Not implemented');

  /// Update the user's password. Optional.
  Future<AuthActionResponse> updatePassword(
    Map<String, dynamic> params,
  ) async =>
      const AuthActionResponse(success: false, error: 'Not implemented');

  /// Return the current user's identity (profile). Optional.
  Future<dynamic> getIdentity([Map<String, dynamic>? params]) async => null;

  /// Return the current user's permissions. Optional.
  Future<dynamic> getPermissions([Map<String, dynamic>? params]) async => null;
}
