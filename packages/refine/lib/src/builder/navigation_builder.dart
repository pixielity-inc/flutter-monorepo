// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/widgets.dart';

/// The type of a navigation item.
enum NavItemType {
  /// A regular navigation link.
  link,

  /// A visual divider between groups.
  divider,

  /// A group header label (non-clickable).
  group,
}

/// A single item in the navigation schema.
class NavItem {
  /// Creates a [NavItem].
  const NavItem({
    required this.key,
    required this.type,
    this.label,
    this.icon,
    this.route,
    this.badge,
    this.children = const [],
    this.visible = true,
  });

  /// Unique key for this item.
  final String key;

  /// Item type.
  final NavItemType type;

  /// Display label.
  final String? label;

  /// Optional icon widget.
  final Widget? icon;

  /// Route path this item navigates to.
  final String? route;

  /// Optional badge text (e.g. notification count).
  final String? badge;

  /// Nested child items (for collapsible groups).
  final List<NavItem> children;

  /// Whether this item is visible. Use for role-based nav hiding.
  final bool visible;
}

/// The compiled schema produced by [NavigationBuilder.build].
class NavigationSchema {
  /// Creates a [NavigationSchema].
  const NavigationSchema({required this.items});

  /// All navigation items in order.
  final List<NavItem> items;

  /// Returns only visible items.
  List<NavItem> get visibleItems => items.where((i) => i.visible).toList();
}

/// Fluent DSL for building navigation schemas.
///
/// Integrates with [ResourceRegistry] — call [resource] to auto-add
/// a nav item from a registered resource's metadata.
///
/// ```dart
/// final schema = NavigationBuilder()
///   .item('dashboard', label: 'Dashboard',
///       icon: Icon(Icons.home), route: '/dashboard')
///   .divider()
///   .group('Resources')
///   .item('posts', label: 'Posts',
///       icon: Icon(Icons.article), route: '/posts')
///   .item('users', label: 'Users',
///       icon: Icon(Icons.people), route: '/users')
///   .divider()
///   .item('settings', label: 'Settings',
///       icon: Icon(Icons.settings), route: '/settings')
///   .build();
/// ```
class NavigationBuilder {
  final List<NavItem> _items = [];

  /// Add a navigation link item.
  NavigationBuilder item(
    String key, {
    required String label,
    Widget? icon,
    String? route,
    String? badge,
    bool visible = true,
    List<NavItem> children = const [],
  }) {
    _items.add(NavItem(
      key: key,
      type: NavItemType.link,
      label: label,
      icon: icon,
      route: route ?? '/$key',
      badge: badge,
      children: children,
      visible: visible,
    ));
    return this;
  }

  /// Add a visual divider.
  NavigationBuilder divider() {
    _items.add(NavItem(
      key: 'divider_${_items.length}',
      type: NavItemType.divider,
    ));
    return this;
  }

  /// Add a non-clickable group header label.
  NavigationBuilder group(String label) {
    _items.add(NavItem(
      key: 'group_${_items.length}',
      type: NavItemType.group,
      label: label,
    ));
    return this;
  }

  /// Add a nav item from a resource name and optional overrides.
  ///
  /// Uses the resource name as the route prefix and key.
  /// Pass [label] and [icon] to override the resource's meta values.
  NavigationBuilder resource(
    String resourceName, {
    String? label,
    Widget? icon,
    String? badge,
    bool visible = true,
  }) {
    _items.add(NavItem(
      key: resourceName,
      type: NavItemType.link,
      label: label ?? resourceName,
      icon: icon,
      route: '/$resourceName',
      badge: badge,
      visible: visible,
    ));
    return this;
  }

  /// Build and return the immutable [NavigationSchema].
  NavigationSchema build() =>
      NavigationSchema(items: List.unmodifiable(_items));
}
