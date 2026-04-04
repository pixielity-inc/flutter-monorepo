// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/base_service.dart';

/// State for a create mutation.
class CreateState<T> {
  const CreateState({this.data, this.isLoading = false, this.error});

  final T? data;
  final bool isLoading;
  final Object? error;

  bool get isSuccess => data != null && !isLoading && error == null;

  CreateState<T> copyWith({T? data, bool? isLoading, Object? error}) {
    return CreateState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier that handles a create mutation — equivalent of Refine's `useCreate`.
///
/// ```dart
/// final createPost = ref.read(createPostProvider.notifier);
/// await createPost.mutate({'title': 'Hello'});
/// ```
class CreateNotifier<T, ID> extends AutoDisposeNotifier<CreateState<T>> {
  CreateNotifier(this._service);

  final BaseService<T, ID> _service;

  @override
  CreateState<T> build() => const CreateState();

  Future<T?> mutate(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _service.create(data);
      state = CreateState(data: result);
      return result;
    } catch (e) {
      state = CreateState(error: e);
      return null;
    }
  }
}

/// Creates a Riverpod [NotifierProvider] for a create mutation.
AutoDisposeNotifierProvider<CreateNotifier<T, ID>, CreateState<T>>
    createProvider<T, ID>(BaseService<T, ID> service) {
  return NotifierProvider.autoDispose<CreateNotifier<T, ID>, CreateState<T>>(
    () => CreateNotifier(service),
  );
}
