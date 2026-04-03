// lib/src/application.dart
//
// Application — bootstraps the container by running all service providers.
//
// Mirrors Laravel's Application class. Call Application.boot() once in
// main() before runApp(). It runs all provider register() calls first,
// then all boot() calls — matching Laravel's two-phase bootstrap.
//
// Usage:
//   void main() async {
//     Config.load({...});
//
//     await Application.boot([
//       CoreServiceProvider(),
//       ApiServiceProvider(),
//       AuthServiceProvider(),
//       StorageServiceProvider(),
//     ]);
//
//     runApp(const ProviderScope(child: MyApp()));
//   }

import 'package:pixielity_container/src/service_provider.dart';

/// Bootstraps the IoC container by running all [ServiceProvider]s.
///
/// Call [Application.boot] once in `main()` before `runApp()`.
abstract final class Application {
  /*
  |--------------------------------------------------------------------------
  | boot
  |--------------------------------------------------------------------------
  |
  | Register and boot all of the given service providers.
  |
  | Phase 1 — register: all providers' register() methods are called in
  | order so every binding is available before any boot() runs.
  |
  | Phase 2 — boot: all providers' boot() methods are called in order.
  | At this point every binding is registered and safe to resolve.
  |
  */

  /// Registers and boots all [providers].
  ///
  /// ```dart
  /// await Application.boot([
  ///   CoreServiceProvider(),
  ///   ApiServiceProvider(),
  ///   AuthServiceProvider(),
  /// ]);
  /// ```
  static Future<void> boot(List<ServiceProvider> providers) async {
    // Phase 1 — register all bindings first.
    for (final provider in providers) {
      provider.register();
    }

    // Phase 2 — boot after all bindings are registered.
    for (final provider in providers) {
      await provider.boot();
    }
  }
}
