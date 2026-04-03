/// dev_command.dart
///
/// Implements the `dev` CLI command.
///
/// Runs the example app via `flutter run`. This is a sequential command —
/// only one app can be run at a time.
///
/// Usage:
///   dart run tool/cli.dart dev
///   dart run tool/cli.dart dev --app=example_app

import '../core/logger.dart';
import '../core/runner.dart';
import '../utils/paths.dart';

/// Runs the Flutter app specified by [appName].
///
/// [appName] defaults to `example_app` when not provided.
/// The app must exist under `apps/[appName]/`.
/// [extraArgs] are forwarded directly to `flutter run` (e.g. `-d chrome`).
Future<void> runDev({
  String appName = 'example_app',
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
