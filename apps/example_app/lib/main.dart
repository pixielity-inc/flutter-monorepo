import 'package:pixielity_example_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bootstrap the Flutter application.
///
/// [ProviderScope] must wrap the entire widget tree so that Riverpod
/// providers can be read from any descendant widget.
void main() {
  runApp(const ProviderScope(child: ExampleApp()));
}
