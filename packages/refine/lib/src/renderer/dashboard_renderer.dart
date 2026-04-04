// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../builder/dashboard_builder.dart';
import 'chart_renderer.dart';
import 'table_renderer.dart';

/// Renders a [DashboardSchema] as a responsive grid of ForeUI [FCard] tiles.
///
/// ```dart
/// DashboardRenderer(
///   schema: dashboardSchema,
///   data: {'total_orders': 142, 'revenue': 9800.0},
///   tableData: {'table_0': orders},
///   chartData: {'chart_1': revenuePoints},
/// )
/// ```
class DashboardRenderer extends StatelessWidget {
  /// Creates a [DashboardRenderer].
  const DashboardRenderer({
    super.key,
    required this.schema,
    this.data = const {},
    this.tableData = const {},
    this.chartData = const {},
    this.isLoading = false,
  });

  /// The dashboard schema.
  final DashboardSchema schema;

  /// Flat key→value map for stat tiles.
  final Map<String, dynamic> data;

  /// Key→rows map for table tiles.
  final Map<String, List<dynamic>> tableData;

  /// Key→data-points map for chart tiles.
  final Map<String, List<Map<String, dynamic>>> chartData;

  /// Whether to show loading skeletons.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 600 ? 2 : schema.columns;
        final tileWidth =
            (constraints.maxWidth - schema.gap * (cols - 1)) / cols;

        return Wrap(
          spacing: schema.gap,
          runSpacing: schema.gap,
          children: schema.tiles.map((tile) {
            final width =
                tileWidth * tile.span + schema.gap * (tile.span - 1);
            return SizedBox(
              width: width.clamp(tileWidth, constraints.maxWidth),
              child: _buildTile(context, tile),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, DashboardTile tile) {
    return FCard(
      title: tile.title != null ? Text(tile.title!) : null,
      child: switch (tile.type) {
        DashboardTileType.stat => _StatTile(
            tile: tile,
            value: data[tile.statConfig?.valueKey],
            isLoading: isLoading,
          ),
        DashboardTileType.chart => tile.chartSchema != null
            ? ChartRenderer(
                schema: tile.chartSchema!,
                data: chartData[tile.key] ?? [],
                isLoading: isLoading,
              )
            : const SizedBox.shrink(),
        DashboardTileType.table => tile.tableSchema != null
            ? TableRenderer(
                schema: tile.tableSchema!,
                data: tableData[tile.key] ?? [],
                isLoading: isLoading,
              )
            : const SizedBox.shrink(),
        DashboardTileType.custom => tile.customBuilder != null
            ? tile.customBuilder!(context)
            : const SizedBox.shrink(),
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.tile,
    required this.value,
    required this.isLoading,
  });

  final DashboardTile tile;
  final dynamic value;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final config = tile.statConfig;
    if (config == null) return const SizedBox.shrink();

    final formatted = _format(value, config.format);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (config.icon != null) ...[
              config.icon!,
              const SizedBox(width: 8),
            ],
            Text(
              config.label,
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        isLoading
            ? const FProgress()
            : Text(
                formatted,
                style: theme.typography.xl2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colors.foreground,
                ),
              ),
        if (config.trend != null) ...[
          const SizedBox(height: 4),
          _TrendBadge(trend: config.trend!),
        ],
      ],
    );
  }

  String _format(dynamic value, String? format) {
    if (value == null) return '—';
    if (format == 'currency') {
      return '\$${(value as num).toStringAsFixed(2)}';
    }
    if (format == 'percent') {
      return '${(value as num).toStringAsFixed(1)}%';
    }
    return value.toString();
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend});

  final StatTrend trend;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isUp = trend.direction == TrendDirection.up;
    final isDown = trend.direction == TrendDirection.down;

    final color = isUp
        ? Colors.green
        : isDown
            ? theme.colors.destructive
            : theme.colors.mutedForeground;

    final icon = isUp
        ? FIcons.trendingUp
        : isDown
            ? FIcons.trendingDown
            : FIcons.minus;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        if (trend.label != null)
          Text(
            trend.label!,
            style: theme.typography.xs.copyWith(color: color),
          ),
      ],
    );
  }
}
