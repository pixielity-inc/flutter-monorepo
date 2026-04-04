// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../providers/delete_provider.dart';
import '../providers/list_provider.dart';
import '../resource/resource.dart';

/// Auto-generated list page for a [Resource] using ForeUI.
///
/// ```dart
/// ListPage(resource: postResource)
/// ```
class ListPage<T, ID> extends ConsumerStatefulWidget {
  /// Creates a [ListPage].
  const ListPage({
    super.key,
    required this.resource,
    this.itemBuilder,
    this.onTap,
  });

  /// The resource definition.
  final Resource<T, ID> resource;

  /// Optional custom item builder. Falls back to [toString] if null.
  final Widget Function(BuildContext context, T item)? itemBuilder;

  /// Called when an item is tapped.
  final void Function(T item)? onTap;

  @override
  ConsumerState<ListPage<T, ID>> createState() => _ListPageState<T, ID>();
}

class _ListPageState<T, ID> extends ConsumerState<ListPage<T, ID>> {
  late final _listProvider = listProvider<T, ID>(widget.resource.service);
  late final _deleteProvider = deleteProvider<T, ID>(widget.resource.service);

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_listProvider);
    final deleteState = ref.watch(_deleteProvider);
    final label = widget.resource.meta?.label ?? widget.resource.name;

    return FScaffold(
      header: FHeader(
        title: Text(label),
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.plus),
            onPress: () => Navigator.of(context).pushNamed(
              '/${widget.resource.name}/create',
            ),
          ),
        ],
      ),
      child: async.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (e, _) => Center(
          child: FAlert(
            variant: .destructive,
            title: const Text('Error'),
            subtitle: Text(e.toString()),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                'No records found.',
                style: context.theme.typography.sm.copyWith(
                  color: context.theme.colors.mutedForeground,
                ),
              ),
            );
          }

          return FTileGroup(
            children: items.map((item) {
              return FTile(
                title: widget.itemBuilder != null
                    ? widget.itemBuilder!(context, item)
                    : Text(item.toString()),
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FButton.icon(
                      variant: .ghost,
                      size: .sm,
                      onPress: () => Navigator.of(context).pushNamed(
                        '/${widget.resource.name}/edit',
                        arguments: item,
                      ),
                      child: const Icon(FIcons.pencil),
                    ),
                    FButton.icon(
                      variant: .ghost,
                      size: .sm,
                      onPress: deleteState.isLoading
                          ? null
                          : () => _confirmDelete(context, item),
                      child: deleteState.isLoading
                          ? const FCircularProgress(size: .sm)
                          : Icon(
                              FIcons.trash2,
                              color: context.theme.colors.destructive,
                            ),
                    ),
                  ],
                ),
                onPress: widget.onTap != null ? () => widget.onTap!(item) : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, T item) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Confirm Delete'),
        body: const Text(
          'Are you sure you want to delete this record? This action cannot be undone.',
        ),
        actions: [
          FButton(
            size: .sm,
            variant: .destructive,
            child: const Text('Delete'),
            onPress: () => Navigator.of(context).pop(true),
          ),
          FButton(
            size: .sm,
            variant: .outline,
            child: const Text('Cancel'),
            onPress: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(_deleteProvider.notifier).mutate(item as ID);
      ref.invalidate(_listProvider);
    }
  }
}
