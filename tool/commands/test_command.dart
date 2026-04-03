/// test_command.dart
///
/// Implements the `test` CLI command.
///
/// Runs `flutter test` across all packages in parallel. Tests are isolated
/// per package so parallel execution is safe and significantly faster.
///
/// Usage:
///   dart run tool/cli.dart test

import '../core/logger.dart';
import '../core/runner.dart';

/// Runs all tests across the monorepo in parallel.
///
/// Uses `--parallel --concurrency=4` to run package test suites
/// simultaneously, matching TurboRepo-style task execution.
Future<void> runTest() async {
  Logger.step('Running all tests...');

  await ProcessRunner.run('melos', [
    'exec',
    '-c', '4',
    '--',
    'flutter',
    'test',
  ]);

  Logger.success('All tests passed.');
}
