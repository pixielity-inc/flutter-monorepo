import 'package:pixielity_core/pixielity_core.dart';

/// An in-memory [ExampleRepository] that returns hard-coded items.
///
/// This is the Data Layer implementation used by the example app.
/// In a real app this would be replaced by a concrete implementation
/// that calls a REST API, local database, or other data source.
final class FakeExampleRepository implements ExampleRepository {
  /// Creates a [FakeExampleRepository].
  ///
  /// Optionally provide [items] to override the default seed data.
  const FakeExampleRepository({List<ExampleItem>? items}) : _items = items;

  /// The backing list of items. Falls back to [_defaultItems] when null.
  final List<ExampleItem>? _items;

  /// Default seed data returned when no custom [items] are provided.
  static const List<ExampleItem> _defaultItems = [
    ExampleItem(
      id: '1',
      title: 'Clean Architecture',
      description: 'Domain layer depends on nothing.',
    ),
    ExampleItem(
      id: '2',
      title: 'Melos Monorepo',
      description: 'Orchestrates packages across the workspace.',
    ),
    ExampleItem(
      id: '3',
      title: 'Riverpod',
      description: 'Compile-safe, testable state management.',
    ),
  ];

  @override
  Future<List<ExampleItem>> getAll() async {
    // Simulate a short async delay to mimic a real data source.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _items ?? _defaultItems;
  }

  @override
  Future<ExampleItem?> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final all = _items ?? _defaultItems;
    return all.where((item) => item.id == id).firstOrNull;
  }
}
