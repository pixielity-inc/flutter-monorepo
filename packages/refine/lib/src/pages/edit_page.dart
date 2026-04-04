// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../providers/one_provider.dart';
import '../providers/update_provider.dart';
import '../renderer/form_renderer.dart';
import '../resource/resource.dart';

/// Auto-generated edit page for a [Resource] using ForeUI.
///
/// ```dart
/// EditPage(resource: postResource, id: '42')
/// ```
class EditPage<T, ID> extends ConsumerWidget {
  /// Creates an [EditPage].
  const EditPage({
    super.key,
    required this.resource,
    required this.id,
    this.toMap,
    this.onSuccess,
  });

  /// The resource definition.
  final Resource<T, ID> resource;

  /// The record ID to load and edit.
  final ID id;

  /// Convert [T] to a [Map] for pre-filling the form.
  final Map<String, dynamic> Function(T item)? toMap;

  /// Called after a successful update. Defaults to popping the route.
  final void Function(T updated)? onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schema = resource.form?.build() ?? [];
    final label = resource.meta?.label ?? resource.name;
    final async = ref.watch(oneProvider<T, ID>(resource.service, id));
    final updateState = ref.watch(updateProvider<T, ID>(resource.service));
    final notifier = ref.read(updateProvider<T, ID>(resource.service).notifier);

    ref.listen(updateProvider<T, ID>(resource.service), (_, next) {
      if (next.isSuccess && next.data != null) {
        if (onSuccess != null) {
          onSuccess!(next.data as T);
        } else {
          Navigator.of(context).pop(next.data);
        }
      }
      if (next.error != null) {
        showFToast(
          context: context,
          variant: .destructive,
          title: const Text('Error'),
          description: Text(next.error.toString()),
        );
      }
    });

    return FScaffold(
      header: FHeader.nested(
        title: Text('Edit $label'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: async.when(
        loading: () => const Center(child: FCircularProgress()),
        error: (e, _) => Center(
          child: FAlert(
            variant: .destructive,
            title: const Text('Failed to load'),
            subtitle: Text(e.toString()),
          ),
        ),
        data: (item) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormRenderer(
            schema: schema,
            initialValues: toMap != null
                ? toMap!(item)
                : (item is Map<String, dynamic> ? item : {}),
            isLoading: updateState.isLoading,
            onSubmit: (data) => notifier.mutate(id, data),
          ),
        ),
      ),
    );
  }
}
