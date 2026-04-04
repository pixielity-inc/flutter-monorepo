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
import 'package:config/pixielity_config.dart';
import 'package:container/pixielity_container.dart';
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
import 'package:pixielity_example_app/providers/theme_providers.dart';
import 'package:pixielity_example_app/providers/theme_service_provider.dart';
import 'package:logger/pixielity_logger.dart';
import 'package:ui/pixielity_ui.dart';
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
  //    UiServiceProvider must be first — it registers ThemeRegistry,
  //    ThemeService, and ThemeModeService before anything else runs.
  await Application.boot([
    UiServiceProvider(),
    LoggerServiceProvider(),    // ← registers Logger + console/remote transports
    ThemeServiceProvider(),
    CoreServiceProvider(),
    ApiServiceProvider(),
  ]);

  // 5. Load persisted theme preferences and seed providers.
  final themeOverrides = await loadThemeOverrides();

  // 6. Start the app — wrap with UiScope so all widgets can access
  //    ThemeRegistry, ThemeService, and ThemeModeService via context.
  runApp(
    ProviderScope(
      overrides: themeOverrides,
      child: UiScope(
        registry: App.make<ThemeRegistry>(),
        themeService: App.make<ThemeService>(),
        themeModeService: App.make<ThemeModeService>(),
        child: const AppWidget(),
      ),
    ),
  );
}
