/// dev_command.dart
///
/// Implements the `dev` CLI command.
///
/// Runs the example app via `flutter run`. This is a sequential command —
/// only one app can be run at a time.
///
/// Usage:
///   dart run tool/cli.dart dev
///   ./bin/cli dev --app=my_app
library;

import '../core/logger.dart';
import '../core/runner.dart';
import '../utils/paths.dart';

/// Runs the Flutter app specified by [appName].
///
/// [appName] auto-discovered from apps/ when not provided.
/// The app must exist under `apps/[appName]/`.
/// [extraArgs] are forwarded directly to `flutter run` (e.g. `-d chrome`).
Future<void> runDev({
  required String appName,
  List<String> extraArgs = const [],
}) async {
  Logger.step('Starting $appName...');

  // Run flutter run from the app directory so that the correct
  // pubspec.yaml and assets are picked up.
  await ProcessRunner.run('flutter', [
    'run',
    ...extraArgs,
  ], workingDirectory: WorkspacePaths.app(appName));
}
