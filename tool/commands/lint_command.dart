/// lint_command.dart
///
/// Implements the `lint` CLI command.
///
/// Runs `flutter analyze` across all packages in parallel using Melos.
/// Safe to parallelize because analysis is read-only and stateless.
///
/// Usage:
///   dart run tool/cli.dart lint

import '../core/logger.dart';
import '../core/runner.dart';

/// Analyzes all packages in the monorepo for lint and type errors.
///
/// Uses `--parallel --concurrency=4` to run analysis across packages
/// simultaneously, matching TurboRepo-style task execution.
Future<void> runLint() async {
  Logger.step('Analyzing all packages...');

  await ProcessRunner.run('melos', [
    'exec',
    '-c', '4',
    '--',
    'flutter',
    'analyze',
  ]);

  Logger.success('Lint passed.');
}
