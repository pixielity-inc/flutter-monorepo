/// logger.dart
///
/// Provides [Logger], a simple colored terminal output utility for the CLI.
///
/// Uses ANSI escape codes to colorize output. Colors are automatically
/// disabled when stdout is not a terminal (e.g. CI environments) to keep
/// log output clean and parseable.

// ignore_for_file: avoid_print

import 'dart:io';

/// ANSI color codes used for terminal output.
///
/// Each constant is a string that, when printed before text, changes the
/// terminal foreground color. [reset] restores the default color.
abstract final class _Ansi {
  /// Resets all ANSI formatting.
  static const reset = '\x1B[0m';

  /// Bold text.
  static const bold = '\x1B[1m';

  /// Green — used for success messages.
  static const green = '\x1B[32m';

  /// Yellow — used for warnings and step headers.
  static const yellow = '\x1B[33m';

  /// Red — used for errors.
  static const red = '\x1B[31m';

  /// Cyan — used for informational messages.
  static const cyan = '\x1B[36m';

  /// Gray — used for secondary/dim output.
  static const gray = '\x1B[90m';
}

/// A minimal logger that writes colored output to stdout/stderr.
///
/// Color output is automatically suppressed when the terminal does not
/// support ANSI codes (e.g. when piping output in CI).
///
/// Usage:
/// ```dart
/// Logger.info('Running lint...');
/// Logger.success('All checks passed.');
/// Logger.error('Build failed.');
/// ```
abstract final class Logger {
  /// Whether the current stdout supports ANSI color codes.
  static final bool _supportsColor = stdout.supportsAnsiEscapes;

  /// Wraps [text] with the given ANSI [code] if color is supported.
  static String _colorize(String code, String text) =>
      _supportsColor ? '$code$text${_Ansi.reset}' : text;

  /// Prints a cyan informational message to stdout.
  static void info(String message) =>
      print(_colorize(_Ansi.cyan, 'ℹ $message'));

  /// Prints a bold yellow step header to stdout.
  ///
  /// Use this to mark the start of a major CLI step.
  static void step(String message) =>
      print(_colorize('${_Ansi.bold}${_Ansi.yellow}', '▶ $message'));

  /// Prints a green success message to stdout.
  static void success(String message) =>
      print(_colorize(_Ansi.green, '✔ $message'));

  /// Prints a yellow warning message to stdout.
  static void warning(String message) =>
      print(_colorize(_Ansi.yellow, '⚠ $message'));

  /// Prints a red error message to stderr.
  static void error(String message) =>
      stderr.writeln(_colorize(_Ansi.red, '✖ $message'));

  /// Prints a gray dim message to stdout.
  ///
  /// Use for secondary output that should not distract from main messages.
  static void dim(String message) =>
      print(_colorize(_Ansi.gray, '  $message'));

  /// Prints an empty line for visual spacing.
  static void newline() => print('');
}
