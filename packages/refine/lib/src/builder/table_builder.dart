// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/widgets.dart';

/// Alignment for a table column.
enum ColumnAlign { left, center, right }

/// A single column definition produced by [TableBuilder].
class TableColumn<T> {
  /// Creates a [TableColumn].
  const TableColumn({
    required this.key,
    required this.label,
    this.width,
    this.align = ColumnAlign.left,
    this.sortable = false,
    this.cellBuilder,
    this.valueGetter,
  });

  /// The data key — maps to a field on [T].
  final String key;

  /// Header label shown in the column header.
  final String label;

  /// Fixed column width. If null, column expands to fill available space.
  final double? width;

  /// Text alignment for this column.
  final ColumnAlign align;

  /// Whether this column can be sorted.
  final bool sortable;

  /// Custom cell widget builder. If null, falls back to [valueGetter].toString().
  final Widget Function(BuildContext context, T row)? cellBuilder;

  /// Extract the display value from a row. Used when [cellBuilder] is null.
  final dynamic Function(T row)? valueGetter;
}

/// A row action (edit, delete, custom) shown per row.
class TableAction<T> {
  /// Creates a [TableAction].
  const TableAction({
    required this.key,
    required this.label,
    this.icon,
    this.destructive = false,
    this.visible,
    required this.onPressed,
  });

  /// Unique key for this action.
  final String key;

  /// Label shown in tooltip or button.
  final String label;

  /// Optional icon widget.
  final Widget? icon;

  /// Whether this is a destructive action (shown in red).
  final bool destructive;

  /// Optional predicate — hide the action for certain rows.
  final bool Function(T row)? visible;

  /// Callback when the action is triggered.
  final void Function(T row) onPressed;
}

/// The compiled schema produced by [TableBuilder.build].
class TableSchema<T> {
  /// Creates a [TableSchema].
  const TableSchema({
    required this.columns,
    required this.actions,
    this.selectable = false,
    this.perPage = 15,
  });

  /// Column definitions.
  final List<TableColumn<T>> columns;

  /// Row actions.
  final List<TableAction<T>> actions;

  /// Whether rows can be selected (checkbox column).
  final bool selectable;

  /// Default rows per page for pagination.
  final int perPage;
}

/// Fluent DSL for building data table schemas.
///
/// ```dart
/// final schema = TableBuilder<Post>()
///   .column('title', label: 'Title', sortable: true)
///   .column('status', label: 'Status', width: 120)
///   .action('edit', label: 'Edit', onPressed: (row) => goToEdit(row))
///   .action('delete', label: 'Delete', destructive: true,
///       onPressed: (row) => delete(row))
///   .selectable()
///   .build();
/// ```
class TableBuilder<T> {
  final List<TableColumn<T>> _columns = [];
  final List<TableAction<T>> _actions = [];
  bool _selectable = false;
  int _perPage = 15;

  /// Add a column.
  TableBuilder<T> column(
    String key, {
    required String label,
    double? width,
    ColumnAlign align = ColumnAlign.left,
    bool sortable = false,
    Widget Function(BuildContext context, T row)? cellBuilder,
    dynamic Function(T row)? valueGetter,
  }) {
    _columns.add(TableColumn(
      key: key,
      label: label,
      width: width,
      align: align,
      sortable: sortable,
      cellBuilder: cellBuilder,
      valueGetter: valueGetter,
    ));
    return this;
  }

  /// Add a row action.
  TableBuilder<T> action(
    String key, {
    required String label,
    Widget? icon,
    bool destructive = false,
    bool Function(T row)? visible,
    required void Function(T row) onPressed,
  }) {
    _actions.add(TableAction(
      key: key,
      label: label,
      icon: icon,
      destructive: destructive,
      visible: visible,
      onPressed: onPressed,
    ));
    return this;
  }

  /// Enable row selection (checkbox column).
  TableBuilder<T> selectable() {
    _selectable = true;
    return this;
  }

  /// Set default rows per page.
  TableBuilder<T> perPage(int value) {
    _perPage = value;
    return this;
  }

  /// Build and return the immutable [TableSchema].
  TableSchema<T> build() => TableSchema(
        columns: List.unmodifiable(_columns),
        actions: List.unmodifiable(_actions),
        selectable: _selectable,
        perPage: _perPage,
      );
}
