// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'access_control_provider.dart';

/// Creates a Riverpod [FutureProvider] that checks a single permission.
///
/// ```dart
/// final canDeletePosts = useCanProvider(
///   accessControl,
///   CanParams(action: 'delete', resource: 'posts'),
/// );
///
/// // In a widget:
/// final result = ref.watch(canDeletePosts);
/// result.when(
///   data: (can) => can.can ? deleteButton : SizedBox.shrink(),
///   ...
/// );
/// ```
AutoDisposeFutureProvider<CanResponse> useCanProvider(
  AccessControlProvider provider,
  CanParams params,
) {
  return FutureProvider.autoDispose<CanResponse>(
    (ref) => provider.can(params),
  );
}
