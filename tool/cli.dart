/// cli.dart
///
/// Entry point for the Flutter Monorepo Dart CLI.
///
/// This CLI is the developer experience (DX) layer on top of Melos.
/// It provides familiar, short commands (similar to Laravel Artisan or
/// the NestJS CLI) that orchestrate Melos scripts and Flutter tooling.
///
/// Usage:
///   dart run tool/cli.dart <command> [options]
///
/// Run `dart run tool/cli.dart help` to see all available commands.
library;

import 'dart:io';

import 'commands/build_command.dart';
import 'commands/clean_command.dart';
import 'commands/dev_command.dart';
import 'commands/feature_command.dart';
import 'commands/format_command.dart';
import 'commands/gen_command.dart';
import 'commands/hooks_command.dart';
import 'commands/lint_command.dart';
import 'commands/pipeline_command.dart';
import 'commands/test_command.dart';
import 'commands/version_command.dart';
import 'core/logger.dart';
import 'utils/paths.dart';

/// Returns the default app name by auto-discovering the first app in apps/.
/// Exits with an error if no apps are found.
String _defaultApp() {
  final app = WorkspacePaths.defaultApp;
  if (app == null) {
    Logger.error('No apps found in apps/. Create one first.');
    exit(1);
  }
  return app;
}

/// CLI entry point.
///
/// Parses the first positional argument as the command name and dispatches
/// to the appropriate command handler. Unknown commands print the help text.
Future<void> main(List<String> args) async {
  // Show help when no command is provided.
  if (args.isEmpty) {
    _printHelp();
    return;
  }

  final command = args.first;

  // Optional flags parsed from remaining args.
  final rest = args.skip(1).toList();

  try {
    switch (command) {
      // -----------------------------------------------------------------------
      // Core commands
      // -----------------------------------------------------------------------

      case 'dev':
        // Optional: --app=<name>
        // All other flags (e.g. -d chrome, --release) are forwarded to flutter run.
        final appName = _flag(rest, 'app') ?? _defaultApp();
        final extraArgs = _extraArgs(rest, {'app'});
        await runDev(appName: appName, extraArgs: extraArgs);

      case 'build':
        // Optional: --app=<name> --target=<apk|ios|web|...>
        final appName = _flag(rest, 'app') ?? _defaultApp();
        final target = _flag(rest, 'target') ?? 'apk';
        await runBuild(appName: appName, target: target);

      case 'lint':
        await runLint();

      case 'format':
        // Optional: --check (CI mode — fail if files are unformatted)
        final check = rest.contains('--check');
        await runFormat(check: check);

      case 'test':
        await runTest();

      case 'gen':
        await runGen();

      case 'clean':
        await runClean();

      case 'hooks:install':
        await runHooksInstall();

      // -----------------------------------------------------------------------
      // Versioning & publishing
      // -----------------------------------------------------------------------

      case 'version':
        final dryRun = !rest.contains('--no-dry-run');
        await runVersion(dryRun: dryRun);

      case 'publish':
        final dryRun = !rest.contains('--no-dry-run');
        await runPublish(dryRun: dryRun);

      // -----------------------------------------------------------------------
      // Scaffolding
      // -----------------------------------------------------------------------

      case 'feature':
        // Required: feature name as second positional arg
        if (rest.isEmpty) {
          Logger.error('Usage: dart run tool/cli.dart feature <name>');
          exit(1);
        }
        await runFeature(rest.first);

      // -----------------------------------------------------------------------
      // Pipelines
      // -----------------------------------------------------------------------

      case 'pipeline:ci':
        await runPipelineCi();

      case 'pipeline:dev':
        final appName = _flag(rest, 'app') ?? _defaultApp();
        await runPipelineDev(appName: appName);

      case 'pipeline:release':
        final appName = _flag(rest, 'app') ?? _defaultApp();
        final target = _flag(rest, 'target') ?? 'apk';
        await runPipelineRelease(appName: appName, target: target);

      // -----------------------------------------------------------------------
      // Help
      // -----------------------------------------------------------------------

      case 'help':
      case '--help':
      case '-h':
        _printHelp();

      default:
        Logger.error('Unknown command: "$command"');
        Logger.newline();
        _printHelp();
        exit(1);
    }
  } on ArgumentError catch (e) {
    // Validation errors from commands (e.g. invalid feature name).
    Logger.error(e.message.toString());
    exit(1);
  } catch (e) {
    // Unexpected errors — print and exit with failure code.
    Logger.error('Unexpected error: $e');
    exit(1);
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Extracts the value of a named flag from [args].
///
/// Supports both `--key=value` and `--key value` formats.
/// Returns `null` if the flag is not present.
String? _flag(List<String> args, String key) {
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];

    // --key=value format
    if (arg.startsWith('--$key=')) {
      return arg.substring('--$key='.length);
    }

    // --key value format
    if (arg == '--$key' && i + 1 < args.length) {
      return args[i + 1];
    }
  }
  return null;
}

/// Collects all args that are NOT consumed by [_flag] for the given [knownKeys].
///
/// Returns a list of args to forward to the underlying command.
/// Example:
///   _extraArgs(['--app=foo', '-d', 'chrome', '--release'], {'app'})
///   → ['-d', 'chrome', '--release']
List<String> _extraArgs(List<String> args, Set<String> knownKeys) {
  final extra = <String>[];
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    var consumed = false;
    for (final key in knownKeys) {
      if (arg.startsWith('--$key=')) {
        consumed = true;
        break;
      }
      if (arg == '--$key' && i + 1 < args.length) {
        consumed = true;
        i++; // skip the value too
        break;
      }
    }
    if (!consumed) {
      extra.add(arg);
    }
  }
  return extra;
}

/// Prints the CLI help text to stdout.
void _printHelp() {
  // ignore: avoid_print
  print('''
Flutter Monorepo CLI

Usage:
  dart run tool/cli.dart <command> [options]

Core Commands:
  dev                     Run the Flutter app (default: first app in apps/)
                            --app=<name>     App to run
                            Extra flags are forwarded to flutter run
                            e.g. ./bin/cli dev -d chrome --release
  build                   Build the Flutter app
                            --app=<name>     App to build
                            --target=<t>     Build target (apk, ios, web...)
  lint                    Analyze all packages (parallel)
  format                  Format all Dart files (parallel)
                            --check          Fail if files are unformatted (CI)
  test                    Run all tests (parallel)
  gen                     Run code generation (sequential)
  clean                   Clean build artifacts (parallel)

Versioning & Publishing:
  version                 Bump versions via Conventional Commits (dry-run by default)
                            --no-dry-run     Actually write version changes
  publish                 Publish changed packages to pub.dev (dry-run by default)
                            --no-dry-run     Actually upload to pub.dev

Scaffolding:
  feature <name>          Scaffold a new feature package under packages/features/

Setup:
  hooks:install           Install git pre-commit hook (format + lint on commit)

Pipelines:
  pipeline:ci             gen → lint + test (parallel)
  pipeline:dev            gen → dev
  pipeline:release        gen → lint → test → build
                            --app=<name>     App to build
                            --target=<t>     Build target

Help:
  help                    Show this help message

Examples:
  dart run tool/cli.dart dev
  dart run tool/cli.dart lint
  dart run tool/cli.dart feature auth
  dart run tool/cli.dart pipeline:ci
  ./bin/cli build --app=my_app --target=apk
''');
}
