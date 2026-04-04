// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';

/// Demonstrates [ChartBuilder] + [ChartRenderer].
class ChartDemoPage extends StatelessWidget {
  /// Creates a [ChartDemoPage].
  const ChartDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lineSchema = ChartBuilder()
        .type(ChartType.line)
        .title('Monthly Revenue')
        .series('revenue', label: 'Revenue', color: Colors.blue)
        .series('orders', label: 'Orders', color: Colors.green)
        .xAxis('month', label: 'Month')
        .yAxis('value', label: 'Amount', format: 'currency')
        .height(220)
        .build();

    final barSchema = ChartBuilder()
        .type(ChartType.bar)
        .title('Weekly Users')
        .series('users', label: 'Active Users', color: Colors.purple)
        .xAxis('week', label: 'Week')
        .height(200)
        .legend(show: false)
        .build();

    final pieSchema = ChartBuilder()
        .type(ChartType.donut)
        .title('Traffic Sources')
        .series('organic', label: 'Organic', color: Colors.teal)
        .series('paid', label: 'Paid', color: Colors.orange)
        .series('direct', label: 'Direct', color: Colors.indigo)
        .height(200)
        .build();

    return FScaffold(
      header: FHeader.nested(
        title: const Text('ChartBuilder Demo'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FAlert(
              title: const Text('Placeholder renderer'),
              subtitle: const Text(
                'Provide customBuilder to wire fl_chart or syncfusion. '
                'The schema carries all config — type, series, axes, colors.',
              ),
            ),
            const SizedBox(height: 16),
            FCard(
              child: ChartRenderer(schema: lineSchema),
            ),
            const SizedBox(height: 12),
            FCard(
              child: ChartRenderer(schema: barSchema),
            ),
            const SizedBox(height: 12),
            FCard(
              child: ChartRenderer(schema: pieSchema),
            ),
          ],
        ),
      ),
    );
  }
}
