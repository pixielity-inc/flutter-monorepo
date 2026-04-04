// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../builder/chart_builder.dart';

/// Renders a [ChartSchema] using ForeUI layout primitives.
///
/// The default implementation renders a placeholder card with chart metadata.
/// Provide [customBuilder] to wire up fl_chart, syncfusion, or any other
/// charting library — the schema and data are passed through for full control.
///
/// ```dart
/// ChartRenderer(
///   schema: chartSchema,
///   data: revenueData,
///   customBuilder: (context, schema, data) => LineChart(...),
/// )
/// ```
class ChartRenderer extends StatelessWidget {
  /// Creates a [ChartRenderer].
  const ChartRenderer({
    super.key,
    required this.schema,
    this.data = const [],
    this.customBuilder,
    this.isLoading = false,
  });

  /// The chart schema.
  final ChartSchema schema;

  /// Data points — list of maps where each key matches a series or axis key.
  final List<Map<String, dynamic>> data;

  /// Optional custom chart builder. Receives schema and data for full control.
  final Widget Function(
    BuildContext context,
    ChartSchema schema,
    List<Map<String, dynamic>> data,
  )? customBuilder;

  /// Whether to show a loading indicator.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SizedBox(
      height: schema.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (schema.title != null) ...[
            Text(
              schema.title!,
              style: theme.typography.md.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colors.foreground,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: isLoading
                ? const Center(child: FCircularProgress())
                : customBuilder != null
                    ? customBuilder!(context, schema, data)
                    : _buildPlaceholder(context),
          ),
          if (schema.showLegend && schema.series.isNotEmpty)
            _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = context.theme;
    return FCard.raw(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FIcons.chartLine,
              size: 40,
              color: theme.colors.mutedForeground,
            ),
            const SizedBox(height: 8),
            Text(
              '${schema.type.name} chart — ${data.length} data points',
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Text(
              'Provide customBuilder to render with fl_chart or syncfusion.',
              style: theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 16,
        children: schema.series.map((s) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: s.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                s.label,
                style: theme.typography.xs.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
