// ignore_for_file: lines_longer_than_80_chars
//
// explorer_scaffold.dart
//
// Shared scaffold used by all feature explorer pages.
// Provides a consistent FHeader.nested with back button, optional
// action buttons, and a scrollable body with max-width constraint.

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A reusable scaffold for all feature explorer pages.
///
/// Wraps [FScaffold] with a [FHeader.nested] back button, optional
/// trailing [actions], and a constrained scrollable [body].
///
/// Usage:
/// ```dart
/// ExplorerScaffold(
///   title: 'Container',
///   body: Column(children: [...]),
/// )
/// ```
class ExplorerScaffold extends StatelessWidget {
  /// Creates an [ExplorerScaffold].
  const ExplorerScaffold({
    required this.title,
    required this.body,
    this.actions = const [],
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 32),
    super.key,
  });

  /// The page title shown in the header.
  final String title;

  /// The main content of the page.
  final Widget body;

  /// Optional trailing action widgets in the header (e.g. refresh button).
  final List<Widget> actions;

  /// Padding applied around [body]. Defaults to 16px sides, 32px bottom.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text(title),
        prefixes: [
          FHeaderAction(
            icon: const Icon(FIcons.arrowLeft),
            onPress: () => Navigator.pop(context),
          ),
        ],
        suffixes: actions,
      ),
      child: SingleChildScrollView(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: body,
          ),
        ),
      ),
    );
  }
}

// ── Shared info row ───────────────────────────────────────────────────────────

/// A single key/value info row used across all explorer pages.
///
/// Displays [label] on the left and [value] on the right with
/// semantic color coding (green=true, red=false, blue=number).
class InfoRow extends StatelessWidget {
  /// Creates an [InfoRow].
  const InfoRow({
    required this.label,
    required this.value,
    this.monospace = false,
    super.key,
  });

  /// The label displayed on the left.
  final String label;

  /// The value displayed on the right.
  final String value;

  /// Whether to render [value] in a monospace font.
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: theme.typography.xs.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Value
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: theme.typography.xs.copyWith(
                color: _valueColor(value, theme),
                fontFamily: monospace ? 'monospace' : null,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a semantic color based on the value string.
  Color _valueColor(String v, FThemeData theme) {
    if (v == 'true') return const Color(0xFF22C55E);
    if (v == 'false') return const Color(0xFFEF4444);
    if (v == 'null' || v.isEmpty) return theme.colors.mutedForeground;
    if (int.tryParse(v) != null || double.tryParse(v) != null) {
      return const Color(0xFF3B82F6);
    }
    return theme.colors.foreground;
  }
}

// ── Shared section card ───────────────────────────────────────────────────────

/// A titled card section used across all explorer pages.
///
/// Wraps [FCard] with a consistent icon + title header and
/// a list of [children] rows.
class SectionCard extends StatelessWidget {
  /// Creates a [SectionCard].
  const SectionCard({
    required this.icon,
    required this.title,
    required this.children,
    super.key,
  });

  /// The icon displayed next to the title.
  final IconData icon;

  /// The section title.
  final String title;

  /// The content rows inside the card.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FCard(
      title: Row(
        children: [
          Icon(icon, size: 15, color: theme.colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: theme.typography.md.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          ...children,
        ],
      ),
    );
  }
}

// ── Status indicator ──────────────────────────────────────────────────────────

/// A small colored dot + label indicating an enabled/disabled state.
class StatusIndicator extends StatelessWidget {
  /// Creates a [StatusIndicator].
  const StatusIndicator({
    required this.label,
    required this.enabled,
    super.key,
  });

  /// The label text.
  final String label;

  /// Whether the indicator shows enabled (green) or disabled (red).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final color = enabled ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.typography.xs.copyWith(color: theme.colors.foreground),
        ),
      ],
    );
  }
}
