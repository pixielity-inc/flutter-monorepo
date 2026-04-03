// ignore_for_file: lines_longer_than_80_chars
//
// storage_explorer_page.dart
//
// Displays the full storage configuration and provides a live key/value
// demo using Flutter's in-memory Map (simulating SharedPreferences with
// the configured key prefix). Shows cache policy and database settings.

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_config/pixielity_config.dart';
import 'package:pixielity_example_app/pages/shared/explorer_scaffold.dart';

/// Storage Explorer — displays the full local storage configuration.
///
/// Shows:
///   - Key prefix and namespacing demo
///   - Encryption settings per environment
///   - Cache policy (max size, TTL, eviction strategy)
///   - Database configuration (name, schema version, WAL, encryption)
///   - Live key/value write/read demo using the configured prefix
class StorageExplorerPage extends StatefulWidget {
  /// Creates the [StorageExplorerPage].
  const StorageExplorerPage({super.key});

  @override
  State<StorageExplorerPage> createState() => _StorageExplorerPageState();
}

class _StorageExplorerPageState extends State<StorageExplorerPage> {
  // ── State ──────────────────────────────────────────────────────────────────

  /// In-memory store simulating SharedPreferences with the key prefix applied.
  final Map<String, String> _store = {};

  /// Controller for the key input field.
  final _keyController = TextEditingController();

  /// Controller for the value input field.
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns the full namespaced key: `"$prefix.$key"`.
  String _namespacedKey(String key) {
    final prefix = Config.get<String>('storage.keyPrefix', fallback: 'pixielity');
    return '$prefix.$key';
  }

  /// Writes a key/value pair to the in-memory store.
  void _write() {
    final key   = _keyController.text.trim();
    final value = _valueController.text.trim();
    if (key.isEmpty) return;

    setState(() {
      _store[_namespacedKey(key)] = value;
    });

    FToaster.of(context).show(
      builder: (_, __) => FToast(
        icon: const Icon(FIcons.circleCheck),
        title: Text('Written: ${_namespacedKey(key)}'),
      ),
    );
  }

  /// Removes a key from the in-memory store.
  void _delete(String key) {
    setState(() => _store.remove(key));
  }

  /// Clears all entries from the in-memory store.
  void _clearAll() {
    setState(_store.clear);
    FToaster.of(context).show(
      builder: (_, __) => const FToast(
        icon: Icon(FIcons.circleCheck),
        title: Text('All keys cleared'),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Read all storage config values from the registry.
    final keyPrefix          = Config.get<String>('storage.keyPrefix',              fallback: 'pixielity');
    final encryptPrefs       = Config.get<bool>('storage.encryptSharedPreferences', fallback: false);
    final clearOnLogout      = Config.get<bool>('storage.clearOnLogout',            fallback: true);
    final clearOnReinstall   = Config.get<bool>('storage.clearOnReinstall',         fallback: true);
    final cacheMaxMb         = Config.get<int>('storage.cache.maxSizeMb',           fallback: 50);
    final cacheTtlHours      = Config.get<int>('storage.cache.ttlHours',            fallback: 24);
    final cacheEviction      = Config.get<String>('storage.cache.evictionStrategy', fallback: 'lru');
    final cacheDisk          = Config.get<bool>('storage.cache.enableDisk',         fallback: true);
    final cacheMemory        = Config.get<bool>('storage.cache.enableMemory',       fallback: true);
    final dbName             = Config.get<String>('storage.database.name',          fallback: 'pixielity.db');
    final dbVersion          = Config.get<int>('storage.database.schemaVersion',    fallback: 1);
    final dbForeignKeys      = Config.get<bool>('storage.database.enableForeignKeys', fallback: true);
    final dbWal              = Config.get<bool>('storage.database.enableWal',       fallback: true);
    final dbEncrypt          = Config.get<bool>('storage.database.encrypt',         fallback: false);

    return ExplorerScaffold(
      title: 'Storage',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Key prefix ────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.keyRound,
            title: 'Key Namespace',
            children: [
              InfoRow(label: 'storage.keyPrefix', value: keyPrefix, monospace: true),
              const SizedBox(height: 4),
              Text(
                'All SharedPreferences keys are prefixed with "$keyPrefix." to avoid collisions. '
                'Example: "$keyPrefix.theme", "$keyPrefix.user_id".',
                style: FTheme.of(context).typography.xs.copyWith(
                  color: FTheme.of(context).colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Security ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.lock,
            title: 'Security',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusIndicator(label: 'Encrypt SharedPrefs', enabled: encryptPrefs),
                    StatusIndicator(label: 'Clear on logout',     enabled: clearOnLogout),
                    StatusIndicator(label: 'Clear on reinstall',  enabled: clearOnReinstall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Cache ─────────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.hardDrive,
            title: 'Cache Policy',
            children: [
              InfoRow(label: 'storage.cache.maxSizeMb',         value: '$cacheMaxMb MB'),
              InfoRow(label: 'storage.cache.ttlHours',          value: '${cacheTtlHours}h'),
              InfoRow(label: 'storage.cache.evictionStrategy',  value: cacheEviction),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    StatusIndicator(label: 'Disk cache',   enabled: cacheDisk),
                    const SizedBox(width: 16),
                    StatusIndicator(label: 'Memory cache', enabled: cacheMemory),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Database ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.database,
            title: 'Database (SQLite / Drift)',
            children: [
              InfoRow(label: 'storage.database.name',          value: dbName,              monospace: true),
              InfoRow(label: 'storage.database.schemaVersion', value: 'v$dbVersion'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    StatusIndicator(label: 'Foreign keys', enabled: dbForeignKeys),
                    const SizedBox(width: 16),
                    StatusIndicator(label: 'WAL mode',     enabled: dbWal),
                    const SizedBox(width: 16),
                    StatusIndicator(label: 'Encrypted',    enabled: dbEncrypt),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Live key/value demo ───────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.pencil,
            title: 'Key/Value Demo',
            children: [
              Text(
                'Simulates SharedPreferences with the "$keyPrefix." prefix applied. '
                'Keys are namespaced automatically.',
                style: FTheme.of(context).typography.xs.copyWith(
                  color: FTheme.of(context).colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              FTextField(
                control: FTextFieldControl.managed(controller: _keyController),
                label: const Text('Key'),
                hint: 'e.g. theme, user_id',
              ),
              const SizedBox(height: 8),
              FTextField(
                control: FTextFieldControl.managed(controller: _valueController),
                label: const Text('Value'),
                hint: 'e.g. dark, 42',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FButton(
                      onPress: _write,
                      prefix: const Icon(LucideIcons.save),
                      child: const Text('Write'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FButton(
                    variant: FButtonVariant.outline,
                    onPress: _store.isEmpty ? null : _clearAll,
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              if (_store.isNotEmpty) ...[
                const SizedBox(height: 12),
                const FDivider(),
                const SizedBox(height: 8),
                ..._store.entries.map(
                  (e) => _StoreRow(
                    fullKey: e.key,
                    value: e.value,
                    onDelete: () => _delete(e.key),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Store row ─────────────────────────────────────────────────────────────────

class _StoreRow extends StatelessWidget {
  const _StoreRow({
    required this.fullKey,
    required this.value,
    required this.onDelete,
  });

  final String fullKey;
  final String value;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullKey,
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.mutedForeground,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  value,
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.foreground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          FButton(
            variant: FButtonVariant.outline,
            onPress: onDelete,
            child: const Icon(LucideIcons.trash2, size: 14),
          ),
        ],
      ),
    );
  }
}
