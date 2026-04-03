// apps/example_app/lib/app.dart
//
// Application — root widget.
//
// Reads theme and app settings directly from Config.

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_config/pixielity_config.dart';
import 'package:pixielity_example_app/pages/home_page.dart';
import 'package:pixielity_ui/pixielity_ui.dart';

/// Root application widget.
class AppWidget extends StatelessWidget {
  /// Creates the root [AppWidget] widget.
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Read theme settings from the config registry.
    final brightnessStrategy = Config.get<String>(
      'theme.brightness',
      fallback: 'system',
    );
    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final brightness = switch (brightnessStrategy) {
      'light' => Brightness.light,
      'dark' => Brightness.dark,
      _ => platformBrightness, // 'system' — follow OS
    };

    final theme = AppTheme.fromConfig(brightness: brightness);

    return MaterialApp(
      title: Config.get<String>('app.name', fallback: 'Pixielity'),
      debugShowCheckedModeBanner: Config.get<bool>(
        'app.showDebugBanner',
        fallback: false,
      ),
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: const [...FLocalizations.localizationsDelegates],
      theme: theme.toApproximateMaterialTheme(),
      builder: (_, child) => FTheme(
        data: theme,
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
      home: const FScaffold(child: HomePage()),
    );
  }
}
