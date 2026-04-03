// ignore_for_file: lines_longer_than_80_chars

const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

/// Local storage configuration.
///
/// Access values via Config.get('storage.<key>').
Map<String, dynamic> storageConfig() {
  return {

    /*
    |--------------------------------------------------------------------------
    | Key Prefix
    |--------------------------------------------------------------------------
    |
    | A namespace prefix applied to all SharedPreferences keys to avoid
    | collisions with other packages or apps on the same device.
    | For example, a prefix of "pixielity" produces keys like "pixielity.theme".
    |
    | dart-define: STORAGE_KEY_PREFIX
    |
    */

    'keyPrefix': const String.fromEnvironment('STORAGE_KEY_PREFIX', defaultValue: 'pixielity'),

    /*
    |--------------------------------------------------------------------------
    | Encrypt Shared Preferences
    |--------------------------------------------------------------------------
    |
    | When enabled, all SharedPreferences values are encrypted at rest using
    | EncryptedSharedPreferences on Android and the Keychain on iOS.
    | Automatically enabled in production.
    |
    */

    'encryptSharedPreferences': _env == 'production',

    /*
    |--------------------------------------------------------------------------
    | Clear on Logout
    |--------------------------------------------------------------------------
    |
    | When enabled, all user-specific data is removed from local storage
    | when the user logs out. Recommended for shared or kiosk devices.
    |
    */

    'clearOnLogout': true,

    /*
    |--------------------------------------------------------------------------
    | Clear on Reinstall
    |--------------------------------------------------------------------------
    |
    | On iOS, Keychain data survives app reinstallation by default. When this
    | option is enabled, all stored data is cleared on the first launch after
    | a reinstall, ensuring a clean slate for new users.
    |
    */

    'clearOnReinstall': true,

    /*
    |--------------------------------------------------------------------------
    | Cache Configuration
    |--------------------------------------------------------------------------
    |
    | Controls the in-memory and on-disk cache used for network responses
    | and computed data. The eviction strategy determines which entries are
    | removed when the cache reaches its maximum size.
    |
    | Supported eviction strategies: "lru", "lfu", "fifo"
    |
    | dart-define: STORAGE_CACHE_MAX_MB, STORAGE_CACHE_TTL_H
    |
    */

    'cache': {
      'maxSizeMb':         const int.fromEnvironment('STORAGE_CACHE_MAX_MB', defaultValue: 50),
      'ttlHours':          const int.fromEnvironment('STORAGE_CACHE_TTL_H',  defaultValue: 24),
      'evictionStrategy':  'lru',
      'enableDisk':        true,
      'enableMemory':      true,
    },

    /*
    |--------------------------------------------------------------------------
    | Database Configuration
    |--------------------------------------------------------------------------
    |
    | Configuration for the local SQLite database managed by Drift.
    | Increment schemaVersion whenever you add or modify database migrations.
    | WAL mode improves concurrent read/write performance significantly.
    | Database encryption requires the sqlcipher package.
    |
    | dart-define: STORAGE_DB_NAME, STORAGE_DB_VERSION
    |
    */

    'database': {
      'name':                const String.fromEnvironment('STORAGE_DB_NAME',    defaultValue: 'pixielity.db'),
      'schemaVersion':       const int.fromEnvironment('STORAGE_DB_VERSION',    defaultValue: 1),
      'enableForeignKeys':   true,
      'enableWal':           true,
      // Encrypt the database at rest in production (requires sqlcipher).
      'encrypt':             _env == 'production',
    },

  };
}
