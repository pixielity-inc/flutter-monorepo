// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';

class _Post {
  const _Post({required this.id, required this.title, required this.status, required this.views});
  final int id;
  final String title;
  final String status;
  final int views;
  @override
  String toString() => title;
}

final _posts = List.generate(
  12,
  (i) => _Post(
    id: i + 1,
    title: 'Post ${i + 1}: ${['Flutter tips', 'Dart tricks', 'ForeUI guide', 'Riverpod patterns'][i % 4]}',
    status: i % 3 == 0 ? 'draft' : 'published',
    views: (i + 1) * 142,
  ),
);

/// Demonstrates [TableBuilder] + [TableRenderer].
class TableDemoPage extends StatefulWidget {
  /// Creates a [TableDemoPage].
  const TableDemoPage({super.key});

  @override
  State<TableDemoPage> createState() => _TableDemoPageState();
}

class _TableDemoPageState extends State<TableDemoPage> {
  int _page = 1;
  String? _lastAction;

  late final _schema = TableBuilder<_Post>()
      .column('title', label: 'Title', sortable: true, valueGetter: (r) => r.title)
      .column('status', label: 'Status', width: 100, valueGetter: (r) => r.status)
      .column('views', label: 'Views', align: ColumnAlign.right, sortable: true, valueGetter: (r) => r.views)
      .action('edit', label: 'Edit', icon: const Icon(FIcons.pencil), onPressed: (r) => setState(() => _lastAction = 'Edit: ${r.title}'))
      .action('delete', label: 'Delete', icon: const Icon(FIcons.trash2), destructive: true, onPressed: (r) => setState(() => _lastAction = 'Delete: ${r.title}'))
      .perPage(5)
      .build();

  List<_Post> get _pageData {
    final start = (_page - 1) * 5;
    return _posts.skip(start).take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('TableBuilder Demo'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_lastAction != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FAlert(
                  title: Text(_lastAction!),
                ),
              ),
            FCard(
              title: const Text('Posts Table'),
              subtitle: const Text('Sortable columns, row actions, pagination'),
              child: TableRenderer<_Post>(
                schema: _schema,
                data: _pageData,
                totalCount: _posts.length,
                currentPage: _page,
                onPageChanged: (p) => setState(() => _page = p),
                onSortChanged: (col, dir) => setState(() => _lastAction = 'Sort: $col $dir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
