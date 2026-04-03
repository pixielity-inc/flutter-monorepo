/// format_command.dart
///
/// Implements the `format` CLI command.
///
/// Runs `dart format` across all packages in parallel. Safe to parallelize
/// because each package's files are independent.
///
/// Usage:
///   dart run tool/cli.dart format

import '../core/logger.dart';
import '../core/runner.dart';

/// Formats all Dart source files across the monorepo.
///
/// Uses `--parallel --concurrency=4` for speed.
/// Passes `--set-exit-if-changed` so CI fails when files are unformatted.
Future<void> runFormat({bool check = false}) async {
  Logger.step(check ? 'Checking formatting...' : 'Formatting all packages...');

  // When `check` is true (e.g. in CI), fail if any file would be reformatted.
  final formatArgs = check
      ? ['format', '--set-exit-if-changed', '.']
      : ['format', '.'];

  await ProcessRunner.run('melos', [
    'exec',
    '-c', '4',
    '--',
    'dart',
    ...formatArgs,
  ]);

  Logger.success(check ? 'All files are correctly formatted.' : 'Format complete.');
}
