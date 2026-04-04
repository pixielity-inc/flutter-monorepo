// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../builder/table_builder.dart';

/// Renders a [TableSchema] using ForeUI [FItemGroup] tiles with sorting,
/// row actions, and pagination controls.
///
/// ```dart
/// TableRenderer<Post>(
///   schema: tableSchema,
///   data: posts,
///   totalCount: 120,
///   currentPage: 1,
///   onPageChanged: (page) => setState(() => _page = page),
/// )
/// ```
class TableRenderer<T> extends StatefulWidget {
  /// Creates a [TableRenderer].
  const TableRenderer({
    super.key,
    required this.schema,
    required this.data,
    this.totalCount,
    this.currentPage = 1,
    this.onPageChanged,
    this.onSortChanged,
    this.onSelectionChanged,
    this.isLoading = false,
    this.emptyMessage = 'No records found.',
  });

  /// The table schema.
  final TableSchema<T> schema;

  /// Current page of data.
  final List<T> data;

  /// Total record count for pagination.
  final int? totalCount;

  /// Current page (1-based).
  final int currentPage;

  /// Called when the user changes page.
  final void Function(int page)? onPageChanged;

  /// Called when a sortable column header is tapped.
  final void Function(String column, String direction)? onSortChanged;

  /// Called when row selection changes.
  final void Function(List<T> selected)? onSelectionChanged;

  /// Whether to show a loading indicator.
  final bool isLoading;

  /// Message shown when data is empty.
  final String emptyMessage;

  @override
  State<TableRenderer<T>> createState() => _TableRendererState<T>();
}

class _TableRendererState<T> extends State<TableRenderer<T>> {
  String? _sortColumn;
  String _sortDirection = 'asc';

  void _toggleSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortDirection = _sortDirection == 'asc' ? 'desc' : 'asc';
      } else {
        _sortColumn = column;
        _sortDirection = 'asc';
      }
    });
    widget.onSortChanged?.call(column, _sortDirection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final schema = widget.schema;
    final perPage = schema.perPage;
    final totalCount = widget.totalCount;
    final lastPage = totalCount != null ? (totalCount / perPage).ceil() : null;

    if (widget.isLoading) {
      return const Center(child: FCircularProgress());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Column headers ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              ...schema.columns.map((col) {
                final isSorted = _sortColumn == col.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: col.sortable ? () => _toggleSort(col.key) : null,
                    child: Row(
                      mainAxisAlignment: switch (col.align) {
                        ColumnAlign.right => MainAxisAlignment.end,
                        ColumnAlign.center => MainAxisAlignment.center,
                        _ => MainAxisAlignment.start,
                      },
                      children: [
                        Text(
                          col.label,
                          style: theme.typography.sm.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                        if (col.sortable) ...[
                          const SizedBox(width: 4),
                          Icon(
                            isSorted && _sortDirection == 'desc'
                                ? FIcons.chevronDown
                                : FIcons.chevronUp,
                            size: 12,
                            color: isSorted
                                ? theme.colors.foreground
                                : theme.colors.mutedForeground,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              if (schema.actions.isNotEmpty) const SizedBox(width: 80),
            ],
          ),
        ),
        const FDivider(),

        // ── Rows ──────────────────────────────────────────────────────────────
        if (widget.data.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                widget.emptyMessage,
                style: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          )
        else
          FTileGroup(
            children: widget.data.map((row) {
              final visibleActions = schema.actions
                  .where((a) => a.visible == null || a.visible!(row))
                  .toList();

              return FTile.raw(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      ...schema.columns.map((col) {
                        final cell = col.cellBuilder != null
                            ? col.cellBuilder!(context, row)
                            : Text(
                                col.valueGetter != null
                                    ? col.valueGetter!(row).toString()
                                    : '',
                                style: theme.typography.sm,
                              );
                        return Expanded(child: cell);
                      }),
                      if (visibleActions.isNotEmpty)
                        SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: visibleActions.map((action) {
                              return FButton.icon(
                                variant: .ghost,
                                size: .sm,
                                onPress: () => action.onPressed(row),
                                child: action.icon ??
                                    Icon(
                                      FIcons.ellipsis,
                                      color: action.destructive
                                          ? theme.colors.destructive
                                          : null,
                                    ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

        // ── Pagination ────────────────────────────────────────────────────────
        if (lastPage != null && lastPage > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FPagination(
              control: FPaginationControl.managed(
                pages: lastPage,
                initial: widget.currentPage - 1,
                onChange: (page) => widget.onPageChanged?.call(page + 1),
              ),
            ),
          ),
      ],
    );
  }
}
