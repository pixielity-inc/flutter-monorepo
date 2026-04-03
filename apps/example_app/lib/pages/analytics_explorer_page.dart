// ignore_for_file: lines_longer_than_80_chars
//
// analytics_explorer_page.dart
//
// Displays the full analytics configuration and lets the user fire
// simulated analytics events. Shows provider status, sampling rate,
// PII scrubbing, and a live event log.

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_config/pixielity_config.dart';
import 'package:pixielity_example_app/pages/shared/explorer_scaffold.dart';

/// A simulated analytics event.
class _AnalyticsEvent {
  const _AnalyticsEvent({
    required this.name,
    required this.properties,
    required this.timestamp,
    required this.wasSent,
    this.scrubbed = false,
  });

  /// The event name (e.g. 'button_tapped').
  final String name;

  /// The event properties map.
  final Map<String, String> properties;

  /// When the event was fired.
  final DateTime timestamp;

  /// Whether the event was actually sent (analytics enabled + sampling).
  final bool wasSent;

  /// Whether PII was scrubbed from the properties.
  final bool scrubbed;
}

/// Analytics Explorer — displays analytics config and fires test events.
///
/// Shows:
///   - Master switches (analytics enabled, crash reporting)
///   - Sampling rate with visual indicator
///   - PII scrubbing configuration and demo
///   - All provider statuses (Firebase, Mixpanel, Amplitude, etc.)
///   - Crash reporting providers (Sentry, Crashlytics)
///   - Live event log with send/drop/scrub indicators
class AnalyticsExplorerPage extends StatefulWidget {
  /// Creates the [AnalyticsExplorerPage].
  const AnalyticsExplorerPage({super.key});

  @override
  State<AnalyticsExplorerPage> createState() => _AnalyticsExplorerPageState();
}

class _AnalyticsExplorerPageState extends State<AnalyticsExplorerPage> {
  // ── State ──────────────────────────────────────────────────────────────────

  /// Log of all simulated analytics events fired during this session.
  final List<_AnalyticsEvent> _eventLog = [];

  // ── Event firing ──────────────────────────────────────────────────────────

  /// Fires a simulated analytics event.
  ///
  /// Applies the configured sampling rate to decide whether the event
  /// is "sent" or "dropped". If PII scrubbing is enabled, any property
  /// whose key matches a PII field is replaced with '[REDACTED]'.
  void _fireEvent(String name, Map<String, String> properties) {
    final analyticsEnabled = Config.get<bool>('analytics.enabled',     fallback: false);
    final samplingRate     = Config.get<double>('analytics.samplingRate', fallback: 0.1);
    final scrubPii         = Config.get<bool>('analytics.scrubPii',    fallback: true);
    final piiFields        = Config.get<String>('analytics.piiFields', fallback: 'email,phone,name,address,ip_address')
        .split(',')
        .map((f) => f.trim())
        .toSet();

    // Determine if this event passes the sampling filter.
    // In a real implementation this would use a deterministic hash of the
    // user ID so the same user is always in or out of the sample.
    final passedSampling = analyticsEnabled && (samplingRate >= 1.0 || _pseudoRandom() < samplingRate);

    // Apply PII scrubbing if enabled.
    final finalProperties = Map<String, String>.from(properties);
    var scrubbed = false;
    if (scrubPii) {
      for (final key in piiFields) {
        if (finalProperties.containsKey(key)) {
          finalProperties[key] = '[REDACTED]';
          scrubbed = true;
        }
      }
    }

    setState(() {
      _eventLog.insert(
        0,
        _AnalyticsEvent(
          name: name,
          properties: finalProperties,
          timestamp: DateTime.now(),
          wasSent: passedSampling,
          scrubbed: scrubbed,
        ),
      );
    });

    FToaster.of(context).show(
      builder: (_, __) => FToast(
        icon: Icon(passedSampling ? FIcons.circleCheck : FIcons.circleAlert),
        title: Text(passedSampling ? 'Event sent: $name' : 'Event dropped (sampling)'),
      ),
    );
  }

  /// Returns a pseudo-random value between 0 and 1 for sampling simulation.
  double _pseudoRandom() => DateTime.now().millisecondsSinceEpoch % 100 / 100.0;

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    // Read all analytics config values from the registry.
    final enabled          = Config.get<bool>('analytics.enabled',              fallback: false);
    final crashEnabled     = Config.get<bool>('analytics.crashReportingEnabled', fallback: false);
    final screenTracking   = Config.get<bool>('analytics.screenTrackingEnabled', fallback: false);
    final samplingRate     = Config.get<double>('analytics.samplingRate',        fallback: 0.1);
    final scrubPii         = Config.get<bool>('analytics.scrubPii',             fallback: true);
    final sessionTimeout   = Config.get<int>('analytics.sessionTimeoutMinutes', fallback: 30);

    // Provider statuses.
    final firebase   = Config.get<bool>('analytics.providers.firebaseAnalytics', fallback: false);
    final mixpanel   = Config.get<bool>('analytics.providers.mixpanel',          fallback: false);
    final amplitude  = Config.get<bool>('analytics.providers.amplitude',         fallback: false);
    final segment    = Config.get<bool>('analytics.providers.segment',           fallback: false);
    final posthog    = Config.get<bool>('analytics.providers.posthog',           fallback: false);
    final sentry     = Config.get<bool>('analytics.crash.sentry',                fallback: false);
    final crashlytics = Config.get<bool>('analytics.crash.firebaseCrashlytics',  fallback: false);

    return ExplorerScaffold(
      title: 'Analytics',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Master switches ───────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.activity,
            title: 'Master Switches',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusIndicator(label: 'Analytics',       enabled: enabled),
                    StatusIndicator(label: 'Crash reporting', enabled: crashEnabled),
                    StatusIndicator(label: 'Screen tracking', enabled: screenTracking),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Sampling rate ─────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.percent,
            title: 'Sampling Rate',
            children: [
              InfoRow(
                label: 'analytics.samplingRate',
                value: '${(samplingRate * 100).toStringAsFixed(0)}% of sessions',
              ),
              const SizedBox(height: 8),
              // Visual sampling bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: samplingRate,
                        backgroundColor: theme.colors.muted,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colors.primary),
                        minHeight: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(samplingRate * 100).toStringAsFixed(0)}%',
                    style: theme.typography.sm.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              InfoRow(label: 'analytics.sessionTimeoutMinutes', value: '${sessionTimeout}m'),
            ],
          ),
          const SizedBox(height: 16),

          // ── PII scrubbing ─────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.eyeOff,
            title: 'PII Scrubbing',
            children: [
              InfoRow(label: 'analytics.scrubPii', value: scrubPii.toString()),
              const SizedBox(height: 4),
              Text(
                'The following property names are considered PII and will be '
                'replaced with [REDACTED] before events are sent:',
                style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ['email', 'phone', 'name', 'address', 'ip_address']
                    .map((f) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.colors.muted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            f,
                            style: theme.typography.xs.copyWith(fontFamily: 'monospace'),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Providers ─────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.plugZap,
            title: 'Analytics Providers',
            children: [
              StatusIndicator(label: 'Firebase Analytics', enabled: firebase),
              const SizedBox(height: 6),
              StatusIndicator(label: 'Mixpanel',           enabled: mixpanel),
              const SizedBox(height: 6),
              StatusIndicator(label: 'Amplitude',          enabled: amplitude),
              const SizedBox(height: 6),
              StatusIndicator(label: 'Segment',            enabled: segment),
              const SizedBox(height: 6),
              StatusIndicator(label: 'PostHog',            enabled: posthog),
            ],
          ),
          const SizedBox(height: 16),

          // ── Crash reporting ───────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.bug,
            title: 'Crash Reporting',
            children: [
              StatusIndicator(label: 'Sentry',                enabled: sentry),
              const SizedBox(height: 6),
              StatusIndicator(label: 'Firebase Crashlytics',  enabled: crashlytics),
            ],
          ),
          const SizedBox(height: 16),

          // ── Test events ───────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.send,
            title: 'Fire Test Events',
            children: [
              Text(
                'Tap a button to simulate firing an analytics event. '
                'The event log below shows whether it was sent or dropped '
                'based on the sampling rate, and whether PII was scrubbed.',
                style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FButton(
                    onPress: () => _fireEvent('button_tapped', {'button_id': 'cta_primary', 'screen': 'home'}),
                    child: const Text('button_tapped'),
                  ),
                  FButton(
                    variant: FButtonVariant.secondary,
                    onPress: () => _fireEvent('screen_viewed', {'screen': 'analytics_explorer', 'user_id': '42'}),
                    child: const Text('screen_viewed'),
                  ),
                  FButton(
                    variant: FButtonVariant.outline,
                    onPress: () => _fireEvent('user_signed_in', {
                      'method': 'jwt',
                      'email': 'user@example.com',  // PII — will be scrubbed
                      'name': 'John Doe',            // PII — will be scrubbed
                    }),
                    child: const Text('user_signed_in (PII)'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Event log ─────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.scrollText,
            title: 'Event Log',
            children: [
              if (_eventLog.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No events fired yet. Tap the buttons above.',
                    style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                  ),
                )
              else
                ..._eventLog.map((e) => _EventLogRow(event: e)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Event log row ─────────────────────────────────────────────────────────────

class _EventLogRow extends StatelessWidget {
  const _EventLogRow({required this.event});

  final _AnalyticsEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    const sentColor    = Color(0xFF22C55E);
    const droppedColor = Color(0xFFEF4444);
    const scrubColor   = Color(0xFFF59E0B);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Sent / dropped indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (event.wasSent ? sentColor : droppedColor).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.wasSent ? 'SENT' : 'DROPPED',
                  style: theme.typography.xs.copyWith(
                    color: event.wasSent ? sentColor : droppedColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              if (event.scrubbed) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: scrubColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'PII SCRUBBED',
                    style: theme.typography.xs.copyWith(
                      color: scrubColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.name,
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.foreground,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${event.timestamp.hour.toString().padLeft(2, '0')}:'
                '${event.timestamp.minute.toString().padLeft(2, '0')}:'
                '${event.timestamp.second.toString().padLeft(2, '0')}',
                style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
              ),
            ],
          ),
          // Properties
          if (event.properties.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 4),
              child: Text(
                event.properties.entries.map((e) => '${e.key}: ${e.value}').join(' · '),
                style: theme.typography.xs.copyWith(
                  color: theme.colors.mutedForeground,
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
