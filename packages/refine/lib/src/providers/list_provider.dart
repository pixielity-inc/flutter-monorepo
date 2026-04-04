// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/query_params.dart';
import '../service/base_service.dart';

/// Creates a Riverpod [FutureProvider] that fetches a list of [T] from
/// [service] — the Flutter equivalent of Refine's `useList`.
///
/// ```dart
/// final postsListProvider = listProvider(postService);
///
/// // In a widget:
/// final async = ref.watch(postsListProvider);
/// ```
///
/// Pass [params] to filter, sort, or paginate.
AutoDisposeFutureProvider<List<T>> listProvider<T, ID>(
  BaseService<T, ID> service, {
  QueryParams<T>? params,
}) {
  return FutureProvider.autoDispose<List<T>>((ref) async {
    if (params != null) return service.get(params);
    return service.all();
  });
}

/// Creates a paginated [FutureProvider] — equivalent of Refine's `useList`
/// with pagination meta.
AutoDisposeFutureProvider<PaginatedResult<T>> paginatedListProvider<T, ID>(
  BaseService<T, ID> service, {
  int page = 1,
  int perPage = 15,
  QueryParams<T>? params,
}) {
  return FutureProvider.autoDispose<PaginatedResult<T>>((ref) {
    return service.paginate(page: page, perPage: perPage, params: params);
  });
}
