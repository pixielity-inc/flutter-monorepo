// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_refine/pixielity_refine.dart';
import 'category_model.dart';
import 'category_repository.dart';
import 'login_page.dart';
import 'post_model.dart';
import 'post_resource.dart';

/// The main shell for the full Refine demo app.
///
/// Provides sidebar navigation, header with user info, bottom nav for mobile,
/// and switches between Dashboard, Posts, and Categories tabs.
class RefineShell extends ConsumerStatefulWidget {
  /// Creates a [RefineShell].
  const RefineShell({super.key, required this.onLogout});

  /// Called when the user logs out.
  final VoidCallback onLogout;

  @override
  ConsumerState<RefineShell> createState() => _RefineShellState();
}

class _RefineShellState extends ConsumerState<RefineShell> {
  int _selectedIndex = 0;

  static const _routes = ['/dashboard', '/posts', '/categories'];

  final _navSchema = NavigationBuilder()
      .item(
        'dashboard',
        label: 'Dashboard',
        icon: const Icon(LucideIcons.layoutDashboard, size: 18),
        route: '/dashboard',
      )
      .group('Resources')
      .item(
        'posts',
        label: 'Posts',
        icon: const Icon(LucideIcons.fileText, size: 18),
        route: '/posts',
      )
      .item(
        'categories',
        label: 'Categories',
        icon: const Icon(LucideIcons.tag, size: 18),
        route: '/categories',
      )
      .build();

  void _onNavigate(String route) {
    final idx = _routes.indexOf(route);
    if (idx >= 0) setState(() => _selectedIndex = idx);
  }

  Future<void> _logout() async {
    await ref.read(authNotifier.notifier).logout();
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifier);
    final identity = auth.identity as Map<String, String>?;
    final theme = context.theme;
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return FScaffold(
      header: FHeader(
        title: const Text('Refine Demo'),
        suffixes: [
          if (identity != null)
            FHeaderAction(
              icon: FAvatar.raw(
                size: 28,
                child: Text(
                  identity['avatar'] ?? '?',
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.primaryForeground,
                  ),
                ),
              ),
              onPress: () {},
            ),
          FHeaderAction(
            icon: const Icon(FIcons.logOut),
            onPress: _logout,
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Sidebar (wide screens only) ─────────────────────────────────
          if (isWide)
            SizedBox(
              width: 240,
              child: NavigationRenderer(
                schema: _navSchema,
                currentRoute: _routes[_selectedIndex],
                onNavigate: _onNavigate,
              ),
            ),
          if (isWide)
            VerticalDivider(
              width: 1,
              color: theme.colors.border,
            ),

          // ── Content area ────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildContent()),
                // ── Bottom nav (narrow screens only) ──────────────────────
                if (!isWide)
                  FBottomNavigationBar(
                    index: _selectedIndex,
                    onChange: (i) => setState(() => _selectedIndex = i),
                    children: const [
                      FBottomNavigationBarItem(
                        icon: Icon(LucideIcons.layoutDashboard),
                        label: Text('Dashboard'),
                      ),
                      FBottomNavigationBarItem(
                        icon: Icon(LucideIcons.fileText),
                        label: Text('Posts'),
                      ),
                      FBottomNavigationBarItem(
                        icon: Icon(LucideIcons.tag),
                        label: Text('Categories'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return switch (_selectedIndex) {
      0 => const _DashboardTab(),
      1 => const _PostsTab(),
      2 => const _CategoriesTab(),
      _ => const SizedBox.shrink(),
    };
  }
}

// ── Dashboard Tab ─────────────────────────────────────────────────────────────

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(listProvider<Post, int>(postService));
    final catsAsync =
        ref.watch(listProvider<Category, int>(categoryService));

    final postCount = postsAsync.whenOrNull(data: (d) => d.length) ?? 0;
    final catCount = catsAsync.whenOrNull(data: (d) => d.length) ?? 0;
    final isLoading = postsAsync.isLoading || catsAsync.isLoading;

    final schema = DashboardBuilder()
        .stat('total_posts', label: 'Total Posts', span: 1)
        .stat('total_categories', label: 'Total Categories', span: 1)
        .stat('published', label: 'Published', span: 1)
        .stat('drafts', label: 'Drafts', span: 1)
        .build();

    final publishedCount = postsAsync.whenOrNull(
          data: (d) => d.where((p) => p.status == 'published').length,
        ) ??
        0;
    final draftCount = postsAsync.whenOrNull(
          data: (d) => d.where((p) => p.status == 'draft').length,
        ) ??
        0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DashboardRenderer(
        schema: schema,
        isLoading: isLoading,
        data: {
          'total_posts': postCount,
          'total_categories': catCount,
          'published': publishedCount,
          'drafts': draftCount,
        },
      ),
    );
  }
}

// ── Posts Tab ──────────────────────────────────────────────────────────────────

class _PostsTab extends ConsumerStatefulWidget {
  const _PostsTab();

  @override
  ConsumerState<_PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends ConsumerState<_PostsTab> {
  late final _listProv = listProvider<Post, int>(postService);
  late final _deleteProv = deleteProvider<Post, int>(postService);
  final _tableSchema = postResource.table!.build();
  final _filterSchema = postResource.filter!.build();
  QueryParams<Post>? _filterParams;
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_listProv);
    final deleteState = ref.watch(_deleteProv);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: FilterRenderer<Post>(
                  schema: _filterSchema,
                  onChanged: (params) =>
                      setState(() => _filterParams = params),
                ),
              ),
              const SizedBox(width: 8),
              FButton(
                size: .sm,
                onPress: () => _pushCreate(context),
                child: const Text('New Post'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const FDivider(),
        Expanded(
          child: async.when(
            loading: () => const Center(child: FCircularProgress()),
            error: (e, _) => Center(
              child: FAlert(
                icon: const Icon(FIcons.circleAlert),
                title: const Text('Failed to load posts'),
                subtitle: Text(e.toString()),
                variant: .destructive,
              ),
            ),
            data: (posts) {
              var filtered = posts;
              if (_filterParams != null) {
                for (final w in _filterParams!.wheres) {
                  if (w.operator == 'like') {
                    final q =
                        w.value.toString().replaceAll('%', '').toLowerCase();
                    filtered = filtered
                        .where(
                          (p) => p.title.toLowerCase().contains(q),
                        )
                        .toList();
                  } else if (w.column == 'status' && w.operator == '=') {
                    filtered = filtered
                        .where((p) => p.status == w.value)
                        .toList();
                  }
                }
              }
              final perPage = _tableSchema.perPage;
              final start = (_page - 1) * perPage;
              final pageData =
                  filtered.skip(start).take(perPage).toList();

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
    );
  }

  void _pushCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _PostFormPage(
          title: 'Create Post',
          onSubmit: (data) async {
            final notifier = ref.read(
              createProvider<Post, int>(postService).notifier,
            );
            await notifier.mutate(data);
            ref.invalidate(_listProv);
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
            final notifier = ref.read(
              updateProvider<Post, int>(postService).notifier,
            );
            await notifier.mutate(post.id, data);
            ref.invalidate(_listProv);
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
    if (confirmed ?? false) {
      await ref.read(_deleteProv.notifier).mutate(post.id);
      ref.invalidate(_listProv);
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

// ── Categories Tab ────────────────────────────────────────────────────────────

class _CategoriesTab extends ConsumerStatefulWidget {
  const _CategoriesTab();

  @override
  ConsumerState<_CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends ConsumerState<_CategoriesTab> {
  late final _listProv = listProvider<Category, int>(categoryService);
  final _tableSchema = categoryResource.table!.build();

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_listProv);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Categories',
                  style: context.theme.typography.lg.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FButton(
                size: .sm,
                onPress: () => ref.invalidate(_listProv),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
        const FDivider(),
        Expanded(
          child: async.when(
            loading: () => const Center(child: FCircularProgress()),
            error: (e, _) => Center(
              child: FAlert(
                icon: const Icon(FIcons.circleAlert),
                title: const Text('Failed to load categories'),
                subtitle: Text(e.toString()),
                variant: .destructive,
              ),
            ),
            data: (categories) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: TableRenderer<Category>(
                schema: _tableSchema,
                data: categories,
                totalCount: categories.length,
                currentPage: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
