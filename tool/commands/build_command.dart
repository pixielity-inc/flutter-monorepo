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
///   ./bin/cli build --app=my_app --target=apk

import '../core/logger.dart';
import '../core/runner.dart';
import '../utils/paths.dart';

/// Builds the Flutter app specified by [appName] for the given [target].
///
/// [appName] auto-discovered from apps/.
/// [target] defaults to `apk`. Other valid values: `ios`, `web`, `macos`, etc.
Future<void> runBuild({
  required String appName,
  String target = 'apk',
}) async {
  Logger.step('Building $appName ($target)...');

  await ProcessRunner.run('flutter', [
    'build',
    target,
  ], workingDirectory: WorkspacePaths.app(appName));

  Logger.success('Build complete.');
}
