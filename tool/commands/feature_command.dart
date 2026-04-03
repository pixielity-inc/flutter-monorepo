/// feature_command.dart
///
/// Implements the `feature` CLI command.
///
/// Scaffolds a new feature package under `packages/features/<name>/`
/// following the clean architecture layer structure. This is the Flutter
/// equivalent of Laravel Artisan's `make:module` or NestJS's `generate module`.
///
/// Usage:
///   dart run tool/cli.dart feature auth
///   dart run tool/cli.dart feature booking

import 'dart:io';

import '../core/logger.dart';
import '../utils/paths.dart';

/// Scaffolds a new feature package named [featureName].
///
/// Creates the full clean architecture directory tree and stub files:
/// - `data/`        — models, data sources, repository implementations
/// - `domain/`      — entities, repository interfaces, use cases
/// - `presentation/`— pages, widgets, state (Riverpod providers)
///
/// Also generates:
/// - `pubspec.yaml`         — package manifest
/// - `analysis_options.yaml`— inherits root lint rules
/// - `lib/<name>_feature.dart` — public API barrel file
///
/// Throws an [ArgumentError] if [featureName] is empty or contains spaces.
Future<void> runFeature(String featureName) async {
  // Validate the feature name — must be a valid Dart package name.
  if (featureName.isEmpty || featureName.contains(' ')) {
    throw ArgumentError(
      'Feature name must be non-empty and contain no spaces. '
      'Use snake_case (e.g. "auth", "user_profile").',
    );
  }

  final basePath = '${WorkspacePaths.packages}/features/$featureName';

  Logger.step('Scaffolding feature: $featureName');
  Logger.dim('Target: $basePath');

  // ---------------------------------------------------------------------------
  // 1. Create directory structure
  // ---------------------------------------------------------------------------
  final directories = [
    // Data layer — concrete implementations
    'lib/src/data/models',
    'lib/src/data/datasources',
    'lib/src/data/repositories',

    // Domain layer — pure Dart interfaces and logic
    'lib/src/domain/entities',
    'lib/src/domain/repositories',
    'lib/src/domain/usecases',

    // Presentation layer — UI and state
    'lib/src/presentation/pages',
    'lib/src/presentation/widgets',
    'lib/src/presentation/providers',

    // Tests mirror the lib structure
    'test/domain/usecases',
    'test/presentation',
  ];

  for (final dir in directories) {
    await Directory('$basePath/$dir').create(recursive: true);
    Logger.dim('  created $dir/');
  }

  // ---------------------------------------------------------------------------
  // 2. Generate stub files
  // ---------------------------------------------------------------------------
  await _writeFile('$basePath/pubspec.yaml', _pubspecTemplate(featureName));

  await _writeFile(
    '$basePath/analysis_options.yaml',
    _analysisOptionsTemplate(),
  );

  await _writeFile(
    '$basePath/lib/${featureName}_feature.dart',
    _barrelTemplate(featureName),
  );

  await _writeFile(
    '$basePath/lib/src/domain/entities/${featureName}_entity.dart',
    _entityTemplate(featureName),
  );

  await _writeFile(
    '$basePath/lib/src/domain/repositories/${featureName}_repository.dart',
    _repositoryTemplate(featureName),
  );

  await _writeFile(
    '$basePath/lib/src/domain/usecases/get_${featureName}s.dart',
    _useCaseTemplate(featureName),
  );

  Logger.newline();
  Logger.success('Feature "$featureName" scaffolded successfully.');
  Logger.dim('Next steps:');
  Logger.dim('  1. cd $basePath');
  Logger.dim('  2. Add the package to your app\'s pubspec.yaml');
  Logger.dim('  3. Run: dart run tool/cli.dart gen');
}

// ---------------------------------------------------------------------------
// File content templates
// ---------------------------------------------------------------------------

/// Writes [content] to [path], creating parent directories as needed.
Future<void> _writeFile(String path, String content) async {
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
}

/// Generates the `pubspec.yaml` for a new feature package.
String _pubspecTemplate(String name) =>
    '''
# packages/features/$name/pubspec.yaml
#
# Feature package: $name
#
# This package follows the clean architecture pattern:
#   - domain/   — pure Dart entities, interfaces, use cases
#   - data/     — concrete implementations
#   - presentation/ — UI and Riverpod providers

name: ${name}_feature
description: Feature package for $name.
version: 0.1.0
publish_to: none

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  flutter_riverpod: ^2.4.10

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.8
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  very_good_analysis: ^6.0.0
''';

/// Generates the `analysis_options.yaml` for a new feature package.
String _analysisOptionsTemplate() => '''
# analysis_options.yaml
#
# Inherits all rules from the root analysis_options.yaml.

include: ../../../../analysis_options.yaml
''';

/// Generates the barrel/library file for a new feature package.
String _barrelTemplate(String name) {
  return '''
/// ${name}_feature.dart
///
/// Public API for the $name feature package.
///
/// Export only what consuming packages need — keep internals private.
library ${name}_feature;

export 'src/domain/entities/${name}_entity.dart';
export 'src/domain/repositories/${name}_repository.dart';
export 'src/domain/usecases/get_${name}s.dart';
''';
}

/// Generates a stub domain entity for a new feature.
String _entityTemplate(String name) {
  final className = _toPascalCase(name);
  return '''
/// ${name}_entity.dart
///
/// Domain entity for the $name feature.
///
/// Add fields relevant to the $name domain below.
/// Run `dart run tool/cli.dart gen` after modifying this file.

import 'package:freezed_annotation/freezed_annotation.dart';

part '${name}_entity.freezed.dart';
part '${name}_entity.g.dart';

/// Represents a single $name in the domain.
@freezed
class $className with _\$$className {
  /// Creates a [$className].
  const factory $className({
    /// Unique identifier.
    required String id,

    /// Human-readable name.
    required String name,
  }) = _$className;

  /// Deserializes a [$className] from JSON.
  factory $className.fromJson(Map<String, dynamic> json) =>
      _\$${className}FromJson(json);
}
''';
}

/// Generates a stub repository interface for a new feature.
String _repositoryTemplate(String name) {
  final className = _toPascalCase(name);
  return '''
/// ${name}_repository.dart
///
/// Abstract repository interface for the $name feature.
///
/// Concrete implementations live in `data/repositories/`.

import '../entities/${name}_entity.dart';

/// Contract for $name data operations.
abstract interface class ${className}Repository {
  /// Returns all ${name}s.
  Future<List<$className>> getAll();

  /// Returns a single $name by [id], or null if not found.
  Future<$className?> getById(String id);
}
''';
}

/// Generates a stub use case for a new feature.
String _useCaseTemplate(String name) {
  final className = _toPascalCase(name);
  return '''
/// get_${name}s.dart
///
/// Use case: fetch all ${className}s from the repository.

import '../entities/${name}_entity.dart';
import '../repositories/${name}_repository.dart';

/// Fetches all [$className]s via [${className}Repository].
final class Get${className}s {
  /// Creates a [Get${className}s] use case.
  const Get${className}s({required ${className}Repository repository})
      : _repository = repository;

  final ${className}Repository _repository;

  /// Executes the use case.
  Future<List<$className>> execute() => _repository.getAll();
}
''';
}

/// Converts a `snake_case` string to `PascalCase`.
///
/// Example: `user_profile` → `UserProfile`
String _toPascalCase(String input) => input
    .split('_')
    .map(
      (word) =>
          word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}',
    )
    .join();
