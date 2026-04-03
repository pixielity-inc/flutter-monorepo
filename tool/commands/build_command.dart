/// build_command.dart
///
/// Implements the `build` CLI command.
///
/// Builds the specified Flutter app. Sequential — not parallelized —
/// because builds are CPU/memory intensive and can conflict when run
/// simultaneously across multiple apps.
///
/// Usage:
///   dart run tool/cli.dart build
///   dart run tool/cli.dart build --app=example_app --target=apk

import '../core/logger.dart';
import '../core/runner.dart';
import '../utils/paths.dart';

/// Builds the Flutter app specified by [appName] for the given [target].
///
/// [appName] defaults to `example_app`.
/// [target] defaults to `apk`. Other valid values: `ios`, `web`, `macos`, etc.
Future<void> runBuild({
  String appName = 'example_app',
  String target = 'apk',
}) async {
  Logger.step('Building $appName ($target)...');

  await ProcessRunner.run(
    'flutter',
    ['build', target],
    workingDirectory: WorkspacePaths.app(appName),
  );

  Logger.success('Build complete.');
}
