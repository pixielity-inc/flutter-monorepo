/// pixielity_container
///
/// Laravel-style IoC container for the Pixielity Flutter monorepo.
///
/// ## API
///
/// ### Registration (mirrors Laravel's service container)
///
/// ```dart
/// // New instance on every make() call — like $app->bind()
/// App.bind<Logger>((c) => ConsoleLogger());
///
/// // One shared instance — like $app->singleton()
/// App.singleton<ApiClient>((c) => ApiClient(
///   baseUrl: Config.get('api.baseUrl'),
/// ));
///
/// // Register an already-constructed object — like $app->instance()
/// App.instance<Database>(db);
///
/// // Alias one type to another — like $app->alias()
/// Container.alias<HttpClient, ApiClient>();
/// ```
///
/// ### Resolution
///
/// ```dart
/// final client = App.make<ApiClient>();
/// final logger = App.make<Logger>();
/// ```
///
/// ### Service Providers (mirrors Laravel's ServiceProvider)
///
/// ```dart
/// class ApiServiceProvider extends ServiceProvider {
///   @override
///   void register() {
///     App.singleton<ApiClient>((c) => ApiClient());
///   }
/// }
/// ```
///
/// ### Bootstrap (mirrors Laravel's Application)
///
/// ```dart
/// void main() async {
///   Config.load({...});
///   await Application.boot([
///     CoreServiceProvider(),
///     ApiServiceProvider(),
///     AuthServiceProvider(),
///   ]);
///   runApp(const MyApp());
/// }
/// ```

library;

export 'src/application.dart';
export 'src/container.dart';
export 'src/service_provider.dart';
