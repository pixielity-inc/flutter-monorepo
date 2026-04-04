// ignore_for_file: lines_longer_than_80_chars

import 'package:pixielity_refine/pixielity_refine.dart';
import 'api_client.dart';
import 'post_model.dart';
import 'post_repository.dart';
import 'post_service.dart';

/// Singleton instances wired together.
final _client = ApiClient();
final _repo = PostRepository(_client);

/// The [PostService] instance — exposed for Riverpod providers.
final postService = PostService(_repo);

/// Full resource definition for [Post].
///
/// Ties together the service, form schema, table schema, filter schema,
/// and display metadata.
final postResource = Resource<Post, int>(
  name: 'posts',
  service: postService,
  form: FormBuilder()
      .text('title', label: 'Title', required: true)
      .textarea('content', label: 'Content')
      .text('slug', label: 'Slug')
      .select(
        'status',
        label: 'Status',
        options: [
          FieldOption(value: 'draft', label: 'Draft'),
          FieldOption(value: 'published', label: 'Published'),
          FieldOption(value: 'rejected', label: 'Rejected'),
        ],
      ),
  table: TableBuilder<Post>()
      .column('id', label: 'ID', sortable: true, valueGetter: (p) => p.id)
      .column('title', label: 'Title', sortable: true, valueGetter: (p) => p.title)
      .column('status', label: 'Status', width: 100, valueGetter: (p) => p.status)
      .column('hit', label: 'Views', align: ColumnAlign.right, sortable: true, valueGetter: (p) => p.hit),
  filter: FilterBuilder()
      .search('q', placeholder: 'Search posts...')
      .select(
        'status',
        label: 'Status',
        options: [
          FieldOption(value: 'draft', label: 'Draft'),
          FieldOption(value: 'published', label: 'Published'),
          FieldOption(value: 'rejected', label: 'Rejected'),
        ],
      ),
  meta: const ResourceMeta(label: 'Posts'),
);
