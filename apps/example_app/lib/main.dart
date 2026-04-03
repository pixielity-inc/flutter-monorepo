import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pixielity_example_app/app.dart';

/// Entry point for the Pixielity example application.
///
/// Wraps the app in a [ProviderScope] for Riverpod state management.
void main() {
  runApp(const ProviderScope(child: Application()));
}
