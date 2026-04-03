// ignore_for_file: lines_longer_than_80_chars

import 'package:pixielity_example_app/features/items/data/fake_example_repository.dart';
import 'package:pixielity_core/pixielity_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the [ExampleRepository] implementation used across the items
/// feature.
///
/// Swap [FakeExampleRepository] for a real implementation here without
/// touching any UI code.
final exampleRepositoryProvider = Provider<ExampleRepository>(
  (ref) => const FakeExampleRepository(),
);

/// Provides the [GetExampleItems] use case, injected with the repository.
final getExampleItemsUseCaseProvider = Provider<GetExampleItems>(
  (ref) => GetExampleItems(repository: ref.watch(exampleRepositoryProvider)),
);

/// Async provider that executes [GetExampleItems] and exposes the result.
///
/// Consumers use [AsyncValue] to handle loading, error, and data states
/// declaratively in the UI.
///
/// Example:
/// ```dart
/// final itemsAsync = ref.watch(itemsProvider);
/// itemsAsync.when(
///   data: (items) => ListView(...),
///   loading: () => CircularProgressIndicator(),
///   error: (e, _) => Text('Error: $e'),
/// );
/// ```
final itemsProvider = FutureProvider<List<ExampleItem>>(
  (ref) => ref.watch(getExampleItemsUseCaseProvider).execute(),
);
