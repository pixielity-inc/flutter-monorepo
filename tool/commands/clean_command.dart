/// clean_command.dart
///
/// Implements the `clean` CLI command.
///
/// Runs `flutter clean` across all packages in parallel to remove build
/// artifacts. Safe to parallelize because each package's build directory
/// is independent.
///
/// Usage:
///   dart run tool/cli.dart clean

import '../core/logger.dart';
import '../core/runner.dart';

/// Cleans build artifacts across all packages in the monorepo.
///
/// Uses `--parallel --concurrency=4` for speed.
Future<void> runClean() async {
  Logger.step('Cleaning all packages...');

  await ProcessRunner.run('melos', [
    'exec',
    '-c', '4',
    '--',
    'flutter',
    'clean',
  ]);

  Logger.success('Clean complete.');
}
