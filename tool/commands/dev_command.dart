// ignore_for_file: lines_longer_than_80_chars
/// dev_command.dart
///
/// Implements the `dev` CLI command.
///
/// Runs the Flutter app via `flutter run` with the correct dart-define
/// values loaded from the app's environments/ folder.
///
/// The command resolves the environment file in this order:
///   1. `--env=<name>` flag  → environments/.dart-define.<name>
///   2. `ENV` dart-define already in extraArgs
///   3. Falls back to `development`
///
/// Usage:
///   dart run tool/cli.dart dev
///   dart run tool/cli.dart dev --env=staging
///   dart run tool/cli.dart dev --env=production --app=my_app
///   dart run tool/cli.dart dev -d chrome
///   ./bin/cli dev --env=staging -d web-server
library;

import 'dart:io';

import '../core/logger.dart';
import '../core/runner.dart';
import '../utils/paths.dart';

/// Runs the Flutter app specified by [appName] with dart-define values
/// loaded from the matching environment file.
///
/// [appName] is auto-discovered from apps/ when not provided.
/// [env] selects the environment file:
///   - `development` → environments/.dart-define.development
///   - `staging`     → environments/.dart-define.staging
///   - `production`  → environments/.dart-define.production
///
/// [extraArgs] are forwarded directly to `flutter run`
/// (e.g. `-d chrome`, `--release`, `--hot`).
///
/// The environment file is passed via `--dart-define-from-file` so every
/// key in the file is injected at compile time without needing to list
/// them individually.
Future<void> runDev({
  required String appName,
  String env = 'development',
  List<String> extraArgs = const [],
}) async {
  Logger.step('Starting $appName in $env mode...');
  Logger.info(
    'dart-define values are compile-time constants.\n'
    '  Hot reload (r) and hot restart (R) will NOT pick up env changes.\n'
    '  To switch environments: stop the app (Ctrl+C) and run again with --env=<env>.',
  );

  final appDir = WorkspacePaths.app(appName);

  // ── Resolve the dart-define file ──────────────────────────────────────────

  final envFile = _resolveEnvFile(appDir: appDir, env: env);
  // Build the flutter run argument list.
  final flutterArgs = <String>[
    'run',
    // Inject all dart-define keys from the environment file if it exists.
    if (envFile != null) '--dart-define-from-file=${envFile.path}',
    // Forward any extra flags the caller passed (e.g. -d chrome, --release).
    ...extraArgs,
  ];

  Logger.info('Environment file: ${envFile?.path ?? '(none — using defaults)'}');
  Logger.info('Running: flutter ${flutterArgs.join(' ')}');

  await ProcessRunner.run(
    'flutter',
    flutterArgs,
    workingDirectory: appDir,
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Resolves the dart-define environment file for [env].
///
/// Accepts both short aliases and full names:
///   dev  / development → .dart-define.development
///   stg  / staging     → .dart-define.staging
///   prod / production  → .dart-define.production
///
/// Looks for `environments/.dart-define.<resolved>` inside [appDir].
/// Returns `null` if the file does not exist, and logs a warning so the
/// developer knows they need to create it from the `.example` template.
File? _resolveEnvFile({required String appDir, required String env}) {
  // Normalise short aliases to their full environment name.
  final resolved = switch (env.toLowerCase()) {
    'dev'  || 'development' => 'development',
    'stg'  || 'staging'     => 'staging',
    'prod' || 'production'  => 'production',
    _                       => env,
  };

  final path = '$appDir/environments/.dart-define.$resolved';
  final file = File(path);

  if (file.existsSync()) {
    return file;
  }

  // File not found — warn and suggest the setup step.
  Logger.warning(
    'Environment file not found: $path\n'
    '  Create it by copying the example:\n'
    '  cp $appDir/environments/.dart-define.example $path\n'
    '  Then fill in the values for the $resolved environment.',
  );

  return null;
}
