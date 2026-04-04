// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';

/// Demonstrates [DashboardBuilder] + [DashboardRenderer].
class DashboardDemoPage extends StatelessWidget {
  /// Creates a [DashboardDemoPage].
  const DashboardDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chartSchema = ChartBuilder()
        .type(ChartType.area)
        .title('Revenue Trend')
        .series('revenue', label: 'Revenue', color: Colors.blue)
        .height(180)
        .build();

    final tableSchema = TableBuilder<Map<String, dynamic>>()
        .column('name', label: 'Name', valueGetter: (r) => r['name'])
        .column('amount', label: 'Amount', align: ColumnAlign.right, valueGetter: (r) => r['amount'])
        .column('status', label: 'Status', valueGetter: (r) => r['status'])
        .build();

    final dashSchema = DashboardBuilder()
        .stat('total_orders', label: 'Total Orders', icon: const Icon(FIcons.shoppingCart), span: 1)
        .stat('revenue', label: 'Revenue', format: 'currency', span: 1,
            trend: const StatTrend(valueKey: 'revenue_trend', direction: TrendDirection.up, label: 'vs last month'))
        .stat('users', label: 'Active Users', span: 1)
        .stat('conversion', label: 'Conversion', format: 'percent', span: 1)
        .chart(chartSchema, title: 'Revenue', span: 2)
        .table(tableSchema, title: 'Recent Orders', span: 2)
        .build();

    return FScaffold(
      header: FHeader.nested(
        title: const Text('DashboardBuilder Demo'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DashboardRenderer(
          schema: dashSchema,
          data: {
            'total_orders': 1_284,
            'revenue': 48_320.50,
            'users': 3_741,
            'conversion': 3.8,
          },
          tableData: {
            'table_1': [
              {'name': 'Alice', 'amount': '\$240', 'status': 'paid'},
              {'name': 'Bob', 'amount': '\$180', 'status': 'pending'},
              {'name': 'Carol', 'amount': '\$320', 'status': 'paid'},
            ],
          },
        ),
      ),
    );
  }
}
