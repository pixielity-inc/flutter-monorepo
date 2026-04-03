// ignore_for_file: lines_longer_than_80_chars
//
// home_page.dart
//
// The main launcher screen for the Pixielity example app.
// Each card navigates to a dedicated feature explorer page.

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_example_app/pages/analytics_explorer_page.dart';
import 'package:pixielity_example_app/pages/api_explorer_page.dart';
import 'package:pixielity_example_app/pages/auth_explorer_page.dart';
import 'package:pixielity_example_app/pages/config_explorer_page.dart';
import 'package:pixielity_example_app/pages/container_explorer_page.dart';
import 'package:pixielity_example_app/pages/feature_flags_explorer_page.dart';
import 'package:pixielity_example_app/pages/storage_explorer_page.dart';
import 'package:pixielity_example_app/pages/theme_explorer_page.dart';

/// Home page — a launcher for all feature demos in the example app.
///
/// Each [_FeatureCard] navigates to a dedicated explorer page that
/// demonstrates a specific part of the Pixielity monorepo architecture.
class HomePage extends StatelessWidget {
  /// Creates the [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // ── Header ────────────────────────────────────────────────────
              Text(
                'Pixielity',
                style: theme.typography.xl3.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Flutter Monorepo — Feature Explorer',
                style: theme.typography.sm.copyWith(color: theme.colors.mutedForeground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FBadge(child: const Text('Forui')),
                  const SizedBox(width: 8),
                  FBadge(variant: FBadgeVariant.secondary, child: const Text('Riverpod')),
                  const SizedBox(width: 8),
                  FBadge(variant: FBadgeVariant.outline, child: const Text('get_it')),
                ],
              ),
              const SizedBox(height: 32),

              // ── Feature cards ─────────────────────────────────────────────

              // Config — Laravel-style config registry
              _FeatureCard(
                icon: LucideIcons.settings2,
                title: 'Config',
                subtitle: 'Laravel-style config system. Browse all loaded sections and key/value pairs.',
                onTap: () => _push(context, const ConfigExplorerPage()),
              ),
              const SizedBox(height: 12),

              // Container — IoC container backed by get_it
              _FeatureCard(
                icon: LucideIcons.package,
                title: 'Container',
                subtitle: 'IoC container backed by get_it. bind(), singleton(), make() demo.',
                onTap: () => _push(context, const ContainerExplorerPage()),
              ),
              const SizedBox(height: 12),

              // Theme — live Forui theme switcher
              _FeatureCard(
                icon: LucideIcons.palette,
                title: 'Theme',
                subtitle: 'Live theme switcher. Base palette, brightness, typography, and status colors.',
                onTap: () => _push(context, const ThemeExplorerPage()),
              ),
              const SizedBox(height: 12),

              // Auth — authentication configuration
              _FeatureCard(
                icon: LucideIcons.shieldCheck,
                title: 'Auth',
                subtitle: 'JWT / OAuth2 config. Token storage, session timeout, biometrics.',
                onTap: () => _push(context, const AuthExplorerPage()),
              ),
              const SizedBox(height: 12),

              // API Client — HTTP client configuration + test request
              _FeatureCard(
                icon: LucideIcons.globe,
                title: 'API Client',
                subtitle: 'HTTP config with retry, timeouts, cert pinning, and a live test request.',
                onTap: () => _push(context, const ApiExplorerPage()),
              ),
              const SizedBox(height: 12),

              // Storage — local storage configuration + key/value demo
              _FeatureCard(
                icon: LucideIcons.database,
                title: 'Storage',
                subtitle: 'SharedPreferences with key prefix, cache policy, and SQLite config.',
                onTap: () => _push(context, const StorageExplorerPage()),
              ),
              const SizedBox(height: 12),

              // Feature Flags — toggle flags at runtime
              _FeatureCard(
                icon: LucideIcons.flag,
                title: 'Feature Flags',
                subtitle: 'Static flags with runtime debug overrides and remote provider config.',
                onTap: () => _push(context, const FeatureFlagsExplorerPage()),
              ),
              const SizedBox(height: 12),

              // Analytics — provider config + test event firing
              _FeatureCard(
                icon: LucideIcons.activity,
                title: 'Analytics',
                subtitle: 'Multi-provider analytics with PII scrubbing, sampling, and test events.',
                onTap: () => _push(context, const AnalyticsExplorerPage()),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Pushes [page] onto the navigation stack.
  void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

// ── Feature card ──────────────────────────────────────────────────────────────

/// A tappable card that navigates to a feature explorer page.
///
/// All cards are now "ready" — the [onTap] callback is always provided.
class _FeatureCard extends StatelessWidget {
  /// Creates a [_FeatureCard].
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  /// The icon displayed in the leading bubble.
  final IconData icon;

  /// The card title.
  final String title;

  /// The card subtitle / description.
  final String subtitle;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FTappable(
      onPress: onTap,
      child: FCard(
        child: Row(
          children: [
            // Icon bubble
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, size: 20, color: theme.colors.primary),
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: theme.typography.md.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colors.foreground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FBadge(child: const Text('Ready')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                  ),
                ],
              ),
            ),

            // Arrow
            const SizedBox(width: 8),
            Icon(LucideIcons.chevronRight, size: 16, color: theme.colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
