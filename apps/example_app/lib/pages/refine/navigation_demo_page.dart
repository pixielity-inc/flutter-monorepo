// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';

/// Demonstrates [NavigationBuilder] + [NavigationRenderer] (sidebar)
/// alongside [FBottomNavigationBar] for mobile nav.
class NavigationDemoPage extends StatefulWidget {
  /// Creates a [NavigationDemoPage].
  const NavigationDemoPage({super.key});

  @override
  State<NavigationDemoPage> createState() => _NavigationDemoPageState();
}

class _NavigationDemoPageState extends State<NavigationDemoPage> {
  String _currentRoute = '/dashboard';
  int _bottomIndex = 0;

  late final _navSchema = NavigationBuilder()
      .item('dashboard', label: 'Dashboard', icon: const Icon(FIcons.layoutDashboard), route: '/dashboard')
      .divider()
      .group('Resources')
      .item('posts', label: 'Posts', icon: const Icon(FIcons.fileText), route: '/posts')
      .item('users', label: 'Users', icon: const Icon(FIcons.users), route: '/users',
          children: [
            NavItem(key: 'admins', type: NavItemType.link, label: 'Admins', route: '/users/admins'),
            NavItem(key: 'editors', type: NavItemType.link, label: 'Editors', route: '/users/editors'),
          ])
      .divider()
      .item('settings', label: 'Settings', icon: const Icon(FIcons.settings), route: '/settings')
      .build();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('NavigationBuilder Demo'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      footer: FBottomNavigationBar(
        index: _bottomIndex,
        onChange: (i) => setState(() => _bottomIndex = i),
        children: const [
          FBottomNavigationBarItem(icon: Icon(FIcons.house), label: Text('Home')),
          FBottomNavigationBarItem(icon: Icon(FIcons.fileText), label: Text('Posts')),
          FBottomNavigationBarItem(icon: Icon(FIcons.users), label: Text('Users')),
          FBottomNavigationBarItem(icon: Icon(FIcons.settings), label: Text('Settings')),
        ],
      ),
      child: Row(
        children: [
          // Sidebar (desktop/tablet style)
          SizedBox(
            width: 220,
            child: NavigationRenderer(
              schema: _navSchema,
              currentRoute: _currentRoute,
              onNavigate: (route) => setState(() => _currentRoute = route),
              header: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Pixielity',
                  style: context.theme.typography.lg.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const FDivider(axis: Axis.vertical),
          // Content area
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FIcons.mapPin, size: 32, color: context.theme.colors.mutedForeground),
                  const SizedBox(height: 8),
                  Text(
                    'Active route: $_currentRoute',
                    style: context.theme.typography.md.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bottom nav index: $_bottomIndex',
                    style: context.theme.typography.sm.copyWith(
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
