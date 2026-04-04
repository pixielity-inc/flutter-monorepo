// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_page.dart';
import 'refine_shell.dart';

/// Entry point for the full Refine demo app.
///
/// Checks auth state on init — shows [LoginPage] if not authenticated,
/// [RefineShell] if authenticated. Reactively switches via [authNotifier].
class RefineAppPage extends ConsumerStatefulWidget {
  /// Creates a [RefineAppPage].
  const RefineAppPage({super.key});

  @override
  ConsumerState<RefineAppPage> createState() => _RefineAppPageState();
}

class _RefineAppPageState extends ConsumerState<RefineAppPage> {
  @override
  void initState() {
    super.initState();
    // Check auth state on init.
    Future.microtask(() => ref.read(authNotifier.notifier).check());
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifier);

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.isAuthenticated) {
      return RefineShell(
        onLogout: () {
          // State change via authNotifier will rebuild this widget.
        },
      );
    }

    return LoginPage(
      onLoginSuccess: () {
        // State change via authNotifier will rebuild this widget.
      },
    );
  }
}
