/// gen_command.dart
///
/// Implements the `gen` CLI command.
///
/// Runs `build_runner build` across all packages SEQUENTIALLY.
/// Code generation must NOT be parallelized because:
/// - build_runner writes to shared `.dart_tool/` caches
/// - Parallel runs can produce conflicting output files
///
/// Usage:
///   dart run tool/cli.dart gen
library;

import '../core/logger.dart';
import '../core/runner.dart';

/// Runs code generation (freezed, json_serializable) across all packages.
///
/// Passes `--delete-conflicting-outputs` to automatically resolve stale
/// generated files without requiring manual intervention.
///
/// Uses `--depends-on=build_runner` to skip packages that don't declare
/// build_runner as a dependency — avoids errors in app packages that have
/// no generated code.
Future<void> runGen() async {
  Logger.step('Running code generation...');
  Logger.dim(
    'Note: code generation runs sequentially to avoid file conflicts.',
  );

  await ProcessRunner.run('melos', [
    'exec',
    '--depends-on=build_runner',
    '--',
    'flutter',
    'pub',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);

  Logger.success('Code generation complete.');
}
