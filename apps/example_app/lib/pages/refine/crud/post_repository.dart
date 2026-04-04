// ignore_for_file: lines_longer_than_80_chars

import 'package:pixielity_refine/pixielity_refine.dart';
import 'api_client.dart';
import 'post_model.dart';

/// Concrete repository for [Post] backed by the fake-rest refine API.
///
/// Implements the full [BaseRepository] contract. Methods not supported
/// by the JSON Server API throw [UnimplementedError].
class PostRepository extends BaseRepository<Post, int> {
  /// Creates a [PostRepository].
  PostRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Post>> all() async {
    final json = await _client.get('/posts') as List;
    return json.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Post>> get(QueryParams<Post> params) async {
    final map = <String, String>{};
    if (params.limitValue != null) map['_end'] = params.limitValue.toString();
    if (params.offsetValue != null) map['_start'] = params.offsetValue.toString();
    for (final o in params.orders) {
      map['_sort'] = o.column;
      map['_order'] = o.direction;
    }
    for (final w in params.wheres) {
      if (w.operator == 'like') {
        map['q'] = w.value.toString().replaceAll('%', '');
      } else if (w.operator == '=') {
        map[w.column] = w.value.toString();
      }
    }
    final json = await _client.get('/posts', params: map) as List;
    return json.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Post?> find(int id) async {
    final json = await _client.get('/posts/$id') as Map<String, dynamic>;
    return Post.fromJson(json);
  }

  @override
  Future<Post> findOrFail(int id) async {
    final post = await find(id);
    if (post == null) throw StateError('Post $id not found');
    return post;
  }

  @override
  Future<List<Post>> findMany(List<int> ids) async {
    final futures = ids.map(findOrFail);
    return Future.wait(futures);
  }

  @override
  Future<Post?> first(QueryParams<Post> params) async {
    final list = await get(params..limit(1));
    return list.isEmpty ? null : list.first;
  }

  @override
  Future<Post> firstOrFail(QueryParams<Post> params) async {
    final post = await first(params);
    if (post == null) throw StateError('No post found');
    return post;
  }

  @override
  Future<Post> create(Map<String, dynamic> data) async {
    final json = await _client.post('/posts', data) as Map<String, dynamic>;
    return Post.fromJson(json);
  }

  @override
  Future<Post> update(int id, Map<String, dynamic> data) async {
    final json = await _client.put('/posts/$id', data) as Map<String, dynamic>;
    return Post.fromJson(json);
  }

  @override
  Future<void> delete(int id) => _client.delete('/posts/$id');

  @override
  Future<void> destroy(List<int> ids) async {
    for (final id in ids) {
      await delete(id);
    }
  }

  @override
  Future<PaginatedResult<Post>> paginate({
    int page = 1,
    int perPage = 15,
    QueryParams<Post>? params,
  }) async {
    final start = (page - 1) * perPage;
    final end = start + perPage;
    final map = <String, String>{'_start': '$start', '_end': '$end'};
    final json = await _client.get('/posts', params: map) as List;
    final data = json.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    // JSON Server doesn't return total in body — estimate from data length.
    final total = data.length < perPage ? start + data.length : start + perPage + 1;
    return PaginatedResult(
      data: data,
      total: total,
      perPage: perPage,
      currentPage: page,
      lastPage: (total / perPage).ceil(),
    );
  }

  // ── Stubs for methods not supported by JSON Server ──────────────────────────

  @override
  Future<PaginatedResult<Post>> simplePaginate({int page = 1, int perPage = 15, QueryParams<Post>? params}) =>
      paginate(page: page, perPage: perPage, params: params);

  @override
  Future<Post> firstOrCreate(Map<String, dynamic> attributes, [Map<String, dynamic> values = const {}]) =>
      throw UnimplementedError();

  @override
  Future<Post> firstOrNew(Map<String, dynamic> attributes, [Map<String, dynamic> values = const {}]) =>
      throw UnimplementedError();

  @override
  Future<Post> updateOrCreate(Map<String, dynamic> attributes, Map<String, dynamic> values) =>
      throw UnimplementedError();

  @override
  Future<dynamic> value(String column, QueryParams<Post> params) => throw UnimplementedError();

  @override
  Future<List<dynamic>> pluck(String column, [QueryParams<Post>? params]) => throw UnimplementedError();

  @override
  Future<int> count([QueryParams<Post>? params]) async => (await all()).length;

  @override
  Future<num?> max(String column, [QueryParams<Post>? params]) => throw UnimplementedError();

  @override
  Future<num?> min(String column, [QueryParams<Post>? params]) => throw UnimplementedError();

  @override
  Future<num> sum(String column, [QueryParams<Post>? params]) => throw UnimplementedError();

  @override
  Future<num?> avg(String column, [QueryParams<Post>? params]) => throw UnimplementedError();

  @override
  Future<bool> exists(QueryParams<Post> params) async => (await first(params)) != null;

  @override
  Future<bool> doesntExist(QueryParams<Post> params) async => !(await exists(params));

  @override
  Future<void> insert(List<Map<String, dynamic>> rows) => throw UnimplementedError();

  @override
  Future<void> insertOrIgnore(List<Map<String, dynamic>> rows) => throw UnimplementedError();

  @override
  Future<int> updateWhere(QueryParams<Post> params, Map<String, dynamic> data) => throw UnimplementedError();

  @override
  Future<void> upsert(List<Map<String, dynamic>> values, List<String> uniqueBy, {List<String>? update}) =>
      throw UnimplementedError();

  @override
  Future<void> increment(int id, String column, {int amount = 1}) => throw UnimplementedError();

  @override
  Future<void> decrement(int id, String column, {int amount = 1}) => throw UnimplementedError();

  @override
  Future<int> deleteWhere(QueryParams<Post> params) => throw UnimplementedError();

  @override
  Future<void> restore(int id) => throw UnimplementedError();

  @override
  Future<void> forceDelete(int id) => delete(id);

  @override
  Future<List<Post>> withTrashed([QueryParams<Post>? params]) => all();

  @override
  Future<List<Post>> onlyTrashed([QueryParams<Post>? params]) async => [];
}
