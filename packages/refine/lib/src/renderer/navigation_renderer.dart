// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../builder/navigation_builder.dart';

/// Renders a [NavigationSchema] as a ForeUI [FSidebar].
///
/// ```dart
/// NavigationRenderer(
///   schema: navSchema,
///   currentRoute: '/posts',
///   onNavigate: (route) => context.go(route),
/// )
/// ```
class NavigationRenderer extends StatelessWidget {
  /// Creates a [NavigationRenderer].
  const NavigationRenderer({
    super.key,
    required this.schema,
    required this.onNavigate,
    this.currentRoute,
    this.header,
    this.footer,
  });

  /// The navigation schema.
  final NavigationSchema schema;

  /// Called when a nav item is tapped.
  final void Function(String route) onNavigate;

  /// Currently active route path.
  final String? currentRoute;

  /// Optional widget shown at the top of the sidebar.
  final Widget? header;

  /// Optional widget shown at the bottom of the sidebar.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final groups = _buildGroups(context);

    return FSidebar(
      header: header,
      footer: footer,
      children: groups,
    );
  }

  List<Widget> _buildGroups(BuildContext context) {
    final result = <Widget>[];
    final groupItems = <Widget>[];
    String? currentGroupLabel;

    void flushGroup() {
      if (groupItems.isNotEmpty) {
        result.add(FSidebarGroup(
          label: currentGroupLabel != null ? Text(currentGroupLabel!) : null,
          children: List.of(groupItems),
        ));
        groupItems.clear();
        currentGroupLabel = null;
      }
    }

    for (final item in schema.visibleItems) {
      switch (item.type) {
        case NavItemType.divider:
          flushGroup();
          result.add(const FDivider());

        case NavItemType.group:
          flushGroup();
          currentGroupLabel = item.label;

        case NavItemType.link:
          groupItems.add(_buildSidebarItem(item));
      }
    }

    flushGroup();
    return result;
  }

  Widget _buildSidebarItem(NavItem item) {
    return FSidebarItem(
      icon: item.icon,
      label: item.label != null ? Text(item.label!) : null,
      selected: currentRoute == item.route,
      onPress: item.route != null ? () => onNavigate(item.route!) : null,
      children: item.children
          .where((c) => c.visible)
          .map((child) => FSidebarItem(
                icon: child.icon,
                label: child.label != null ? Text(child.label!) : null,
                selected: currentRoute == child.route,
                onPress: child.route != null
                    ? () => onNavigate(child.route!)
                    : null,
              ))
          .toList(),
    );
  }
}
