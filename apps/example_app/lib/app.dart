import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'package:pixielity_example_app/pages/home_page.dart';

/// Root application widget.
///
/// Sets up Forui theming with platform-aware touch/desktop variants,
/// localization, and the [FToaster] + [FTooltipGroup] wrappers.
class Application extends StatelessWidget {
  /// Creates the root [Application] widget.
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    // Use touch theme on mobile, desktop theme on desktop platforms.
    final theme =
        const <TargetPlatform>{
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.fuchsia,
        }.contains(defaultTargetPlatform)
        ? FThemes.neutral.dark.touch
        : FThemes.neutral.dark.desktop;

    return MaterialApp(
      title: 'Pixielity Flutter Monorepo',
      debugShowCheckedModeBanner: false,
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
