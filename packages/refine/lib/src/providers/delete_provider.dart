// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/base_service.dart';

/// State for a delete mutation.
class DeleteState {
  const DeleteState({this.isLoading = false, this.isSuccess = false, this.error});

  final bool isLoading;
  final bool isSuccess;
  final Object? error;

  DeleteState copyWith({bool? isLoading, bool? isSuccess, Object? error}) {
    return DeleteState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

/// Notifier that handles a delete mutation — equivalent of Refine's `useDelete`.
///
/// ```dart
/// final deletePost = ref.read(deletePostProvider.notifier);
/// await deletePost.mutate('42');
/// ```
class DeleteNotifier<T, ID> extends AutoDisposeNotifier<DeleteState> {
  DeleteNotifier(this._service);

  final BaseService<T, ID> _service;

  @override
  DeleteState build() => const DeleteState();

  Future<bool> mutate(ID id) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      await _service.delete(id);
      state = const DeleteState(isSuccess: true);
      return true;
    } catch (e) {
      state = DeleteState(error: e);
      return false;
    }
  }
}

/// Creates a Riverpod [NotifierProvider] for a delete mutation.
AutoDisposeNotifierProvider<DeleteNotifier<T, ID>, DeleteState>
    deleteProvider<T, ID>(BaseService<T, ID> service) {
  return NotifierProvider.autoDispose<DeleteNotifier<T, ID>, DeleteState>(
    () => DeleteNotifier(service),
  );
}
