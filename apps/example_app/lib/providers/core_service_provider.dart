// lib/providers/core_service_provider.dart
//
// CoreServiceProvider — registers foundational app-level bindings.
// This is always the first provider booted.

import 'package:container/pixielity_container.dart';

/// Registers core app-level services that everything else depends on.
///
/// Boot order: CoreServiceProvider should always be first in the list
/// passed to Application.boot().
class CoreServiceProvider extends ServiceProvider {
  @override
  void register() {
    /*
    |--------------------------------------------------------------------------
    | Core Bindings
    |--------------------------------------------------------------------------
    |
    | Register any foundational services here — things like a logger,
    | an event bus, or a crash reporter that other providers depend on.
    |
    */
  }

  @override
  Future<void> boot() async {
    /*
    |--------------------------------------------------------------------------
    | Boot
    |--------------------------------------------------------------------------
    |
    | Perform any startup work here — e.g. initialise crash reporting,
    | restore a persisted session, or warm up a cache.
    |
    */
  }
}
