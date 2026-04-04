// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/base_service.dart';

/// State for an update mutation.
class UpdateState<T> {
  const UpdateState({this.data, this.isLoading = false, this.error});

  final T? data;
  final bool isLoading;
  final Object? error;

  bool get isSuccess => data != null && !isLoading && error == null;

  UpdateState<T> copyWith({T? data, bool? isLoading, Object? error}) {
    return UpdateState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier that handles an update mutation — equivalent of Refine's `useUpdate`.
///
/// ```dart
/// final updatePost = ref.read(updatePostProvider.notifier);
/// await updatePost.mutate('42', {'title': 'Updated'});
/// ```
class UpdateNotifier<T, ID> extends AutoDisposeNotifier<UpdateState<T>> {
  UpdateNotifier(this._service);

  final BaseService<T, ID> _service;

  @override
  UpdateState<T> build() => const UpdateState();

  Future<T?> mutate(ID id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _service.update(id, data);
      state = UpdateState(data: result);
      return result;
    } catch (e) {
      state = UpdateState(error: e);
      return null;
    }
  }
}

/// Creates a Riverpod [NotifierProvider] for an update mutation.
AutoDisposeNotifierProvider<UpdateNotifier<T, ID>, UpdateState<T>>
    updateProvider<T, ID>(BaseService<T, ID> service) {
  return NotifierProvider.autoDispose<UpdateNotifier<T, ID>, UpdateState<T>>(
    () => UpdateNotifier(service),
  );
}
