import 'package:pixielity_example_app/features/items/presentation/item_list_screen.dart';
import 'package:flutter/material.dart';

/// The root [MaterialApp] widget for the example application.
///
/// Responsibilities:
/// - Configure the global [ThemeData]
/// - Set the home screen ([ItemListScreen])
class ExampleApp extends StatelessWidget {
  /// Creates the [ExampleApp] root widget.
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ItemListScreen(),
    );
  }
}
