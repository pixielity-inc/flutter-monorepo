/// paths.dart
///
/// Workspace path helpers for the Dart CLI.
///
/// All paths are resolved relative to the monorepo root, which is determined
/// by locating the `melos.yaml` file. This makes the CLI work correctly
/// regardless of which directory the user runs it from.

import 'dart:io';

/// Utility class for resolving paths within the monorepo workspace.
///
/// Usage:
/// ```dart
/// final appsDir = WorkspacePaths.apps;
/// final packagesDir = WorkspacePaths.packages;
/// ```
abstract final class WorkspacePaths {
  /// The absolute path to the monorepo root directory.
  ///
  /// Determined by walking up from the current working directory until
  /// a `melos.yaml` file is found. Throws a [StateError] if the root
  /// cannot be located (e.g. the CLI is run outside the monorepo).
  static String get root {
    var dir = Directory.current;

    // Walk up the directory tree looking for melos.yaml.
    while (true) {
      final melosFile = File('${dir.path}/melos.yaml');
      if (melosFile.existsSync()) return dir.path;

      final parent = dir.parent;

      // Stop if we've reached the filesystem root without finding melos.yaml.
      if (parent.path == dir.path) {
        throw StateError(
          'Could not locate melos.yaml. '
          'Make sure you are running the CLI from within the monorepo.',
        );
      }

      dir = parent;
    }
  }

  /// Absolute path to the `apps/` directory.
  static String get apps => '$root/apps';

  /// Absolute path to the `packages/` directory.
  static String get packages => '$root/packages';

  /// Absolute path to the `tool/` directory.
  static String get tool => '$root/tool';

  /// Returns the absolute path to a named app under `apps/`.
  ///
  /// Example: `WorkspacePaths.app('example_app')` → `/path/to/repo/apps/example_app`
  static String app(String name) => '$apps/$name';

  /// Returns the absolute path to a named package under `packages/`.
  ///
  /// Example: `WorkspacePaths.package('example_package')` → `/path/to/repo/packages/example_package`
  static String package(String name) => '$packages/$name';
}
