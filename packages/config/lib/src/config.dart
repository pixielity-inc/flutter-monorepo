// ignore_for_file: lines_longer_than_80_chars
// lib/src/config.dart
//
// Config — the central configuration registry for the Pixielity app.
//
// Inspired by Laravel's config() helper and NestJS's ConfigService.
// Config files live in apps/<app>/config/ and return plain Dart maps.
// The registry is loaded once at startup and is read-only after that.
//
// Usage:
//   // Read a value with dot-notation
//   final url = Config.get<String>('api.baseUrl');
//
//   // Read with a fallback
//   final timeout = Config.get<int>('api.connectTimeoutSeconds', fallback: 10);
//
//   // Read a whole section as a map
//   final apiConfig = Config.section('api');
//
//   // Check existence
//   if (Config.has('analytics.sentryDsn')) { ... }

/// The central, read-only configuration registry.
///
/// Load it once at startup via [Config.load], then read values anywhere
/// in the app using [Config.get] with dot-notation keys.
///
/// ```dart
/// // main.dart
/// Config.load({
///   'app':           appConfig(),
///   'api':           apiConfig(),
///   'auth':          authConfig(),
///   'theme':         themeConfig(),
///   'storage':       storageConfig(),
///   'analytics':     analyticsConfig(),
///   'logging':       loggingConfig(),
///   'feature_flags': featureFlagsConfig(),
/// });
///
/// // Anywhere in the app
/// final baseUrl = Config.get<String>('api.baseUrl');
/// final isDev   = Config.get<bool>('app.isDevelopment', fallback: false);
/// final level   = Config.get<String>('logging.level', fallback: 'info');
/// ```
abstract final class Config {
  static Map<String, dynamic> _store = {};
  static bool _loaded = false;

  // ── Bootstrap ─────────────────────────────────────────────────────────────

  /// Loads all config sections into the registry.
  ///
  /// [sections] is a map of section name → config map, e.g.:
  /// ```dart
  /// Config.load({
  ///   'api': apiConfig(),
  ///   'app': appConfig(),
  /// });
  /// ```
  ///
  /// Throws [StateError] if called more than once. Call [Config.reset] in
  /// tests to allow reloading.
  static void load(Map<String, Map<String, dynamic>> sections) {
    if (_loaded) {
      throw StateError(
        'Config.load() has already been called. '
        'Call Config.reset() first if you need to reload (tests only).',
      );
    }
    _store = Map<String, dynamic>.unmodifiable(
      sections.map(
        (key, value) => MapEntry(key, Map<String, dynamic>.unmodifiable(value)),
      ),
    );
    _loaded = true;
  }

  /// Resets the registry. Only use in tests.
  static void reset() {
    _store = {};
    _loaded = false;
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  /// Returns the value at [key] cast to [T].
  ///
  /// [key] uses dot-notation: `'section.key'` or `'section.nested.key'`.
  ///
  /// If [fallback] is provided and the key is missing or null, returns it.
  /// If [fallback] is not provided and the key is missing, throws [ConfigKeyNotFoundException].
  ///
  /// ```dart
  /// Config.get<String>('api.baseUrl')
  /// Config.get<bool>('analytics.enabled', fallback: false)
  /// Config.get<int>('api.connectTimeoutSeconds', fallback: 10)
  /// ```
  static T get<T>(String key, {T? fallback}) {
    _assertLoaded();
    final value = _resolve(key);

    if (value == null) {
      if (fallback != null) return fallback;
      throw ConfigKeyNotFoundException(key);
    }

    if (value is T) return value;

    // Attempt basic type coercion for common cases.
    final coerced = _coerce<T>(value);
    if (coerced != null) return coerced;

    throw ConfigTypeMismatchException(key, T, value.runtimeType);
  }

  /// Returns the entire section map for [sectionName].
  ///
  /// ```dart
  /// final api = Config.section('api');
  /// print(api['baseUrl']); // 'https://api.pixielity.com'
  /// ```
  static Map<String, dynamic> section(String sectionName) {
    _assertLoaded();
    final s = _store[sectionName];
    if (s == null) throw ConfigKeyNotFoundException(sectionName);
    return Map<String, dynamic>.from(s as Map);
  }

  /// Returns `true` if [key] exists and is non-null.
  ///
  /// ```dart
  /// if (Config.has('app.sentryDsn')) { initSentry(); }
  /// ```
  static bool has(String key) {
    if (!_loaded) return false;
    return _resolve(key) != null;
  }

  /// Returns all loaded section names.
  ///
  /// ```dart
  /// print(Config.sections); // ['app', 'api', 'auth', ...]
  /// ```
  static List<String> get sections {
    _assertLoaded();
    return List.unmodifiable(_store.keys);
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  /// Resolves a dot-notation [key] against the store.
  ///
  /// Supports arbitrary nesting: `'api.retry.maxAttempts'`.
  static dynamic _resolve(String key) {
    final parts = key.split('.');
    dynamic current = _store;

    for (final part in parts) {
      if (current is Map) {
        current = current[part];
      } else {
        return null;
      }
    }
    return current;
  }

  /// Attempts to coerce [value] to type [T].
  ///
  /// Handles the most common cases: num → int/double, String → bool.
  static T? _coerce<T>(dynamic value) {
    if (T == int && value is num) return value.toInt() as T;
    if (T == double && value is num) return value.toDouble() as T;
    if (T == bool && value is String) {
      if (value == 'true') return true as T;
      if (value == 'false') return false as T;
    }
    if (T == String) return value.toString() as T;
    return null;
  }

  static void _assertLoaded() {
    if (!_loaded) {
      throw StateError(
        'Config has not been loaded. '
        'Call Config.load({...}) in main() before using Config.get().',
      );
    }
  }
}

// ── Exceptions ────────────────────────────────────────────────────────────────

/// Thrown when [Config.get] is called with a key that does not exist.
class ConfigKeyNotFoundException implements Exception {
  /// Creates a [ConfigKeyNotFoundException].
  const ConfigKeyNotFoundException(this.key);

  /// The missing dot-notation key.
  final String key;

  @override
  String toString() =>
      'ConfigKeyNotFoundException: No config value found for key "$key". '
      'Make sure the key exists in the corresponding config file.';
}

/// Thrown when the value at a key cannot be cast to the requested type.
class ConfigTypeMismatchException implements Exception {
  /// Creates a [ConfigTypeMismatchException].
  const ConfigTypeMismatchException(this.key, this.expected, this.actual);

  /// The dot-notation key.
  final String key;

  /// The expected type.
  final Type expected;

  /// The actual runtime type of the stored value.
  final Type actual;

  @override
  String toString() =>
      'ConfigTypeMismatchException: Config key "$key" has type $actual '
      'but $expected was requested.';
}
