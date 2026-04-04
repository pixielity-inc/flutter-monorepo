// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';
import 'fake_auth_provider.dart';

/// Riverpod provider for the auth notifier using [FakeAuthProvider].
final fakeAuthProvider = FakeAuthProvider();

/// The auth notifier provider wired to [fakeAuthProvider].
final authNotifier = authNotifierProvider(fakeAuthProvider);

/// Login page using ForeUI components.
class LoginPage extends ConsumerStatefulWidget {
  /// Creates a [LoginPage].
  const LoginPage({super.key, required this.onLoginSuccess});

  /// Called when login succeeds.
  final VoidCallback onLoginSuccess;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'demo@refine.dev');
  final _passwordController = TextEditingController(text: 'demodemo');
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    final result = await ref.read(authNotifier.notifier).login({
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    });
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      widget.onLoginSuccess();
    } else {
      setState(() => _error = result.error?.toString() ?? 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return FScaffold(
      header: FHeader(title: const Text('Refine Demo')),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: FCard(
              title: const Text('Sign In'),
              subtitle: const Text('Enter your credentials to continue'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_error != null) ...[
                    FAlert(
                      icon: const Icon(FIcons.circleAlert),
                      title: Text(_error!),
                      variant: .destructive,
                    ),
                    const SizedBox(height: 16),
                  ],
                  FTextField.email(
                    control: FTextFieldControl.managed(
                      initial: TextEditingValue(
                        text: _emailController.text,
                      ),
                    ),
                    hint: 'Email',
                    label: const Text('Email'),
                    onSubmit: (v) => _emailController.text = v,
                  ),
                  const SizedBox(height: 12),
                  FTextField.password(
                    control: FTextFieldControl.managed(
                      initial: TextEditingValue(
                        text: _passwordController.text,
                      ),
                    ),
                    hint: 'Password',
                    label: const Text('Password'),
                    onSubmit: (v) => _passwordController.text = v,
                  ),
                  const SizedBox(height: 20),
                  FButton(
                    onPress: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: FCircularProgress(),
                          )
                        : const Text('Sign In'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'demo@refine.dev / demodemo',
                    textAlign: TextAlign.center,
                    style: theme.typography.xs.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
