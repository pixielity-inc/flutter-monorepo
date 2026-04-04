// ignore_for_file: lines_longer_than_80_chars

import 'query_params.dart';

export 'query_params.dart';

/// Abstract contract for a generic CRUD repository.
///
/// Mirrors the Laravel Eloquent + Query Builder API adapted for Dart.
/// Responsibility: pure data access only — HTTP, DB, cache.
/// No business logic. No Riverpod. No Flutter.
///
/// [T]  — model type.
/// [ID] — identifier type (usually [String] or [int]).
///
/// ```dart
/// class PostRepository extends BaseRepository<Post, String> {
///   final ApiClient _client;
///   PostRepository(this._client);
///
///   @override
///   Future<List<Post>> all() async {
///     final json = await _client.get('/posts');
///     return (json as List).map((e) => Post.fromJson(e)).toList();
///   }
///   // ...
/// }
/// ```
abstract class BaseRepository<T, ID> {

  // ── Retrieval ──────────────────────────────────────────────────────────────

  /// Return all records — mirrors `Model::all()`.
  Future<List<T>> all();

  /// Return records matching [params] — mirrors `->get()`.
  Future<List<T>> get(QueryParams<T> params);

  /// Return a single record by [id] — mirrors `->find($id)`.
  Future<T?> find(ID id);

  /// Return a single record by [id] or throw — mirrors `->findOrFail($id)`.
  Future<T> findOrFail(ID id);

  /// Return many records by a list of [ids] — mirrors `->findMany($ids)`.
  Future<List<T>> findMany(List<ID> ids);

  /// Return the first record matching [params] — mirrors `->first()`.
  Future<T?> first(QueryParams<T> params);

  /// Return the first record or throw — mirrors `->firstOrFail()`.
  Future<T> firstOrFail(QueryParams<T> params);

  /// Return the first record matching [attributes] or create it
  /// — mirrors `->firstOrCreate()`.
  Future<T> firstOrCreate(
    Map<String, dynamic> attributes, [
    Map<String, dynamic> values = const {},
  ]);

  /// Return the first record matching [attributes] or instantiate a new
  /// unsaved instance — mirrors `->firstOrNew()`.
  Future<T> firstOrNew(
    Map<String, dynamic> attributes, [
    Map<String, dynamic> values = const {},
  ]);

  /// Update matching record or create it — mirrors `->updateOrCreate()`.
  Future<T> updateOrCreate(
    Map<String, dynamic> attributes,
    Map<String, dynamic> values,
  );

  // ── Pagination ─────────────────────────────────────────────────────────────

  /// Return a paginated result — mirrors `->paginate()`.
  Future<PaginatedResult<T>> paginate({
    int page = 1,
    int perPage = 15,
    QueryParams<T>? params,
  });

  /// Return a simple paginated result (no total count)
  /// — mirrors `->simplePaginate()`.
  Future<PaginatedResult<T>> simplePaginate({
    int page = 1,
    int perPage = 15,
    QueryParams<T>? params,
  });

  // ── Single-value retrieval ─────────────────────────────────────────────────

  /// Return a single column value from the first matching record
  /// — mirrors `->value($column)`.
  Future<dynamic> value(String column, QueryParams<T> params);

  /// Return a list of values for a single [column]
  /// — mirrors `->pluck($column)`.
  Future<List<dynamic>> pluck(String column, [QueryParams<T>? params]);

  // ── Aggregates ─────────────────────────────────────────────────────────────

  /// Return the total count — mirrors `->count()`.
  Future<int> count([QueryParams<T>? params]);

  /// Return the maximum value of [column] — mirrors `->max($column)`.
  Future<num?> max(String column, [QueryParams<T>? params]);

  /// Return the minimum value of [column] — mirrors `->min($column)`.
  Future<num?> min(String column, [QueryParams<T>? params]);

  /// Return the sum of [column] — mirrors `->sum($column)`.
  Future<num> sum(String column, [QueryParams<T>? params]);

  /// Return the average of [column] — mirrors `->avg($column)`.
  Future<num?> avg(String column, [QueryParams<T>? params]);

  // ── Existence ──────────────────────────────────────────────────────────────

  /// Return true if any record matches [params] — mirrors `->exists()`.
  Future<bool> exists(QueryParams<T> params);

  /// Return true if no record matches [params] — mirrors `->doesntExist()`.
  Future<bool> doesntExist(QueryParams<T> params);

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Create a new record from [data] and return it — mirrors `->create()`.
  Future<T> create(Map<String, dynamic> data);

  /// Create multiple records — mirrors `->insert()`.
  Future<void> insert(List<Map<String, dynamic>> rows);

  /// Create or ignore duplicate records — mirrors `->insertOrIgnore()`.
  Future<void> insertOrIgnore(List<Map<String, dynamic>> rows);

  /// Update the record identified by [id] — mirrors `->update()` on a model.
  Future<T> update(ID id, Map<String, dynamic> data);

  /// Update all records matching [params] — mirrors `->update()` on builder.
  Future<int> updateWhere(QueryParams<T> params, Map<String, dynamic> data);

  /// Update or insert based on [attributes] — mirrors `->upsert()`.
  Future<void> upsert(
    List<Map<String, dynamic>> values,
    List<String> uniqueBy, {
    List<String>? update,
  });

  /// Increment a [column] by [amount] — mirrors `->increment()`.
  Future<void> increment(ID id, String column, {int amount = 1});

  /// Decrement a [column] by [amount] — mirrors `->decrement()`.
  Future<void> decrement(ID id, String column, {int amount = 1});

  // ── Delete ─────────────────────────────────────────────────────────────────

  /// Delete the record identified by [id] — mirrors `->delete()`.
  Future<void> delete(ID id);

  /// Delete multiple records by [ids] — mirrors `Model::destroy($ids)`.
  Future<void> destroy(List<ID> ids);

  /// Delete all records matching [params] — mirrors `->delete()` on builder.
  Future<int> deleteWhere(QueryParams<T> params);

  // ── Soft deletes ───────────────────────────────────────────────────────────

  /// Restore a soft-deleted record — mirrors `->restore()`.
  Future<void> restore(ID id);

  /// Force-delete a soft-deleted record — mirrors `->forceDelete()`.
  Future<void> forceDelete(ID id);

  /// Include soft-deleted records in results — mirrors `->withTrashed()`.
  Future<List<T>> withTrashed([QueryParams<T>? params]);

  /// Return only soft-deleted records — mirrors `->onlyTrashed()`.
  Future<List<T>> onlyTrashed([QueryParams<T>? params]);
}
