// apps/example_app/lib/main.dart
//
// Entry point — loads config, boots the container, starts the app.
//
// Bootstrap order:
//   1. Config.load()       — load all config files into the registry.
//   2. Application.boot()  — register + boot all service providers.
//   3. runApp()            — start the Flutter widget tree.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixielity_config/pixielity_config.dart';
import 'package:pixielity_container/pixielity_container.dart';
import 'package:pixielity_example_app/app.dart';
import 'package:pixielity_example_app/config/analytics.dart';
import 'package:pixielity_example_app/config/api.dart';
import 'package:pixielity_example_app/config/app.dart';
import 'package:pixielity_example_app/config/auth.dart';
import 'package:pixielity_example_app/config/feature_flags.dart';
import 'package:pixielity_example_app/config/logging.dart';
import 'package:pixielity_example_app/config/storage.dart';
import 'package:pixielity_example_app/config/theme.dart';
import 'package:pixielity_example_app/providers/api_service_provider.dart';
import 'package:pixielity_example_app/providers/core_service_provider.dart';
import 'package:pixielity_example_app/providers/theme_config_bridge.dart';
import 'package:pixielity_ui/pixielity_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load all config sections into the registry.
  Config.load({
    'app':           appConfig(),
    'api':           apiConfig(),
    'auth':          authConfig(),
    'theme':         themeConfig(),
    'storage':       storageConfig(),
    'analytics':     analyticsConfig(),
    'logging':       loggingConfig(),
    'feature_flags': featureFlagsConfig(),
  });

  // 2. Register the theme config bridge so AppTheme.fromConfig() can
  //    read from the Config registry.
  ConfigBridge.register(ThemeConfigBridge());

  // 4. Boot the container — register() then boot() on every provider.
  await Application.boot([
    CoreServiceProvider(),
    ApiServiceProvider(),
  ]);

  // 5. Start the app.
  runApp(
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}
