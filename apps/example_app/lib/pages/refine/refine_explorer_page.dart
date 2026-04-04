// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'form_demo_page.dart';
import 'table_demo_page.dart';
import 'filter_demo_page.dart';
import 'chart_demo_page.dart';
import 'dashboard_demo_page.dart';
import 'navigation_demo_page.dart';
import 'crud/post_crud_page.dart';
import 'crud/refine_app_page.dart';

/// Entry point for all refine builder/renderer demos.
class RefineExplorerPage extends StatelessWidget {
  /// Creates a [RefineExplorerPage].
  const RefineExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Refine Builders'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Schema-driven UI builders powered by ForeUI',
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 20),
            _DemoCard(
              icon: LucideIcons.rocket,
              title: 'Full Refine App',
              subtitle: 'Complete app: Login → Dashboard → Sidebar → CRUD — all wired with auth, access control, and live data',
              onTap: () => _push(context, const RefineAppPage()),
            ),
            const FDivider(),
            const SizedBox(height: 12),
            _DemoCard(
              icon: LucideIcons.squarePen,
              title: 'FormBuilder',
              subtitle: 'All field types: text, email, password, number, select, multiselect, checkbox, date, time',
              onTap: () => _push(context, const FormDemoPage()),
            ),
            _DemoCard(
              icon: LucideIcons.table2,
              title: 'TableBuilder',
              subtitle: 'Columns, sorting, row actions, pagination',
              onTap: () => _push(context, const TableDemoPage()),
            ),
            _DemoCard(
              icon: LucideIcons.listFilter,
              title: 'FilterBuilder',
              subtitle: 'Search, select, multi-select, date range, toggle, number range',
              onTap: () => _push(context, const FilterDemoPage()),
            ),
            _DemoCard(
              icon: LucideIcons.chartBar,
              title: 'ChartBuilder',
              subtitle: 'Chart schema with series, axes, legend, and placeholder renderer',
              onTap: () => _push(context, const ChartDemoPage()),
            ),
            _DemoCard(
              icon: LucideIcons.layoutDashboard,
              title: 'DashboardBuilder',
              subtitle: 'Stat tiles, chart tiles, table tiles in a responsive grid',
              onTap: () => _push(context, const DashboardDemoPage()),
            ),
            _DemoCard(
              icon: LucideIcons.panelLeft,
              title: 'NavigationBuilder',
              subtitle: 'Sidebar with groups, nested items, dividers, and active route',
              onTap: () => _push(context, const NavigationDemoPage()),
            ),
            const FDivider(),
            const SizedBox(height: 12),
            _DemoCard(
              icon: LucideIcons.globe,
              title: 'Full CRUD — Posts',
              subtitle: 'Live API demo: Model → Repo → Service → Resource → Table + Filter + Form against api.fake-rest.refine.dev',
              onTap: () => _push(context, const PostCrudPage()),
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FTappable(
        onPress: onTap,
        child: FCard(
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, size: 18, color: theme.colors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.typography.md.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.typography.xs.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: theme.colors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
