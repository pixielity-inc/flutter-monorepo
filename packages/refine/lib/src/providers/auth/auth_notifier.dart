// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

/// Auth state exposed to the UI via Riverpod.
class AuthState {
  /// Creates an [AuthState].
  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.identity,
    this.permissions,
    this.error,
  });

  /// Whether the user is authenticated.
  final bool isAuthenticated;

  /// Whether an auth action is in progress.
  final bool isLoading;

  /// The current user identity (profile).
  final dynamic identity;

  /// The current user permissions.
  final dynamic permissions;

  /// Last auth error.
  final Object? error;

  /// Copy with.
  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    dynamic identity,
    dynamic permissions,
    Object? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      identity: identity ?? this.identity,
      permissions: permissions ?? this.permissions,
      error: error,
    );
  }
}

/// Riverpod [Notifier] that wraps an [AuthProvider] and exposes
/// reactive auth state to the widget tree.
///
/// ```dart
/// final authNotifier = authNotifierProvider(myAuthProvider);
///
/// // In a widget:
/// final state = ref.watch(authNotifier);
/// if (state.isAuthenticated) { ... }
///
/// // Trigger login:
/// ref.read(authNotifier.notifier).login({'email': '...', 'password': '...'});
/// ```
class AuthNotifier extends AutoDisposeNotifier<AuthState> {
  /// Creates an [AuthNotifier].
  AuthNotifier(this._provider);

  final AuthProvider _provider;

  @override
  AuthState build() => const AuthState();

  /// Check current auth status and load identity + permissions.
  Future<CheckResponse> check() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _provider.check();
      if (response.authenticated) {
        final identity = await _provider.getIdentity();
        final permissions = await _provider.getPermissions();
        state = AuthState(
          isAuthenticated: true,
          identity: identity,
          permissions: permissions,
        );
      } else {
        state = const AuthState();
      }
      return response;
    } catch (e) {
      state = AuthState(error: e);
      return CheckResponse(authenticated: false, error: e);
    }
  }

  /// Log in.
  Future<AuthActionResponse> login(Map<String, dynamic> params) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _provider.login(params);
      if (response.success) {
        await check();
      } else {
        state = AuthState(error: response.error);
      }
      return response;
    } catch (e) {
      state = AuthState(error: e);
      return AuthActionResponse(success: false, error: e);
    }
  }

  /// Log out.
  Future<AuthActionResponse> logout([Map<String, dynamic>? params]) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _provider.logout(params);
      state = const AuthState();
      return response;
    } catch (e) {
      state = AuthState(error: e);
      return AuthActionResponse(success: false, error: e);
    }
  }

  /// Register.
  Future<AuthActionResponse> register(Map<String, dynamic> params) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _provider.register(params);
      if (response.success) await check();
      return response;
    } catch (e) {
      state = AuthState(error: e);
      return AuthActionResponse(success: false, error: e);
    }
  }

  /// Forgot password.
  Future<AuthActionResponse> forgotPassword(
    Map<String, dynamic> params,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      return await _provider.forgotPassword(params);
    } catch (e) {
      state = AuthState(error: e);
      return AuthActionResponse(success: false, error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Update password.
  Future<AuthActionResponse> updatePassword(
    Map<String, dynamic> params,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      return await _provider.updatePassword(params);
    } catch (e) {
      state = AuthState(error: e);
      return AuthActionResponse(success: false, error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

/// Creates a Riverpod [NotifierProvider] for auth state.
AutoDisposeNotifierProvider<AuthNotifier, AuthState> authNotifierProvider(
  AuthProvider provider,
) {
  return NotifierProvider.autoDispose<AuthNotifier, AuthState>(
    () => AuthNotifier(provider),
  );
}
