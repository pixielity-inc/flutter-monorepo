import 'package:container/pixielity_container.dart';
import 'resource/resource.dart';
import 'resource/resource_registry.dart';

/// Registers the [ResourceRegistry] into the IoC container and boots
/// any resources that were pre-registered before [Application.boot].
///
/// ```dart
/// await Application.boot([
///   CoreServiceProvider(),
///   RefineServiceProvider(
///     resources: [postResource, userResource],
///   ),
/// ]);
/// ```
class RefineServiceProvider extends ServiceProvider {
  RefineServiceProvider({this.resources = const []});

  /// Resources to register at boot time.
  final List<Resource<dynamic, dynamic>> resources;

  @override
  void register() {
    // Nothing to bind into the container — ResourceRegistry is a static class.
  }

  @override
  Future<void> boot() async {
    ResourceRegistry.registerAll(resources);
  }
}
