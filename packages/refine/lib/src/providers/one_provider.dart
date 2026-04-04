// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/base_service.dart';

/// Creates a Riverpod [FutureProvider] that fetches a single [T] by [id]
/// — the Flutter equivalent of Refine's `useOne`.
///
/// ```dart
/// final postProvider = oneProvider(postService, '42');
///
/// // In a widget:
/// final async = ref.watch(postProvider);
/// ```
AutoDisposeFutureProvider<T> oneProvider<T, ID>(
  BaseService<T, ID> service,
  ID id,
) {
  return FutureProvider.autoDispose<T>((ref) => service.findOrFail(id));
}
