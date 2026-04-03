/// hooks_command.dart
///
/// Implements the `hooks:install` CLI command.
///
/// Configures git to use the `.githooks/` directory for hook scripts.
/// This is a one-time setup step each developer runs after cloning the repo.
///
/// Usage:
///   dart run tool/cli.dart hooks:install

import '../core/logger.dart';
import '../core/runner.dart';

/// Installs the workspace git hooks by pointing git at `.githooks/`.
///
/// Runs `git config core.hooksPath .githooks` in the repo root.
/// After this, git will execute `.githooks/pre-commit` before every commit.
Future<void> runHooksInstall() async {
  Logger.step('Installing git hooks...');

  await ProcessRunner.run('git', ['config', 'core.hooksPath', '.githooks']);

  Logger.success('Git hooks installed from .githooks/');
  Logger.dim('pre-commit: format check + analyze');
}
