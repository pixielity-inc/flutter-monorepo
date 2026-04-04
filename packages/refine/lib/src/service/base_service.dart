// ignore_for_file: lines_longer_than_80_chars

import '../repository/base_repository.dart';

export '../repository/base_repository.dart';

/// Base service class — business logic layer.
///
/// Wraps a [BaseRepository] and delegates all data-access calls to it.
/// Override any method to add validation, transformation, or cross-repo logic.
///
/// Mirrors the Laravel Service / Action pattern on top of Eloquent.
///
/// [T]  — model type.
/// [ID] — identifier type.
///
/// ```dart
/// class PostService extends BaseService<Post, String> {
///   PostService(PostRepository repo) : super(repo);
///
///   @override
///   Future<List<Post>> all() async {
///     final posts = await super.all();
///     return posts.where((p) => p.title.isNotEmpty).toList();
///   }
/// }
/// ```
class BaseService<T, ID> {
  BaseService(this._repo);

  final BaseRepository<T, ID> _repo;

  // ── Retrieval ──────────────────────────────────────────────────────────────

  /// Return all records — mirrors `Model::all()`.
  Future<List<T>> all() => _repo.all();

  /// Return records matching [params] — mirrors `->get()`.
  Future<List<T>> get(QueryParams<T> params) => _repo.get(params);

  /// Return a single record by [id] — mirrors `->find($id)`.
  Future<T?> find(ID id) => _repo.find(id);

  /// Return a single record by [id] or throw — mirrors `->findOrFail($id)`.
  Future<T> findOrFail(ID id) => _repo.findOrFail(id);

  /// Return many records by [ids] — mirrors `->findMany($ids)`.
  Future<List<T>> findMany(List<ID> ids) => _repo.findMany(ids);

  /// Return the first record matching [params] — mirrors `->first()`.
  Future<T?> first(QueryParams<T> params) => _repo.first(params);

  /// Return the first record or throw — mirrors `->firstOrFail()`.
  Future<T> firstOrFail(QueryParams<T> params) => _repo.firstOrFail(params);

  /// Return the first matching record or create it — mirrors `->firstOrCreate()`.
  Future<T> firstOrCreate(
    Map<String, dynamic> attributes, [
    Map<String, dynamic> values = const {},
  ]) => _repo.firstOrCreate(attributes, values);

  /// Return the first matching record or a new unsaved instance
  /// — mirrors `->firstOrNew()`.
  Future<T> firstOrNew(
    Map<String, dynamic> attributes, [
    Map<String, dynamic> values = const {},
  ]) => _repo.firstOrNew(attributes, values);

  /// Update matching record or create it — mirrors `->updateOrCreate()`.
  Future<T> updateOrCreate(
    Map<String, dynamic> attributes,
    Map<String, dynamic> values,
  ) => _repo.updateOrCreate(attributes, values);

  // ── Pagination ─────────────────────────────────────────────────────────────

  /// Return a paginated result — mirrors `->paginate()`.
  Future<PaginatedResult<T>> paginate({
    int page = 1,
    int perPage = 15,
    QueryParams<T>? params,
  }) => _repo.paginate(page: page, perPage: perPage, params: params);

  /// Return a simple paginated result — mirrors `->simplePaginate()`.
  Future<PaginatedResult<T>> simplePaginate({
    int page = 1,
    int perPage = 15,
    QueryParams<T>? params,
  }) => _repo.simplePaginate(page: page, perPage: perPage, params: params);

  // ── Single-value retrieval ─────────────────────────────────────────────────

  /// Return a single column value — mirrors `->value($column)`.
  Future<dynamic> value(String column, QueryParams<T> params) =>
      _repo.value(column, params);

  /// Return a list of values for a column — mirrors `->pluck($column)`.
  Future<List<dynamic>> pluck(String column, [QueryParams<T>? params]) =>
      _repo.pluck(column, params);

  // ── Aggregates ─────────────────────────────────────────────────────────────

  /// Return the total count — mirrors `->count()`.
  Future<int> count([QueryParams<T>? params]) => _repo.count(params);

  /// Return the max value of [column] — mirrors `->max($column)`.
  Future<num?> max(String column, [QueryParams<T>? params]) =>
      _repo.max(column, params);

  /// Return the min value of [column] — mirrors `->min($column)`.
  Future<num?> min(String column, [QueryParams<T>? params]) =>
      _repo.min(column, params);

  /// Return the sum of [column] — mirrors `->sum($column)`.
  Future<num> sum(String column, [QueryParams<T>? params]) =>
      _repo.sum(column, params);

  /// Return the average of [column] — mirrors `->avg($column)`.
  Future<num?> avg(String column, [QueryParams<T>? params]) =>
      _repo.avg(column, params);

  // ── Existence ──────────────────────────────────────────────────────────────

  /// Return true if any record matches [params] — mirrors `->exists()`.
  Future<bool> exists(QueryParams<T> params) => _repo.exists(params);

  /// Return true if no record matches [params] — mirrors `->doesntExist()`.
  Future<bool> doesntExist(QueryParams<T> params) => _repo.doesntExist(params);

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Create a new record — mirrors `->create()`.
  Future<T> create(Map<String, dynamic> data) => _repo.create(data);

  /// Create multiple records — mirrors `->insert()`.
  Future<void> insert(List<Map<String, dynamic>> rows) => _repo.insert(rows);

  /// Create or ignore duplicates — mirrors `->insertOrIgnore()`.
  Future<void> insertOrIgnore(List<Map<String, dynamic>> rows) =>
      _repo.insertOrIgnore(rows);

  /// Update a record by [id] — mirrors `->update()` on a model.
  Future<T> update(ID id, Map<String, dynamic> data) => _repo.update(id, data);

  /// Update all records matching [params] — mirrors `->update()` on builder.
  Future<int> updateWhere(QueryParams<T> params, Map<String, dynamic> data) =>
      _repo.updateWhere(params, data);

  /// Update or insert — mirrors `->upsert()`.
  Future<void> upsert(
    List<Map<String, dynamic>> values,
    List<String> uniqueBy, {
    List<String>? update,
  }) => _repo.upsert(values, uniqueBy, update: update);

  /// Increment a [column] — mirrors `->increment()`.
  Future<void> increment(ID id, String column, {int amount = 1}) =>
      _repo.increment(id, column, amount: amount);

  /// Decrement a [column] — mirrors `->decrement()`.
  Future<void> decrement(ID id, String column, {int amount = 1}) =>
      _repo.decrement(id, column, amount: amount);

  // ── Delete ─────────────────────────────────────────────────────────────────

  /// Delete a record by [id] — mirrors `->delete()`.
  Future<void> delete(ID id) => _repo.delete(id);

  /// Delete multiple records by [ids] — mirrors `Model::destroy($ids)`.
  Future<void> destroy(List<ID> ids) => _repo.destroy(ids);

  /// Delete all records matching [params] — mirrors `->delete()` on builder.
  Future<int> deleteWhere(QueryParams<T> params) => _repo.deleteWhere(params);

  // ── Soft deletes ───────────────────────────────────────────────────────────

  /// Restore a soft-deleted record — mirrors `->restore()`.
  Future<void> restore(ID id) => _repo.restore(id);

  /// Force-delete a soft-deleted record — mirrors `->forceDelete()`.
  Future<void> forceDelete(ID id) => _repo.forceDelete(id);

  /// Include soft-deleted records — mirrors `->withTrashed()`.
  Future<List<T>> withTrashed([QueryParams<T>? params]) =>
      _repo.withTrashed(params);

  /// Return only soft-deleted records — mirrors `->onlyTrashed()`.
  Future<List<T>> onlyTrashed([QueryParams<T>? params]) =>
      _repo.onlyTrashed(params);
}
