// ignore_for_file: lines_longer_than_80_chars

import 'package:pixielity_refine/pixielity_refine.dart';
import 'api_client.dart';
import 'category_model.dart';

/// Concrete repository for [Category] backed by the fake-rest refine API.
class CategoryRepository extends BaseRepository<Category, int> {
  /// Creates a [CategoryRepository].
  CategoryRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Category>> all() async {
    final json = await _client.get('/categories') as List;
    return json
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Category>> get(QueryParams<Category> params) async {
    final map = <String, String>{};
    if (params.limitValue != null) map['_end'] = params.limitValue.toString();
    if (params.offsetValue != null) {
      map['_start'] = params.offsetValue.toString();
    }
    final json = await _client.get('/categories', params: map) as List;
    return json
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Category?> find(int id) async {
    final json =
        await _client.get('/categories/$id') as Map<String, dynamic>;
    return Category.fromJson(json);
  }

  @override
  Future<Category> findOrFail(int id) async {
    final cat = await find(id);
    if (cat == null) throw StateError('Category $id not found');
    return cat;
  }

  @override
  Future<List<Category>> findMany(List<int> ids) async {
    final futures = ids.map(findOrFail);
    return Future.wait(futures);
  }

  @override
  Future<Category?> first(QueryParams<Category> params) async {
    final list = await get(params..limit(1));
    return list.isEmpty ? null : list.first;
  }

  @override
  Future<Category> firstOrFail(QueryParams<Category> params) async {
    final cat = await first(params);
    if (cat == null) throw StateError('No category found');
    return cat;
  }

  @override
  Future<Category> create(Map<String, dynamic> data) async {
    final json =
        await _client.post('/categories', data) as Map<String, dynamic>;
    return Category.fromJson(json);
  }

  @override
  Future<Category> update(int id, Map<String, dynamic> data) async {
    final json =
        await _client.put('/categories/$id', data) as Map<String, dynamic>;
    return Category.fromJson(json);
  }

  @override
  Future<void> delete(int id) => _client.delete('/categories/$id');

  @override
  Future<void> destroy(List<int> ids) async {
    for (final id in ids) {
      await delete(id);
    }
  }

  @override
  Future<PaginatedResult<Category>> paginate({
    int page = 1,
    int perPage = 15,
    QueryParams<Category>? params,
  }) async {
    final start = (page - 1) * perPage;
    final end = start + perPage;
    final map = <String, String>{'_start': '$start', '_end': '$end'};
    final json = await _client.get('/categories', params: map) as List;
    final data = json
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
    final total = data.length < perPage
        ? start + data.length
        : start + perPage + 1;
    return PaginatedResult(
      data: data,
      total: total,
      perPage: perPage,
      currentPage: page,
      lastPage: (total / perPage).ceil(),
    );
  }

  // ── Stubs ───────────────────────────────────────────────────────────────────

  @override
  Future<PaginatedResult<Category>> simplePaginate({
    int page = 1,
    int perPage = 15,
    QueryParams<Category>? params,
  }) =>
      paginate(page: page, perPage: perPage, params: params);

  @override
  Future<Category> firstOrCreate(
    Map<String, dynamic> attributes, [
    Map<String, dynamic> values = const {},
  ]) =>
      throw UnimplementedError();

  @override
  Future<Category> firstOrNew(
    Map<String, dynamic> attributes, [
    Map<String, dynamic> values = const {},
  ]) =>
      throw UnimplementedError();

  @override
  Future<Category> updateOrCreate(
    Map<String, dynamic> attributes,
    Map<String, dynamic> values,
  ) =>
      throw UnimplementedError();

  @override
  Future<dynamic> value(String column, QueryParams<Category> params) =>
      throw UnimplementedError();

  @override
  Future<List<dynamic>> pluck(String column, [QueryParams<Category>? params]) =>
      throw UnimplementedError();

  @override
  Future<int> count([QueryParams<Category>? params]) async =>
      (await all()).length;

  @override
  Future<num?> max(String column, [QueryParams<Category>? params]) =>
      throw UnimplementedError();

  @override
  Future<num?> min(String column, [QueryParams<Category>? params]) =>
      throw UnimplementedError();

  @override
  Future<num> sum(String column, [QueryParams<Category>? params]) =>
      throw UnimplementedError();

  @override
  Future<num?> avg(String column, [QueryParams<Category>? params]) =>
      throw UnimplementedError();

  @override
  Future<bool> exists(QueryParams<Category> params) async =>
      (await first(params)) != null;

  @override
  Future<bool> doesntExist(QueryParams<Category> params) async =>
      !(await exists(params));

  @override
  Future<void> insert(List<Map<String, dynamic>> rows) =>
      throw UnimplementedError();

  @override
  Future<void> insertOrIgnore(List<Map<String, dynamic>> rows) =>
      throw UnimplementedError();

  @override
  Future<int> updateWhere(
    QueryParams<Category> params,
    Map<String, dynamic> data,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> upsert(
    List<Map<String, dynamic>> values,
    List<String> uniqueBy, {
    List<String>? update,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> increment(int id, String column, {int amount = 1}) =>
      throw UnimplementedError();

  @override
  Future<void> decrement(int id, String column, {int amount = 1}) =>
      throw UnimplementedError();

  @override
  Future<int> deleteWhere(QueryParams<Category> params) =>
      throw UnimplementedError();

  @override
  Future<void> restore(int id) => throw UnimplementedError();

  @override
  Future<void> forceDelete(int id) => delete(id);

  @override
  Future<List<Category>> withTrashed([QueryParams<Category>? params]) => all();

  @override
  Future<List<Category>> onlyTrashed([QueryParams<Category>? params]) async =>
      [];
}

/// Business logic layer for [Category].
class CategoryService extends BaseService<Category, int> {
  /// Creates a [CategoryService].
  CategoryService(super.repo);
}

/// Singleton instances wired together.
final _catClient = ApiClient();
final _catRepo = CategoryRepository(_catClient);

/// The [CategoryService] instance — exposed for Riverpod providers.
final categoryService = CategoryService(_catRepo);

/// Full resource definition for [Category].
final categoryResource = Resource<Category, int>(
  name: 'categories',
  service: categoryService,
  form: FormBuilder().text('title', label: 'Title', required: true),
  table: TableBuilder<Category>()
      .column('id', label: 'ID', sortable: true, valueGetter: (c) => c.id)
      .column(
        'title',
        label: 'Title',
        sortable: true,
        valueGetter: (c) => c.title,
      ),
  meta: const ResourceMeta(label: 'Categories'),
);
