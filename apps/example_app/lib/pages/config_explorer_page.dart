// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:config/pixielity_config.dart';
import 'package:ui/pixielity_ui.dart';

/// Config Explorer — displays every loaded config section and its key/value
/// pairs. Useful for verifying dart-define values at runtime in development.
class ConfigExplorerPage extends StatefulWidget {
  /// Creates the [ConfigExplorerPage].
  const ConfigExplorerPage({super.key});

  @override
  State<ConfigExplorerPage> createState() => _ConfigExplorerPageState();
}

class _ConfigExplorerPageState extends State<ConfigExplorerPage> {
  final _controller = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _search = _controller.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final sections = Config.sections;

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Config Explorer'),
        prefixes: [
          FHeaderAction(
            icon: const Icon(FIcons.arrowLeft),
            onPress: () => Navigator.pop(context),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: AppSearchBar(
              hint: 'Search keys...',
              controller: _controller,
            ),
          ),

          // ── Stats row ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(LucideIcons.layers, size: 14, color: theme.colors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  '${sections.length} sections',
                  style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                ),
                const SizedBox(width: 16),
                Icon(LucideIcons.keyRound, size: 14, color: theme.colors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  '${_totalKeys(sections)} keys',
                  style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                ),
              ],
            ),
          ),

          // ── Section list ─────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              itemCount: sections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final sectionName = sections[i];
                final entries = _filteredEntries(sectionName);
                if (entries.isEmpty) return const SizedBox.shrink();
                return _SectionCard(sectionName: sectionName, entries: entries);
              },
            ),
          ),
        ],
      ),
    );
  }

  int _totalKeys(List<String> sections) {
    return sections.fold(0, (sum, s) => sum + _flatten(Config.section(s), prefix: '').length);
  }

  List<_Entry> _filteredEntries(String sectionName) {
    final flat = _flatten(Config.section(sectionName), prefix: '');
    if (_search.isEmpty) return flat;
    return flat.where((e) => e.key.contains(_search) || e.value.toLowerCase().contains(_search)).toList();
  }

  List<_Entry> _flatten(Map<String, dynamic> map, {required String prefix}) {
    final result = <_Entry>[];
    for (final entry in map.entries) {
      final fullKey = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        result.addAll(_flatten(value, prefix: fullKey));
      } else {
        result.add(_Entry(key: fullKey, value: _format(value)));
      }
    }
    return result;
  }

  String _format(dynamic value) {
    if (value == null) return 'null';
    if (value is List) return '[${value.join(', ')}]';
    return value.toString();
  }
}

// ── Section card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.sectionName, required this.entries});

  final String sectionName;
  final List<_Entry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FCard(
      title: Row(
        children: [
          Icon(_iconFor(sectionName), size: 15, color: theme.colors.primary),
          const SizedBox(width: 8),
          Text(
            sectionName,
            style: theme.typography.md.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          FBadge(variant: FBadgeVariant.secondary, child: Text('${entries.length}')),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          ...entries.map((e) => _EntryRow(entry: e, sectionName: sectionName)),
        ],
      ),
    );
  }

  IconData _iconFor(String section) => switch (section) {
    'app'           => LucideIcons.smartphone,
    'api'           => LucideIcons.globe,
    'auth'          => LucideIcons.shieldCheck,
    'theme'         => LucideIcons.palette,
    'storage'       => LucideIcons.database,
    'analytics'     => LucideIcons.activity,
    'logging'       => LucideIcons.fileText,
    'feature_flags' => LucideIcons.flag,
    _               => LucideIcons.settings2,
  };
}

// ── Entry row ─────────────────────────────────────────────────────────────────

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, required this.sectionName});

  final _Entry entry;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: entry.value));
        FToaster.of(context).show(
          builder: (_, __) => FToast(
            icon: const Icon(FIcons.circleCheck),
            title: Text('Copied: $sectionName.${entry.key}'),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key
            Expanded(
              flex: 4,
              child: Text(
                entry.key,
                style: theme.typography.xs.copyWith(
                  color: theme.colors.mutedForeground,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Value
            Expanded(
              flex: 5,
              child: Text(
                entry.value,
                style: theme.typography.xs.copyWith(
                  color: _colorFor(entry.value, theme),
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFor(String value, FThemeData theme) {
    if (value == 'true') return const Color(0xFF22C55E);
    if (value == 'false') return const Color(0xFFEF4444);
    if (value == 'null' || value.isEmpty) return theme.colors.mutedForeground;
    if (int.tryParse(value) != null || double.tryParse(value) != null) {
      return const Color(0xFF3B82F6);
    }
    return theme.colors.foreground;
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Entry {
  const _Entry({required this.key, required this.value});
  final String key;
  final String value;
}
