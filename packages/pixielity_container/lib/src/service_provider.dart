// lib/src/service_provider.dart
//
// ServiceProvider — base class for grouping related container registrations.
//
// Mirrors Laravel's ServiceProvider pattern. Each feature or layer of the
// app gets its own provider that registers its bindings in register() and
// performs any boot-time work in boot().
//
// Usage:
//   class ApiServiceProvider extends ServiceProvider {
//     @override
//     void register() {
//       App.singleton<ApiClient>((c) => ApiClient(
//         baseUrl: Config.get('api.baseUrl'),
//       ));
//     }
//   }
//
//   // In main.dart
//   Application.register([
//     ApiServiceProvider(),
//     AuthServiceProvider(),
//     StorageServiceProvider(),
//   ]);

import 'package:flutter/cupertino.dart' show Container;
import 'package:flutter/material.dart' show Container;
import 'package:flutter/widgets.dart' show Container;
import 'package:pixielity_container/pixielity_container.dart' show App, Container;
import 'package:pixielity_container/src/container.dart' show App, Container;

/// Base class for service providers.
///
/// Subclass this to group related [Container] registrations together.
/// Override [register] to bind services and [boot] for any work that
/// depends on other services already being registered.
///
/// ```dart
/// class AuthServiceProvider extends ServiceProvider {
///   @override
///   void register() {
///     App.singleton<AuthRepository>((c) => JwtAuthRepository(
///       client: c.make<ApiClient>(),
///     ));
///   }
///
///   @override
///   Future<void> boot() async {
///     // Restore session from secure storage, etc.
///   }
/// }
/// ```
abstract class ServiceProvider {
  /*
  |--------------------------------------------------------------------------
  | register
  |--------------------------------------------------------------------------
  |
  | Register any application services. This method is called before boot()
  | so you should only bind things into the container here — do not try to
  | resolve anything, as it may not have been registered yet.
  |
  */

  /// Register bindings into the container.
  ///
  /// Only call [App.bind], [App.singleton], [App.instance] etc. here.
  /// Do not call [App.make] — other providers may not have run yet.
  void register();

  /*
  |--------------------------------------------------------------------------
  | boot
  |--------------------------------------------------------------------------
  |
  | Bootstrap any application services. This method is called after all
  | service providers have been registered, so you may resolve services
  | from the container here.
  |
  */

  /// Bootstrap services after all providers have been registered.
  ///
  /// Safe to call [App.make] here — all bindings are already registered.
  Future<void> boot() async {}
}
