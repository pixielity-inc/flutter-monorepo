/// runner.dart
///
/// Provides [ProcessRunner], the core process execution engine for the CLI.
///
/// All CLI commands delegate to [ProcessRunner.run] to execute shell processes.
/// This centralizes process management, error handling, and output streaming
/// in one place — making it easy to add features like dry-run mode or
/// command logging later.

import 'dart:io';

import 'logger.dart';

/// Executes shell processes on behalf of CLI commands.
///
/// Uses [Process.start] with [ProcessStartMode.inheritStdio] so that the
/// child process streams its output directly to the terminal in real time,
/// giving the same experience as running the command manually.
abstract final class ProcessRunner {
  /// Runs [executable] with [arguments] in the given [workingDirectory].
  ///
  /// - [executable]        — the program to run (e.g. `melos`, `flutter`)
  /// - [arguments]         — command-line arguments passed to the executable
  /// - [workingDirectory]  — directory to run the process in; defaults to
  ///                         the current working directory when `null`
  ///
  /// Streams stdout and stderr directly to the terminal via
  /// [ProcessStartMode.inheritStdio].
  ///
  /// Exits the Dart process with the child's exit code if it is non-zero,
  /// ensuring that pipeline commands (e.g. `pipeline:ci`) stop on failure.
  ///
  /// Throws a [ProcessException] if the executable cannot be found.
  static Future<void> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
  }) async {
    // Log the command being executed for transparency.
    Logger.dim('> $executable ${arguments.join(' ')}');

    final process = await Process.start(
      executable,
      arguments,
      // Inherit stdio so the child process output appears in the terminal
      // exactly as if the user ran the command themselves.
      mode: ProcessStartMode.inheritStdio,
      workingDirectory: workingDirectory,
    );

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      // Log the failure before exiting so the user knows which command failed.
      Logger.error(
        'Command failed with exit code $exitCode: '
        '$executable ${arguments.join(' ')}',
      );
      exit(exitCode);
    }
  }
}
