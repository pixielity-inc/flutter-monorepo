/// pixielity_config
///
/// Laravel/NestJS-style configuration system for the Pixielity Flutter
/// monorepo.
///
/// ## How it works
///
/// 1. Config files live in `apps/<app>/config/` — one file per concern.
///    Each file is a plain Dart function returning `Map<String, dynamic>`.
///
/// 2. [Config.load] is called once in `main()` with all section maps.
///
/// 3. [Config.get] reads any value anywhere using dot-notation.
///
/// ## Usage
///
/// ```dart
/// // main.dart
/// Config.load({
///   'app':           appConfig(),
///   'api':           apiConfig(),
///   'auth':          authConfig(),
///   'theme':         themeConfig(),
///   'storage':       storageConfig(),
///   'analytics':     analyticsConfig(),
///   'logging':       loggingConfig(),
///   'feature_flags': featureFlagsConfig(),
/// });
///
/// // Anywhere in the app
/// Config.get<String>('api.baseUrl')
/// Config.get<bool>('analytics.enabled', fallback: false)
/// Config.get<int>('api.connectTimeoutSeconds', fallback: 10)
/// Config.has('app.sentryDsn')
/// Config.section('api')
/// ```

library;

import 'package:config/pixielity_config.dart' show Config;
import 'package:config/src/config.dart' show Config;

export 'src/config.dart';
