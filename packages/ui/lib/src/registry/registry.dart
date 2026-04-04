// ignore_for_file: lines_longer_than_80_chars
// lib/src/registry/registry.dart
//
// Registry<K, V> — a generic, type-safe key/value registry.
//
// Used as the base for ThemeRegistry and any other named-value store.
// All operations are synchronous and in-memory.
//
// Usage:
//   final registry = Registry<String, MyService>();
//   registry.add('default', MyService());
//   final svc = registry.get('default');
//   registry.has('default'); // true
//   registry.remove('default');
//   registry.all;            // Map<String, MyService>

import 'package:flutter/foundation.dart';

/// A generic, type-safe in-memory registry.
///
/// Maps keys of type [K] to values of type [V]. Useful for named registrations
/// such as custom themes, service instances, or feature providers.
///
/// ```dart
/// final registry = Registry<String, Widget Function()>();
/// registry.add('home', () => const HomePage());
/// final builder = registry.get('home');
/// ```
class Registry<K, V> {
  /// Creates an empty [Registry].
  Registry();

  final Map<K, V> _store = {};

  // ── Write ─────────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | add
  |--------------------------------------------------------------------------
  |
  | Registers [value] under [key]. Throws [StateError] if [key] is already
  | registered. Use [set] to overwrite an existing entry.
  |
  */

  /// Registers [value] under [key].
  ///
  /// Throws [StateError] if [key] is already registered.
  /// Use [set] to overwrite an existing entry without throwing.
  void add(K key, V value) {
    if (_store.containsKey(key)) {
      throw StateError(
        'Registry: key "$key" is already registered. '
        'Use set() to overwrite it.',
      );
    }
    _store[key] = value;
  }

  /*
  |--------------------------------------------------------------------------
  | set
  |--------------------------------------------------------------------------
  |
  | Registers or overwrites [value] under [key]. Unlike [add], this never
  | throws — it silently replaces any existing entry.
  |
  */

  /// Registers or overwrites [value] under [key].
  void set(K key, V value) => _store[key] = value;

  /*
  |--------------------------------------------------------------------------
  | remove
  |--------------------------------------------------------------------------
  |
  | Removes the entry for [key]. Returns the removed value, or null if
  | [key] was not registered.
  |
  */

  /// Removes and returns the entry for [key], or null if not found.
  V? remove(K key) => _store.remove(key);

  /*
  |--------------------------------------------------------------------------
  | clear
  |--------------------------------------------------------------------------
  |
  | Removes all entries from the registry.
  |
  */

  /// Removes all entries.
  void clear() => _store.clear();

  // ── Read ──────────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | get
  |--------------------------------------------------------------------------
  |
  | Returns the value registered under [key].
  | Throws [StateError] if [key] is not registered.
  | Use [tryGet] for a null-safe alternative.
  |
  */

  /// Returns the value for [key].
  ///
  /// Throws [StateError] if [key] is not registered.
  V get(K key) {
    final value = _store[key];
    if (value == null && !_store.containsKey(key)) {
      throw StateError(
        'Registry: key "$key" is not registered. '
        'Available keys: ${_store.keys.join(', ')}',
      );
    }
    return value as V;
  }

  /*
  |--------------------------------------------------------------------------
  | tryGet
  |--------------------------------------------------------------------------
  |
  | Returns the value for [key], or null if not registered.
  |
  */

  /// Returns the value for [key], or null if not registered.
  V? tryGet(K key) => _store[key];

  /*
  |--------------------------------------------------------------------------
  | has
  |--------------------------------------------------------------------------
  |
  | Returns true if [key] is registered.
  |
  */

  /// Returns `true` if [key] is registered.
  bool has(K key) => _store.containsKey(key);

  /*
  |--------------------------------------------------------------------------
  | all
  |--------------------------------------------------------------------------
  |
  | Returns an unmodifiable view of all registered entries.
  |
  */

  /// Returns an unmodifiable view of all registered entries.
  Map<K, V> get all => Map.unmodifiable(_store);

  /// Returns all registered keys.
  Iterable<K> get keys => _store.keys;

  /// Returns all registered values.
  Iterable<V> get values => _store.values;

  /// The number of registered entries.
  int get length => _store.length;

  /// `true` if the registry has no entries.
  bool get isEmpty => _store.isEmpty;

  /// `true` if the registry has at least one entry.
  bool get isNotEmpty => _store.isNotEmpty;

  @override
  @visibleForTesting
  String toString() => 'Registry<$K, $V>(${_store.keys.join(', ')})';
}
