// ignore_for_file: lines_longer_than_80_chars, prefer_const_constructors

import 'package:example_package/example_package.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fake repository implementation
// ---------------------------------------------------------------------------

/// A fake [ExampleRepository] that returns a fixed list of items.
///
/// Used exclusively in tests to isolate [GetExampleItems] from real data
/// sources.
final class _FakeExampleRepository implements ExampleRepository {
  /// Creates a [_FakeExampleRepository] with the given [items].
  const _FakeExampleRepository({required this.items});

  /// The fixed list of items returned by [getAll].
  final List<ExampleItem> items;

  @override
  Future<List<ExampleItem>> getAll() async => items;

  @override
  Future<ExampleItem?> getById(String id) async =>
      items.where((item) => item.id == id).firstOrNull;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('GetExampleItems', () {
    test('returns all items from the repository', () async {
      final tItems = [
        const ExampleItem(id: '1', title: 'First', description: 'First item'),
        const ExampleItem(id: '2', title: 'Second'),
      ];

      final useCase = GetExampleItems(
        repository: _FakeExampleRepository(items: tItems),
      );

      final result = await useCase.execute();

      expect(result, equals(tItems));
      expect(result.length, 2);
    });

    test('returns an empty list when the repository has no items', () async {
      final useCase = GetExampleItems(
        repository: const _FakeExampleRepository(items: []),
      );

      final result = await useCase.execute();

      expect(result, isEmpty);
    });
    test('ExampleItem.copyWith preserves unchanged fields', () {
      const original = ExampleItem(
        id: '42',
        title: 'Original',
        description: 'Desc',
      );

      final updated = original.copyWith(title: 'Updated');

      expect(updated.id, '42');
      expect(updated.title, 'Updated');
      expect(updated.description, 'Desc');
    });

    test('ExampleItem equality is value-based', () {
      const a = ExampleItem(id: '1', title: 'Hello');
      const b = ExampleItem(id: '1', title: 'Hello');

      expect(a, equals(b));
    });
  });
}
