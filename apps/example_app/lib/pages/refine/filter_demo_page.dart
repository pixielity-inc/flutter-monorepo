// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';

/// Demonstrates [FilterBuilder] + [FilterRenderer] → [QueryParams].
class FilterDemoPage extends StatefulWidget {
  /// Creates a [FilterDemoPage].
  const FilterDemoPage({super.key});

  @override
  State<FilterDemoPage> createState() => _FilterDemoPageState();
}

class _FilterDemoPageState extends State<FilterDemoPage> {
  QueryParams<dynamic>? _params;

  final _schema = FilterBuilder()
      .search('q', label: 'Search', placeholder: 'Search posts...')
      .select(
        'status',
        label: 'Status',
        options: [
          FieldOption(value: 'draft', label: 'Draft'),
          FieldOption(value: 'published', label: 'Published'),
          FieldOption(value: 'archived', label: 'Archived'),
        ],
      )
      .multiSelect(
        'tags',
        label: 'Tags',
        options: [
          FieldOption(value: 'flutter', label: 'Flutter'),
          FieldOption(value: 'dart', label: 'Dart'),
          FieldOption(value: 'forui', label: 'ForeUI'),
        ],
      )
      .toggle('featured', label: 'Featured only')
      .dateRange('created_at', label: 'Date Range')
      .numberRange('views', label: 'Views')
      .build();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('FilterBuilder Demo'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FCard(
              title: const Text('Filter Bar'),
              subtitle: const Text('All filter types → QueryParams'),
              child: FilterRenderer<dynamic>(
                schema: _schema,
                onChanged: (params) => setState(() => _params = params),
              ),
            ),
            const SizedBox(height: 16),
            if (_params != null)
              FCard(
                title: const Text('Generated QueryParams'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_params!.wheres.isEmpty)
                      Text(
                        'No filters active',
                        style: context.theme.typography.sm.copyWith(
                          color: context.theme.colors.mutedForeground,
                        ),
                      )
                    else
                      ..._params!.wheres.map(
                        (w) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '${w.boolean.toUpperCase()} ${w.column} ${w.operator} ${w.value}',
                            style: context.theme.typography.sm,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
