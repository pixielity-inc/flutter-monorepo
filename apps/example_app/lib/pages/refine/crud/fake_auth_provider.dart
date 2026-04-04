// ignore_for_file: lines_longer_than_80_chars

import 'package:pixielity_refine/pixielity_refine.dart';

/// In-memory fake auth provider for the demo app.
///
/// Accepts email `demo@refine.dev` with password `demodemo`.
class FakeAuthProvider extends AuthProvider {
  bool _loggedIn = false;

  @override
  Future<AuthActionResponse> login(Map<String, dynamic> params) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final email = params['email'] as String?;
    final password = params['password'] as String?;
    if (email == 'demo@refine.dev' && password == 'demodemo') {
      _loggedIn = true;
      return const AuthActionResponse(success: true, redirectTo: '/');
    }
    return const AuthActionResponse(
      success: false,
      error: 'Invalid email or password',
    );
  }

  @override
  Future<AuthActionResponse> logout([Map<String, dynamic>? params]) async {
    _loggedIn = false;
    return const AuthActionResponse(success: true, redirectTo: '/login');
  }

  @override
  Future<CheckResponse> check([Map<String, dynamic>? params]) async {
    return CheckResponse(
      authenticated: _loggedIn,
      redirectTo: _loggedIn ? null : '/login',
    );
  }

  @override
  Future<OnErrorResponse> onError(Object error) async {
    return const OnErrorResponse(logout: true);
  }

  @override
  Future<dynamic> getIdentity([Map<String, dynamic>? params]) async {
    if (!_loggedIn) return null;
    return <String, String>{
      'name': 'Jane Doe',
      'email': 'demo@refine.dev',
      'avatar': 'JD',
    };
  }
}
