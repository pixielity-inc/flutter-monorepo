// lib/providers/api_service_provider.dart
//
// ApiServiceProvider — registers all HTTP / API layer bindings.

import 'package:config/pixielity_config.dart';
import 'package:container/pixielity_container.dart';

/// Registers HTTP client and API-related services.
///
/// ```dart
/// await Application.boot([ApiServiceProvider(), ...]);
/// ```
class ApiServiceProvider extends ServiceProvider {
  @override
  void register() {
    /*
    |--------------------------------------------------------------------------
    | API Base URL
    |--------------------------------------------------------------------------
    |
    | Register the versioned base URL as a named string so any service
    | that needs it can resolve it without importing Config directly.
    |
    */

    Container.singletonNamed<String>(
      'api.baseUrl',
      (_) => Config.get<String>('api.versionedBaseUrl'),
    );
  }
}
