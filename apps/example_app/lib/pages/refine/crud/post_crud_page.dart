// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';
import 'post_model.dart';
import 'post_resource.dart';

/// Full CRUD demo page using the refine package against the live
/// fake-rest API at https://api.fake-rest.refine.dev.
///
/// Demonstrates: Model → Repository → Service → Resource → Providers →
/// TableRenderer + FilterRenderer + FormRenderer + auto CRUD pages.
class PostCrudPage extends ConsumerStatefulWidget {
  /// Creates a [PostCrudPage].
  const PostCrudPage({super.key});

  @override
  ConsumerState<PostCrudPage> createState() => _PostCrudPageState();
}

class _PostCrudPageState extends ConsumerState<PostCrudPage> {
  late final _listProvider = listProvider<Post, int>(postService);
  late final _deleteNotifier = deleteProvider<Post, int>(postService);
  QueryParams<Post>? _filterParams;
  int _page = 1;

  final _tableSchema = postResource.table!.build();
  final _filterSchema = postResource.filter!.build();

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_listProvider);
    final deleteState = ref.watch(_deleteNotifier);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Posts CRUD'),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
        suffixes: [
          FHeaderAction(
            icon: const Icon(FIcons.plus),
            onPress: () => _pushCreate(context),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.refreshCw),
            onPress: () => ref.invalidate(_listProvider),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Filter bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: FilterRenderer<Post>(
              schema: _filterSchema,
              onChanged: (params) => setState(() => _filterParams = params),
            ),
          ),
          const SizedBox(height: 8),
          const FDivider(),

          // ── Table ───────────────────────────────────────────────────────
          Expanded(
            child: async.when(
              loading: () => const Center(child: FCircularProgress()),
              error: (e, _) => Center(
                child: FAlert(
                  variant: .destructive,
                  title: const Text('Failed to load posts'),
                  subtitle: Text(e.toString()),
                ),
              ),
              data: (posts) {
                // Client-side filter (for demo — real app would pass params to API)
                var filtered = posts;
                if (_filterParams != null) {
                  for (final w in _filterParams!.wheres) {
                    if (w.operator == 'like') {
                      final q = w.value.toString().replaceAll('%', '').toLowerCase();
                      filtered = filtered.where((p) => p.title.toLowerCase().contains(q)).toList();
                    } else if (w.column == 'status' && w.operator == '=') {
                      filtered = filtered.where((p) => p.status == w.value).toList();
                    }
                  }
                }

                // Paginate client-side
                final perPage = _tableSchema.perPage;
                final start = (_page - 1) * perPage;
                final pageData = filtered.skip(start).take(perPage).toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: TableRenderer<Post>(
                    schema: TableSchema(
                      columns: _tableSchema.columns,
                      actions: [
                        TableAction(
                          key: 'edit',
                          label: 'Edit',
                          icon: const Icon(FIcons.pencil),
                          onPressed: (post) => _pushEdit(context, post),
                        ),
                        TableAction(
                          key: 'delete',
                          label: 'Delete',
                          icon: const Icon(FIcons.trash2),
                          destructive: true,
                          onPressed: (post) => _confirmDelete(context, post),
                        ),
                      ],
                      selectable: _tableSchema.selectable,
                      perPage: perPage,
                    ),
                    data: pageData,
                    totalCount: filtered.length,
                    currentPage: _page,
                    onPageChanged: (p) => setState(() => _page = p),
                    isLoading: deleteState.isLoading,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pushCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _PostFormPage(
          title: 'Create Post',
          onSubmit: (data) async {
            final notifier = ref.read(createProvider<Post, int>(postService).notifier);
            await notifier.mutate(data);
            ref.invalidate(_listProvider);
          },
        ),
      ),
    );
  }

  void _pushEdit(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _PostFormPage(
          title: 'Edit Post #${post.id}',
          initialValues: {
            'title': post.title,
            'content': post.content,
            'slug': post.slug,
            'status': post.status,
          },
          onSubmit: (data) async {
            final notifier = ref.read(updateProvider<Post, int>(postService).notifier);
            await notifier.mutate(post.id, data);
            ref.invalidate(_listProvider);
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Post post) async {
    final confirmed = await showFDialog<bool>(
      context: context,
      builder: (ctx, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Delete Post'),
        body: Text('Delete "${post.title}"? This cannot be undone.'),
        actions: [
          FButton(
            size: .sm,
            variant: .destructive,
            child: const Text('Delete'),
            onPress: () => Navigator.of(ctx).pop(true),
          ),
          FButton(
            size: .sm,
            variant: .outline,
            child: const Text('Cancel'),
            onPress: () => Navigator.of(ctx).pop(false),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(_deleteNotifier.notifier).mutate(post.id);
      ref.invalidate(_listProvider);
    }
  }
}

/// Reusable form page for create/edit.
class _PostFormPage extends StatelessWidget {
  const _PostFormPage({
    required this.title,
    required this.onSubmit,
    this.initialValues = const {},
  });

  final String title;
  final Map<String, dynamic> initialValues;
  final Future<void> Function(Map<String, dynamic> data) onSubmit;

  @override
  Widget build(BuildContext context) {
    final schema = postResource.form!.build();

    return FScaffold(
      header: FHeader.nested(
        title: Text(title),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormRenderer(
          schema: schema,
          initialValues: initialValues,
          submitLabel: initialValues.isEmpty ? 'Create' : 'Update',
          onSubmit: (data) async {
            await onSubmit(data);
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
