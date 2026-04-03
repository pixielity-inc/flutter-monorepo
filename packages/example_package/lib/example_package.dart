/// example_package
///
/// Canonical domain-layer package for the Flutter monorepo.
///
/// Exports the public API surface:
/// - [ExampleItem]       — the core domain entity
/// - [ExampleRepository] — the repository interface (abstract)
/// - [GetExampleItems]   — the use case that fetches items
///
/// Usage:
/// ```dart
/// import 'package:example_package/example_package.dart';
/// ```
// ignore_for_file: comment_references
// (ExampleItem, ExampleRepository, GetExampleItems are re-exported from this
// library but the analyzer cannot resolve cross-file doc references in barrel
// files without the ignore.)

library;

export 'src/domain/entities/example_item.dart';
export 'src/domain/repositories/example_repository.dart';
export 'src/domain/usecases/get_example_items.dart';
