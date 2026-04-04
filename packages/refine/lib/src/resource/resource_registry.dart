// ignore_for_file: lines_longer_than_80_chars

import 'resource.dart';

/// Global registry of all [Resource] definitions.
///
/// Register resources once at app startup (e.g. inside a ServiceProvider),
/// then resolve them anywhere by name.
///
/// ```dart
/// ResourceRegistry.register(postResource);
/// ResourceRegistry.register(userResource);
///
/// final post = ResourceRegistry.get('posts'); // Resource<Post, String>
/// ```
abstract final class ResourceRegistry {
  static final Map<String, Resource<dynamic, dynamic>> _resources = {};

  /// Register a [resource]. Overwrites any existing entry with the same name.
  static void register(Resource<dynamic, dynamic> resource) {
    _resources[resource.name] = resource;
  }

  /// Register multiple resources at once.
  static void registerAll(List<Resource<dynamic, dynamic>> resources) {
    for (final r in resources) {
      register(r);
    }
  }

  /// Resolve a resource by [name]. Returns null if not found.
  static Resource<dynamic, dynamic>? get(String name) => _resources[name];

  /// Resolve a resource by [name] or throw if not registered.
  static Resource<dynamic, dynamic> getOrFail(String name) {
    final resource = _resources[name];
    if (resource == null) {
      throw StateError(
        'ResourceRegistry: no resource registered with name "$name". '
        'Call ResourceRegistry.register() before using it.',
      );
    }
    return resource;
  }

  /// All registered resources in registration order.
  static List<Resource<dynamic, dynamic>> get all =>
      List.unmodifiable(_resources.values);

  /// Remove a resource by [name].
  static void forget(String name) => _resources.remove(name);

  /// Clear all registrations — use only in tests.
  static void flush() => _resources.clear();
}
