import 'package:example_app/features/items/providers/items_provider.dart';
import 'package:example_package/example_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A screen that displays all [ExampleItem]s from [itemsProvider].
///
/// Extends [ConsumerWidget] to access Riverpod providers without a
/// [Consumer] wrapper widget.
class ItemListScreen extends ConsumerWidget {
  /// Creates an [ItemListScreen].
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the async items provider — rebuilds on state changes.
    final itemsAsync = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Items'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: itemsAsync.when(
        data: (items) => _ItemList(items: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(
          error: error,
          onRetry: () => ref.invalidate(itemsProvider),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

/// Renders a scrollable list of [ExampleItem] cards.
class _ItemList extends StatelessWidget {
  /// Creates an [_ItemList] with the given [items].
  const _ItemList({required this.items});

  /// The items to display.
  final List<ExampleItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No items found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _ItemCard(item: items[index]),
    );
  }
}

/// A [Card] that displays a single [ExampleItem].
class _ItemCard extends StatelessWidget {
  /// Creates an [_ItemCard] for the given [item].
  const _ItemCard({required this.item});

  /// The item to display.
  final ExampleItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            item.id,
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(
          item.title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: item.description.isNotEmpty ? Text(item.description) : null,
      ),
    );
  }
}

/// Displays an error message with a retry button.
class _ErrorView extends StatelessWidget {
  /// Creates an [_ErrorView].
  const _ErrorView({required this.error, required this.onRetry});

  /// The error that occurred.
  final Object error;

  /// Callback invoked when the user taps "Retry".
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Something went wrong:\n$error', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
