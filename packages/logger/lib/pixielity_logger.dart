/// pixielity_logger
///
/// Structured, multi-transport logger for the Pixielity Flutter monorepo.
///
/// ## Features
/// - Log levels: verbose, debug, info, warning, error, fatal
/// - Transports: console (pretty/compact/json), remote (HTTP batch)
/// - PII redaction: emails, phones, credit cards, IPs
/// - Config-driven: reads all settings from Config.get('logging.*')
/// - IoC integration: registered via LoggerServiceProvider
///
/// ## Usage
///
/// ```dart
/// // main.dart
/// await Application.boot([
///   UiServiceProvider(),
///   LoggerServiceProvider(),
/// ]);
///
/// // Tagged instance
/// final _log = Logger('Auth');
/// _log.info('User logged in');
/// _log.error('Login failed', error: e, stackTrace: st);
///
/// // With context (Laravel-style)
/// Logger('Api').withContext({'requestId': id}).info('Request received');
///
/// // Global facade
/// Log.info('App started');
/// ```

library;

// ── Context ───────────────────────────────────────────────────────────────────
export 'src/context/log_context.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────
export 'src/enums/log_format.dart';
export 'src/enums/log_level.dart';

// ── Formatters ────────────────────────────────────────────────────────────────
export 'src/formatters/compact_formatter.dart';
export 'src/formatters/json_formatter.dart';
export 'src/formatters/pretty_formatter.dart';

// ── Interfaces ────────────────────────────────────────────────────────────────
export 'src/interfaces/log_formatter_interface.dart';
export 'src/interfaces/log_transport_interface.dart';

// ── Core ──────────────────────────────────────────────────────────────────────
export 'src/log_entry.dart';
export 'src/logger.dart';
export 'src/logger_service_provider.dart';
export 'src/pii_redactor.dart';

// ── Transports ────────────────────────────────────────────────────────────────
export 'src/transports/console_transport.dart';
export 'src/transports/remote_transport.dart';
