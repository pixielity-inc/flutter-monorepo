// lib/providers/theme_config_bridge.dart
//
// ThemeConfigBridge — wires pixielity_config's Config registry into
// pixielity_ui's AppTheme.fromConfig() without creating a hard dependency
// between the two packages.

import 'package:config/pixielity_config.dart';
import 'package:ui/pixielity_ui.dart';

/// Implements [ConfigBridge] by delegating to the [Config] registry.
///
/// Register this once in main.dart before calling AppTheme.fromConfig():
/// ```dart
/// ConfigBridge.register(ThemeConfigBridge());
/// ```
class ThemeConfigBridge extends ConfigBridge {
  @override
  String getString(String key, {required String fallback}) =>
      Config.get<String>(key, fallback: fallback);

  @override
  double getDouble(String key, {required double fallback}) =>
      Config.get<double>(key, fallback: fallback);

  @override
  int getInt(String key, {required int fallback}) =>
      Config.get<int>(key, fallback: fallback);
}
