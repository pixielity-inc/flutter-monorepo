// ignore_for_file: lines_longer_than_80_chars
// lib/src/logger_service_provider.dart
//
// LoggerServiceProvider — registers Logger into the IoC container and
// configures transports from Config.

import 'package:config/pixielity_config.dart';
import 'package:container/pixielity_container.dart';
import 'package:logger/src/enums/log_format.dart';
import 'package:logger/src/enums/log_level.dart';
import 'package:logger/src/formatters/compact_formatter.dart';
import 'package:logger/src/formatters/json_formatter.dart';
import 'package:logger/src/formatters/pretty_formatter.dart';
import 'package:logger/src/logger.dart';
import 'package:logger/src/transports/console_transport.dart';
import 'package:logger/src/transports/remote_transport.dart';

/// Registers [Logger] into the IoC container and configures transports.
///
/// ```dart
/// await Application.boot([
///   UiServiceProvider(),
///   LoggerServiceProvider(),
///   CoreServiceProvider(),
/// ]);
/// ```
class LoggerServiceProvider extends ServiceProvider {
  @override
  void register() {
    /*
    |--------------------------------------------------------------------------
    | Logger
    |--------------------------------------------------------------------------
    |
    | Registers the Logger as a singleton in the IoC container.
    | Resolve via App.make<Logger>() or use the global Log facade.
    |
    */

    App.instance<Logger>(Logger());
  }

  @override
  Future<void> boot() async {
    /*
    |--------------------------------------------------------------------------
    | Configure
    |--------------------------------------------------------------------------
    |
    | Reads logging.* config values and applies them to the Logger.
    |
    */

    Logger.configure();

    /*
    |--------------------------------------------------------------------------
    | Console Transport
    |--------------------------------------------------------------------------
    |
    | Enabled when logging.enableConsole is true (auto-disabled in prod).
    | The formatter is selected based on logging.format config value.
    |
    */

    if (Config.get<bool>('logging.enableConsole', fallback: true)) {
      final format   = LogFormat.fromString(Config.get<String>('logging.format', fallback: 'pretty'));
      final minLevel = LogLevel.fromString(Config.get<String>('logging.level',   fallback: 'verbose'));

      // Build the correct formatter from the config value.
      final formatter = switch (format) {
        LogFormat.compact => CompactFormatter(),
        LogFormat.json    => const JsonFormatter(),
        LogFormat.pretty  => const PrettyFormatter(),
      };

      Logger.addTransport(ConsoleTransport(formatter: formatter, minLevel: minLevel));
    }

    /*
    |--------------------------------------------------------------------------
    | Remote Transport
    |--------------------------------------------------------------------------
    |
    | Enabled when logging.remote.endpoint is non-empty.
    |
    */

    final remoteEndpoint = Config.get<String>('logging.remote.endpoint', fallback: '');

    if (remoteEndpoint.isNotEmpty) {
      Logger.addTransport(
        RemoteTransport(
          endpoint:      remoteEndpoint,
          apiKey:        Config.get<String>('logging.remote.apiKey',    fallback: ''),
          minLevel:      LogLevel.fromString(Config.get<String>('logging.remote.minLevel', fallback: 'warning')),
          batchSize:     Config.get<int>('logging.remote.batchSize',    fallback: 50),
          flushInterval: Duration(seconds: Config.get<int>('logging.remote.flushIntervalSeconds', fallback: 10)),
        ),
      );
    }

    Log.info(
      'Logger initialised',
      extra: {
        'level':   Config.get<String>('logging.level',       fallback: 'info'),
        'console': Config.get<bool>('logging.enableConsole', fallback: true),
        'remote':  remoteEndpoint.isNotEmpty,
        'format':  Config.get<String>('logging.format',      fallback: 'pretty'),
        'redact':  Config.get<bool>('logging.redactPii',     fallback: true),
      },
    );
  }
}
