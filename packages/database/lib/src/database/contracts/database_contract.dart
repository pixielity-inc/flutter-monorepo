/// Abstract contract for the database store.
abstract interface class DatabaseContract {
  /// Execute a raw query and return results.
  Future<List<Map<String, dynamic>>> query(String sql, [List<dynamic>? args]);

  /// Execute a raw insert/update/delete statement.
  Future<int> execute(String sql, [List<dynamic>? args]);

  /// Close the database connection.
  Future<void> close();
}
