// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../providers/create_provider.dart';
import '../renderer/form_renderer.dart';
import '../resource/resource.dart';

/// Auto-generated create page for a [Resource] using ForeUI.
///
/// ```dart
/// CreatePage(resource: postResource)
/// ```
class CreatePage<T, ID> extends ConsumerWidget {
  /// Creates a [CreatePage].
  const CreatePage({super.key, required this.resource, this.onSuccess});

  /// The resource definition.
  final Resource<T, ID> resource;

  /// Called after a successful create. Defaults to popping the route.
  final void Function(T created)? onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schema = resource.form?.build() ?? [];
    final label = resource.meta?.label ?? resource.name;
    final createState = ref.watch(createProvider<T, ID>(resource.service));
    final notifier = ref.read(createProvider<T, ID>(resource.service).notifier);

    ref.listen(createProvider<T, ID>(resource.service), (_, next) {
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
        title: Text('Create $label'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormRenderer(
          schema: schema,
          isLoading: createState.isLoading,
          onSubmit: (data) => notifier.mutate(data),
        ),
      ),
    );
  }
}
