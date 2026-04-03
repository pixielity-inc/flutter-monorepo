/// version_command.dart
///
/// Implements the `version` and `publish` CLI commands.
///
/// `version` — uses Melos to bump package versions based on Conventional
///             Commits and update CHANGELOG.md files automatically.
///
/// `publish` — publishes changed packages to pub.dev.
///             Runs as a dry-run by default; pass `--no-dry-run` to publish.
///
/// Usage:
///   dart run tool/cli.dart version
///   dart run tool/cli.dart publish
///   dart run tool/cli.dart publish --no-dry-run

import '../core/logger.dart';
import '../core/runner.dart';

/// Bumps package versions using Conventional Commits via Melos.
///
/// Melos inspects git history since the last tag, determines the correct
/// semver bump (patch / minor / major) per package, updates each
/// `pubspec.yaml`, and generates / updates `CHANGELOG.md`.
///
/// Pass [dryRun] = true to preview changes without writing anything.
Future<void> runVersion({bool dryRun = false}) async {
  Logger.step(dryRun ? 'Previewing version bumps...' : 'Bumping versions...');

  final args = ['version'];
  if (dryRun) args.add('--dry-run');

  await ProcessRunner.run('melos', args);

  if (!dryRun) Logger.success('Versions bumped and CHANGELOGs updated.');
}

/// Publishes changed packages to pub.dev via Melos.
///
/// By default Melos runs in dry-run mode — pass [dryRun] = false to
/// actually publish. Always runs lint and test gates before publishing
/// (enforced by the CI workflow; not duplicated here to keep the CLI fast).
///
/// Requires valid pub.dev credentials (`dart pub login`).
Future<void> runPublish({bool dryRun = true}) async {
  if (dryRun) {
    Logger.step('Dry-run publish (no packages will be uploaded)...');
    Logger.dim('Pass --no-dry-run to actually publish.');
  } else {
    Logger.step('Publishing packages to pub.dev...');
    Logger.warning('This will upload packages publicly. Ctrl+C to abort.');
  }

  final args = ['publish'];
  if (!dryRun) args.add('--no-dry-run');

  await ProcessRunner.run('melos', args);

  Logger.success(dryRun ? 'Dry-run complete.' : 'Packages published.');
}
