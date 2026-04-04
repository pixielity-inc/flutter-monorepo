// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/widgets.dart';
import 'chart_builder.dart';
import 'table_builder.dart';

/// The type of a dashboard tile.
enum DashboardTileType {
  /// A single KPI stat card (value + label + optional icon).
  stat,

  /// A chart tile.
  chart,

  /// A data table tile.
  table,

  /// A fully custom widget tile.
  custom,
}

/// A single tile in the dashboard grid.
class DashboardTile {
  /// Creates a [DashboardTile].
  const DashboardTile({
    required this.key,
    required this.type,
    this.title,
    this.span = 1,
    this.rowSpan = 1,
    this.statConfig,
    this.chartSchema,
    this.tableSchema,
    this.customBuilder,
  });

  /// Unique key for this tile.
  final String key;

  /// Tile type.
  final DashboardTileType type;

  /// Optional tile title shown in the card header.
  final String? title;

  /// Number of grid columns this tile spans (1–4).
  final int span;

  /// Number of grid rows this tile spans.
  final int rowSpan;

  /// Config for [DashboardTileType.stat] tiles.
  final StatTileConfig? statConfig;

  /// Schema for [DashboardTileType.chart] tiles.
  final ChartSchema? chartSchema;

  /// Schema for [DashboardTileType.table] tiles.
  final TableSchema<dynamic>? tableSchema;

  /// Builder for [DashboardTileType.custom] tiles.
  final Widget Function(BuildContext context)? customBuilder;
}

/// Configuration for a stat (KPI) tile.
class StatTileConfig {
  /// Creates a [StatTileConfig].
  const StatTileConfig({
    required this.valueKey,
    required this.label,
    this.icon,
    this.format,
    this.trend,
  });

  /// The key in the data map that holds the numeric value.
  final String valueKey;

  /// Human-readable label below the value.
  final String label;

  /// Optional icon widget.
  final Widget? icon;

  /// Optional value format: 'currency', 'percent', 'number'.
  final String? format;

  /// Optional trend indicator config.
  final StatTrend? trend;
}

/// Trend direction for a stat tile.
enum TrendDirection { up, down, neutral }

/// Trend indicator shown on a stat tile.
class StatTrend {
  /// Creates a [StatTrend].
  const StatTrend({
    required this.valueKey,
    required this.direction,
    this.label,
  });

  /// The key in the data map that holds the trend value.
  final String valueKey;

  /// Trend direction.
  final TrendDirection direction;

  /// Optional label (e.g. 'vs last month').
  final String? label;
}

/// The compiled schema produced by [DashboardBuilder.build].
class DashboardSchema {
  /// Creates a [DashboardSchema].
  const DashboardSchema({
    required this.tiles,
    this.columns = 4,
    this.gap = 16,
  });

  /// All tile definitions in layout order.
  final List<DashboardTile> tiles;

  /// Number of grid columns (default 4).
  final int columns;

  /// Gap between tiles in logical pixels.
  final double gap;
}

/// Fluent DSL for building dashboard layouts.
///
/// ```dart
/// final schema = DashboardBuilder()
///   .stat('total_orders',
///       label: 'Total Orders',
///       icon: Icon(Icons.shopping_cart))
///   .stat('revenue',
///       label: 'Revenue',
///       format: 'currency',
///       span: 1)
///   .chart(revenueChartSchema, title: 'Revenue', span: 2)
///   .table(ordersTableSchema, title: 'Recent Orders', span: 4)
///   .build();
/// ```
class DashboardBuilder {
  final List<DashboardTile> _tiles = [];
  int _columns = 4;
  double _gap = 16;

  /// Add a stat (KPI) tile.
  DashboardBuilder stat(
    String key, {
    required String label,
    Widget? icon,
    String? format,
    StatTrend? trend,
    int span = 1,
    String? title,
  }) {
    _tiles.add(DashboardTile(
      key: key,
      type: DashboardTileType.stat,
      title: title,
      span: span,
      statConfig: StatTileConfig(
        valueKey: key,
        label: label,
        icon: icon,
        format: format,
        trend: trend,
      ),
    ));
    return this;
  }

  /// Add a chart tile.
  DashboardBuilder chart(
    ChartSchema schema, {
    String? title,
    int span = 2,
    int rowSpan = 1,
  }) {
    _tiles.add(DashboardTile(
      key: 'chart_${_tiles.length}',
      type: DashboardTileType.chart,
      title: title,
      span: span,
      rowSpan: rowSpan,
      chartSchema: schema,
    ));
    return this;
  }

  /// Add a table tile.
  DashboardBuilder table(
    TableSchema<dynamic> schema, {
    String? title,
    int span = 4,
    int rowSpan = 1,
  }) {
    _tiles.add(DashboardTile(
      key: 'table_${_tiles.length}',
      type: DashboardTileType.table,
      title: title,
      span: span,
      rowSpan: rowSpan,
      tableSchema: schema,
    ));
    return this;
  }

  /// Add a fully custom widget tile.
  DashboardBuilder custom(
    String key,
    Widget Function(BuildContext context) builder, {
    String? title,
    int span = 1,
    int rowSpan = 1,
  }) {
    _tiles.add(DashboardTile(
      key: key,
      type: DashboardTileType.custom,
      title: title,
      span: span,
      rowSpan: rowSpan,
      customBuilder: builder,
    ));
    return this;
  }

  /// Set the number of grid columns.
  DashboardBuilder columns(int value) {
    _columns = value;
    return this;
  }

  /// Set the gap between tiles.
  DashboardBuilder gap(double value) {
    _gap = value;
    return this;
  }

  /// Build and return the immutable [DashboardSchema].
  DashboardSchema build() => DashboardSchema(
        tiles: List.unmodifiable(_tiles),
        columns: _columns,
        gap: _gap,
      );
}
