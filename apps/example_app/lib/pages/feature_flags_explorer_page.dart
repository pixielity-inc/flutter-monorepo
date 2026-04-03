// ignore_for_file: lines_longer_than_80_chars
//
// feature_flags_explorer_page.dart
//
// Displays all feature flags from config/feature_flags.dart and allows
// runtime toggling via debug overrides (stored in an in-memory map that
// simulates SharedPreferences). Shows remote provider configuration.

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_config/pixielity_config.dart';
import 'package:pixielity_example_app/pages/shared/explorer_scaffold.dart';

/// Feature Flags Explorer — displays and toggles feature flags at runtime.
///
/// Shows:
///   - All static flags from config/feature_flags.dart with their values
///   - Runtime toggle switches (debug overrides) for each flag
///   - Visual diff between config value and runtime override
///   - Remote provider configuration
///   - Flag evaluation result (config OR override)
class FeatureFlagsExplorerPage extends StatefulWidget {
  /// Creates the [FeatureFlagsExplorerPage].
  const FeatureFlagsExplorerPage({super.key});

  @override
  State<FeatureFlagsExplorerPage> createState() => _FeatureFlagsExplorerPageState();
}

class _FeatureFlagsExplorerPageState extends State<FeatureFlagsExplorerPage> {
  // ── State ──────────────────────────────────────────────────────────────────

  /// Runtime overrides — simulates the debug override store.
  ///
  /// When a flag is overridden here, it takes precedence over the
  /// static config value. This mirrors how a real debug override
  /// system would work (e.g. using SharedPreferences).
  final Map<String, bool> _overrides = {};

  /// The list of static flag names read from config.
  static const List<String> _flagKeys = [
    'new_onboarding',
    'ai_assistant',
    'premium_themes',
    'new_dashboard',
    'offline_mode',
  ];

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns the effective value for [flag] — override takes precedence.
  bool _effectiveValue(String flag) {
    if (_overrides.containsKey(flag)) return _overrides[flag]!;
    return Config.get<bool>('feature_flags.$flag', fallback: false);
  }

  /// Returns the static config value for [flag].
  bool _configValue(String flag) =>
      Config.get<bool>('feature_flags.$flag', fallback: false);

  /// Returns true if [flag] has an active runtime override.
  bool _hasOverride(String flag) => _overrides.containsKey(flag);

  /// Toggles the runtime override for [flag].
  void _toggleOverride(String flag, bool value) {
    setState(() => _overrides[flag] = value);
  }

  /// Clears the runtime override for [flag], reverting to config value.
  void _clearOverride(String flag) {
    setState(() => _overrides.remove(flag));
  }

  /// Clears all runtime overrides.
  void _clearAllOverrides() {
    setState(_overrides.clear);
    FToaster.of(context).show(
      builder: (_, __) => const FToast(
        icon: Icon(FIcons.circleCheck),
        title: Text('All overrides cleared'),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final debugOverridesEnabled = Config.get<bool>('feature_flags.enableDebugOverrides', fallback: true);
    final remoteProvider        = Config.get<String>('feature_flags.remote.provider',    fallback: 'none');
    final fetchInterval         = Config.get<int>('feature_flags.remote.fetchIntervalMinutes', fallback: 5);
    final enableStreaming        = Config.get<bool>('feature_flags.remote.enableStreaming', fallback: false);

    return ExplorerScaffold(
      title: 'Feature Flags',
      actions: [
        if (_overrides.isNotEmpty)
          FHeaderAction(
            icon: const Icon(LucideIcons.rotateCcw),
            onPress: _clearAllOverrides,
          ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Overview ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.flag,
            title: 'Overview',
            children: [
              InfoRow(label: 'Total flags',          value: '${_flagKeys.length}'),
              InfoRow(label: 'Active overrides',     value: '${_overrides.length}'),
              InfoRow(label: 'Debug overrides',      value: debugOverridesEnabled.toString()),
              InfoRow(label: 'Remote provider',      value: remoteProvider),
            ],
          ),
          const SizedBox(height: 16),

          // ── Flag toggles ──────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.toggleRight,
            title: 'Flags',
            children: [
              if (!debugOverridesEnabled)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: FAlert(
                    title: Text('Debug overrides disabled'),
                    subtitle: Text('Set feature_flags.enableDebugOverrides=true to toggle flags at runtime.'),
                  ),
                )
              else
                ..._flagKeys.map(
                  (flag) => _FlagRow(
                    flagKey: flag,
                    configValue: _configValue(flag),
                    effectiveValue: _effectiveValue(flag),
                    hasOverride: _hasOverride(flag),
                    onToggle: (v) => _toggleOverride(flag, v),
                    onClearOverride: () => _clearOverride(flag),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Remote provider ───────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.cloud,
            title: 'Remote Provider',
            children: [
              InfoRow(label: 'feature_flags.remote.provider',             value: remoteProvider),
              InfoRow(label: 'feature_flags.remote.fetchIntervalMinutes', value: '${fetchInterval}m'),
              InfoRow(label: 'feature_flags.remote.enableStreaming',      value: enableStreaming.toString()),
              if (remoteProvider == 'none')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'No remote provider configured. Static flags only. '
                    'Set FLAGS_REMOTE_PROVIDER to enable remote flag fetching.',
                    style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Evaluation legend ─────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.info,
            title: 'Evaluation Order',
            children: [
              Text(
                'Flags are evaluated in this priority order:\n'
                '1. Runtime debug override (highest priority)\n'
                '2. Remote provider value (after first fetch)\n'
                '3. Static config value (fail-closed default)',
                style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Flag row ──────────────────────────────────────────────────────────────────

/// A single feature flag row with toggle and override indicator.
class _FlagRow extends StatelessWidget {
  const _FlagRow({
    required this.flagKey,
    required this.configValue,
    required this.effectiveValue,
    required this.hasOverride,
    required this.onToggle,
    required this.onClearOverride,
  });

  /// The flag key name (e.g. 'new_onboarding').
  final String flagKey;

  /// The static value from config/feature_flags.dart.
  final bool configValue;

  /// The effective value after applying any runtime override.
  final bool effectiveValue;

  /// Whether this flag has an active runtime override.
  final bool hasOverride;

  /// Called when the toggle switch is changed.
  final ValueChanged<bool> onToggle;

  /// Called when the override is cleared.
  final VoidCallback onClearOverride;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Flag name + config value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      flagKey,
                      style: theme.typography.sm.copyWith(
                        color: theme.colors.foreground,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (hasOverride) ...[
                      const SizedBox(width: 6),
                      // Override badge — shows the config value was overridden.
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'override',
                          style: theme.typography.xs.copyWith(
                            color: const Color(0xFFF59E0B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'config: $configValue${hasOverride ? ' → overridden: $effectiveValue' : ''}',
                  style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                ),
              ],
            ),
          ),

          // Clear override button (only shown when overridden)
          if (hasOverride) ...[
            FButton(
              variant: FButtonVariant.outline,
              onPress: onClearOverride,
              child: const Icon(LucideIcons.x, size: 12),
            ),
            const SizedBox(width: 8),
          ],

          // Toggle switch
          FSwitch(
            value: effectiveValue,
            onChange: onToggle,
          ),
        ],
      ),
    );
  }
}
