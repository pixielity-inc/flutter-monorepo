// ignore_for_file: lines_longer_than_80_chars

import '../builder/filter_builder.dart';
import '../builder/form_builder.dart';
import '../builder/table_builder.dart';
import '../service/base_service.dart';

/// Defines a resource — the central metadata object that ties together
/// a service, form schema, table schema, filter schema, and display metadata.
///
/// ```dart
/// final postResource = Resource<Post, String>(
///   name: 'posts',
///   service: postService,
///   form: FormBuilder()
///     .text('title', label: 'Title')
///     .number('price', label: 'Price'),
///   table: TableBuilder<Post>()
///     .column('title', label: 'Title', sortable: true)
///     .column('status', label: 'Status', width: 120),
///   filter: FilterBuilder()
///     .search('q', placeholder: 'Search posts...')
///     .select('status', options: [...]),
///   meta: ResourceMeta(label: 'Posts'),
/// );
/// ```
class Resource<T, ID> {
  /// Creates a [Resource].
  const Resource({
    required this.name,
    required this.service,
    this.form,
    this.table,
    this.filter,
    this.meta,
  });

  /// Unique resource name — used as route prefix and registry key.
  final String name;

  /// The service instance that handles business logic for this resource.
  final BaseService<T, ID> service;

  /// Optional form schema built with [FormBuilder].
  final FormBuilder? form;

  /// Optional table schema built with [TableBuilder].
  final TableBuilder<T>? table;

  /// Optional filter schema built with [FilterBuilder].
  final FilterBuilder? filter;

  /// Optional display metadata (label, icon, etc.).
  final ResourceMeta? meta;
}

/// Display metadata for a [Resource].
class ResourceMeta {
  /// Creates a [ResourceMeta].
  const ResourceMeta({this.label, this.icon});

  /// Human-readable label shown in UI (e.g. sidebar, page titles).
  final String? label;

  /// Optional icon widget — typed as [Object] to avoid a hard Flutter
  /// dependency at this layer; cast to [Widget] in the UI layer.
  final Object? icon;
}
