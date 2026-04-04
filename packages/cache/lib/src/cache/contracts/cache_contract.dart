/// Abstract contract for the cache store.
abstract interface class CacheContract {
  /// Retrieve an item from the cache by [key].
  Future<T?> get<T>(String key);

  /// Store an item in the cache under [key] for an optional [ttl].
  Future<void> put<T>(String key, T value, {Duration? ttl});

  /// Remove an item from the cache by [key].
  Future<void> forget(String key);

  /// Determine if an item exists in the cache by [key].
  Future<bool> has(String key);

  /// Remove all items from the cache.
  Future<void> flush();
}
