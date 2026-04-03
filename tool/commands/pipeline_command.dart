/// pipeline_command.dart
///
/// Implements the `pipeline:*` CLI commands.
///
/// Pipelines are dependency-aware task sequences inspired by TurboRepo.
/// Each pipeline runs steps in the correct order — sequential where required,
/// parallel where safe — so developers never have to think about ordering.
///
/// Available pipelines:
///   pipeline:ci       — gen → lint + test (parallel)
///   pipeline:dev      — gen → dev
///   pipeline:release  — gen → lint → test → build

import '../core/logger.dart';
import 'build_command.dart';
import 'dev_command.dart';
import 'gen_command.dart';
import 'lint_command.dart';
import 'test_command.dart';

/// Runs the CI pipeline: code generation → lint + test in parallel.
///
/// Step order:
///   1. `gen`  — sequential (file conflicts if parallel)
///   2. `lint` — parallel (read-only, safe)
///   3. `test` — parallel (isolated per package)
///
/// Steps 2 and 3 are awaited concurrently using [Future.wait].
Future<void> runPipelineCi() async {
  Logger.step('Pipeline: CI');
  Logger.newline();

  // Step 1 — code generation must complete before lint/test can run
  // because generated files (*.g.dart, *.freezed.dart) are required
  // for the analyzer and tests to pass.
  await runGen();
  Logger.newline();

  // Steps 2 & 3 — lint and test are independent; run them concurrently
  // to minimize total pipeline time.
  Logger.step('Running lint and test in parallel...');
  await Future.wait([
    runLint(),
    runTest(),
  ]);

  Logger.newline();
  Logger.success('Pipeline CI complete.');
}

/// Runs the dev pipeline: code generation → flutter run.
///
/// Step order:
///   1. `gen` — ensures generated files are up to date before running
///   2. `dev` — launches the app
Future<void> runPipelineDev({String appName = 'example_app'}) async {
  Logger.step('Pipeline: Dev');
  Logger.newline();

  // Regenerate before running to avoid stale generated code errors.
  await runGen();
  Logger.newline();

  await runDev(appName: appName);
}

/// Runs the release pipeline: gen → lint → test → build.
///
/// Step order (all sequential — each step gates the next):
///   1. `gen`   — generate code
///   2. `lint`  — fail fast on analysis errors
///   3. `test`  — fail fast on test failures
///   4. `build` — produce the release artifact
///
/// This mirrors a typical CI/CD release gate.
Future<void> runPipelineRelease({
  String appName = 'example_app',
  String target = 'apk',
}) async {
  Logger.step('Pipeline: Release');
  Logger.newline();

  await runGen();
  Logger.newline();

  await runLint();
  Logger.newline();

  await runTest();
  Logger.newline();

  await runBuild(appName: appName, target: target);

  Logger.newline();
  Logger.success('Pipeline Release complete. Artifact ready.');
}
