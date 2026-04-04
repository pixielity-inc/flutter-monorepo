// ignore_for_file: lines_longer_than_80_chars
// lib/src/container.dart
//
// Container — Laravel-style IoC container backed by get_it.
//
// Mirrors the Laravel service container API so Flutter code reads the same
// way as a Laravel application. Under the hood every registration delegates
// to a GetIt instance, so all of get_it's performance characteristics apply.
//
// Supported registrations:
//   Container.bind<T>()        — new instance on every make() call
//   Container.singleton<T>()   — one shared instance for the app lifetime
//   Container.scoped<T>()      — one instance per scope (e.g. per request)
//   Container.instance<T>()    — register an already-constructed object
//   Container.alias<T, A>()    — resolve T when A is requested
//
// Resolution:
//   Container.make<T>()        — resolve and return T
//   Container.makeNamed<T>()   — resolve by string name
//
// Inspection:
//   Container.bound<T>()       — true if T is registered
//   Container.forget<T>()      — remove a registration
//   Container.flush()          — remove all registrations (tests only)
//
// Static facade (mirrors Laravel's App:: facade):
//   App.bind<T>(...)
//   App.singleton<T>(...)
//   App.make<T>()

import 'package:get_it/get_it.dart';

/// Factory function type — receives the container and returns an instance.
typedef Factory<T extends Object> = T Function(Container container);

/// The IoC container.
///
/// Use the static [App] facade for convenience, or hold a reference to
/// [Container.instance] directly.
///
/// ```dart
/// // Register
/// App.singleton<ApiClient>(() => ApiClient(Config.get('api.baseUrl')));
/// App.bind<Logger>(() => ConsoleLogger());
///
/// // Resolve
/// final client = App.make<ApiClient>();
/// final logger = App.make<Logger>();
/// ```
class Container {
  Container._();

  /// The underlying GetIt instance.
  static final GetIt _getIt = GetIt.instance;

  /// The singleton [Container] instance (mirrors Laravel's `app()` helper).
  static final Container instance = Container._();

  // ── Registration ───────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | bind
  |--------------------------------------------------------------------------
  |
  | Register a binding in the container. The factory closure is called
  | every time make<T>() is invoked — a new instance is returned each time.
  | This is equivalent to Laravel's $app->bind().
  |
  */

  /// Registers [factory] as a transient binding for [T].
  ///
  /// A new instance is created on every [make] call.
  ///
  /// ```dart
  /// Container.bind<Logger>((c) => ConsoleLogger());
  /// ```
  static void bind<T extends Object>(Factory<T> factory) {
    if (_getIt.isRegistered<T>()) _getIt.unregister<T>();
    _getIt.registerFactory<T>(() => factory(instance));
  }

  /*
  |--------------------------------------------------------------------------
  | singleton
  |--------------------------------------------------------------------------
  |
  | Register a shared binding in the container. The factory closure is
  | called only once — the same instance is returned on every subsequent
  | make<T>() call. Equivalent to Laravel's $app->singleton().
  |
  */

  /// Registers [factory] as a singleton binding for [T].
  ///
  /// The factory is called lazily on the first [make] call. The same
  /// instance is returned on every subsequent call.
  ///
  /// ```dart
  /// Container.singleton<ApiClient>((c) => ApiClient(
  ///   baseUrl: Config.get('api.baseUrl'),
  /// ));
  /// ```
  static void singleton<T extends Object>(Factory<T> factory) {
    if (_getIt.isRegistered<T>()) _getIt.unregister<T>();
    _getIt.registerLazySingleton<T>(() => factory(instance));
  }

  /*
  |--------------------------------------------------------------------------
  | scoped
  |--------------------------------------------------------------------------
  |
  | Register a scoped binding. Like a singleton but reset when resetScope()
  | is called. Useful for per-screen or per-request lifetimes.
  | Equivalent to Laravel's $app->scoped().
  |
  */

  /// Registers [factory] as a scoped singleton for [T].
  ///
  /// Scoped instances are shared within a scope and reset when
  /// [resetScope] is called.
  ///
  /// ```dart
  /// Container.scoped<CartService>((c) => CartService());
  /// ```
  static void scoped<T extends Object>(Factory<T> factory) {
    // get_it does not have a native scoped lifetime, so we model it as a
    // lazy singleton that can be unregistered and re-registered on reset.
    if (_getIt.isRegistered<T>(instanceName: _scopedTag)) {
      _getIt.unregister<T>(instanceName: _scopedTag);
    }
    _getIt.registerLazySingleton<T>(
      () => factory(instance),
      instanceName: _scopedTag,
    );
    _scopedTypes.add(T);
  }

  /*
  |--------------------------------------------------------------------------
  | instance
  |--------------------------------------------------------------------------
  |
  | Register an existing object instance in the container. The object will
  | always be returned as-is. Equivalent to Laravel's $app->instance().
  |
  */

  /// Registers an already-constructed [object] as the singleton for [T].
  ///
  /// ```dart
  /// Container.instance<Database>(db);
  /// ```
  static void registerInstance<T extends Object>(T object) {
    if (_getIt.isRegistered<T>()) _getIt.unregister<T>();
    _getIt.registerSingleton<T>(object);
  }

  /*
  |--------------------------------------------------------------------------
  | alias
  |--------------------------------------------------------------------------
  |
  | Alias a type to another type. When [A] is requested, [T] is resolved.
  | Equivalent to Laravel's $app->alias().
  |
  */

  /// Registers [A] as an alias for [T].
  ///
  /// When [make<A>] is called, the container resolves [T] instead.
  ///
  /// ```dart
  /// Container.alias<HttpClient, ApiClient>();
  /// // App.make<HttpClient>() now returns the registered ApiClient.
  /// ```
  static void alias<T extends Object, A extends Object>() {
    if (_getIt.isRegistered<A>()) _getIt.unregister<A>();
    _getIt.registerLazySingleton<A>(() => _getIt.get<T>() as A);
  }

  // ── Resolution ─────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | make
  |--------------------------------------------------------------------------
  |
  | Resolve the given type from the container. Equivalent to Laravel's
  | $app->make() or resolve() helper.
  |
  */

  /// Resolves and returns an instance of [T] from the container.
  ///
  /// Throws [ContainerBindingNotFoundException] if [T] is not registered.
  ///
  /// ```dart
  /// final client = Container.make<ApiClient>();
  /// ```
  static T make<T extends Object>() {
    if (!_getIt.isRegistered<T>()) {
      throw ContainerBindingNotFoundException(T.toString());
    }
    return _getIt.get<T>();
  }

  /// Resolves a binding registered under a string [name].
  ///
  /// ```dart
  /// Container.singleton<Logger>(
  ///   (c) => ConsoleLogger(),
  ///   name: 'logger.console',
  /// );
  /// final logger = Container.makeNamed<Logger>('logger.console');
  /// ```
  static T makeNamed<T extends Object>(String name) {
    if (!_getIt.isRegistered<T>(instanceName: name)) {
      throw ContainerBindingNotFoundException('$T ($name)');
    }
    return _getIt.get<T>(instanceName: name);
  }

  // ── Named registrations ────────────────────────────────────────────────────

  /// Registers a named transient binding.
  static void bindNamed<T extends Object>(String name, Factory<T> factory) {
    if (_getIt.isRegistered<T>(instanceName: name)) {
      _getIt.unregister<T>(instanceName: name);
    }
    _getIt.registerFactory<T>(
      () => factory(instance),
      instanceName: name,
    );
  }

  /// Registers a named singleton binding.
  static void singletonNamed<T extends Object>(
    String name,
    Factory<T> factory,
  ) {
    if (_getIt.isRegistered<T>(instanceName: name)) {
      _getIt.unregister<T>(instanceName: name);
    }
    _getIt.registerLazySingleton<T>(
      () => factory(instance),
      instanceName: name,
    );
  }

  // ── Inspection ─────────────────────────────────────────────────────────────

  /*
  |--------------------------------------------------------------------------
  | bound
  |--------------------------------------------------------------------------
  |
  | Determine if the given type has been bound in the container.
  | Equivalent to Laravel's $app->bound().
  |
  */

  /// Returns `true` if [T] is registered in the container.
  static bool bound<T extends Object>() => _getIt.isRegistered<T>();

  /*
  |--------------------------------------------------------------------------
  | forget
  |--------------------------------------------------------------------------
  |
  | Remove a resolved instance or binding from the container.
  | Equivalent to Laravel's $app->forgetInstance().
  |
  */

  /// Removes the registration for [T] from the container.
  static void forget<T extends Object>() {
    if (_getIt.isRegistered<T>()) _getIt.unregister<T>();
  }

  /*
  |--------------------------------------------------------------------------
  | flush
  |--------------------------------------------------------------------------
  |
  | Remove all bindings and resolved instances from the container.
  | Use only in tests to reset state between test cases.
  |
  */

  /// Removes all registrations. Use only in tests.
  static Future<void> flush() async {
    await _getIt.reset();
    _scopedTypes.clear();
  }

  // ── Scope management ───────────────────────────────────────────────────────

  /// Resets all scoped bindings so they are re-created on next [make] call.
  ///
  /// Call this when navigating to a new screen or starting a new logical
  /// scope (e.g. a new user session).
  static void resetScope() {
    for (final _ in List.of(_scopedTypes)) {
      if (_getIt.isRegistered(instanceName: _scopedTag)) {
        _getIt.resetLazySingleton(instanceName: _scopedTag);
      }
    }
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  static const String _scopedTag = '__scoped__';
  static final Set<Type> _scopedTypes = {};
}

// ── App facade ────────────────────────────────────────────────────────────────

/// Static facade for [Container] — mirrors Laravel's `App::` facade.
///
/// ```dart
/// App.singleton<ApiClient>((c) => ApiClient());
/// App.bind<Logger>((c) => ConsoleLogger());
/// final client = App.make<ApiClient>();
/// ```
abstract final class App {
  /*
  |--------------------------------------------------------------------------
  | bind
  |--------------------------------------------------------------------------
  |
  | Register a transient binding. A new instance is returned on every
  | App.make<T>() call.
  |
  */

  /// Registers a transient binding for [T].
  static void bind<T extends Object>(Factory<T> factory) =>
      Container.bind<T>(factory);

  /*
  |--------------------------------------------------------------------------
  | singleton
  |--------------------------------------------------------------------------
  |
  | Register a shared binding. The same instance is returned on every
  | App.make<T>() call.
  |
  */

  /// Registers a singleton binding for [T].
  static void singleton<T extends Object>(Factory<T> factory) =>
      Container.singleton<T>(factory);

  /*
  |--------------------------------------------------------------------------
  | scoped
  |--------------------------------------------------------------------------
  |
  | Register a scoped binding. Shared within a scope, reset on resetScope().
  |
  */

  /// Registers a scoped binding for [T].
  static void scoped<T extends Object>(Factory<T> factory) =>
      Container.scoped<T>(factory);

  /*
  |--------------------------------------------------------------------------
  | instance
  |--------------------------------------------------------------------------
  |
  | Register an existing object instance.
  |
  */

  /// Registers an already-constructed [object] as the singleton for [T].
  static void instance<T extends Object>(T object) =>
      Container.registerInstance<T>(object);

  /*
  |--------------------------------------------------------------------------
  | make
  |--------------------------------------------------------------------------
  |
  | Resolve the given type from the container.
  |
  */

  /// Resolves and returns an instance of [T].
  static T make<T extends Object>() => Container.make<T>();

  /*
  |--------------------------------------------------------------------------
  | bound
  |--------------------------------------------------------------------------
  |
  | Determine if the given type has been bound in the container.
  |
  */

  /// Returns `true` if [T] is registered.
  static bool bound<T extends Object>() => Container.bound<T>();

  /*
  |--------------------------------------------------------------------------
  | forget
  |--------------------------------------------------------------------------
  |
  | Remove a binding from the container.
  |
  */

  /// Removes the registration for [T].
  static void forget<T extends Object>() => Container.forget<T>();
}

// ── Exceptions ────────────────────────────────────────────────────────────────

/// Thrown when [Container.make] is called for a type that is not registered.
class ContainerBindingNotFoundException implements Exception {
  /// Creates a [ContainerBindingNotFoundException].
  const ContainerBindingNotFoundException(this.typeName);

  /// The name of the type that was not found.
  final String typeName;

  @override
  String toString() =>
      'ContainerBindingNotFoundException: No binding found for "$typeName". '
      'Register it with App.bind<$typeName>() or App.singleton<$typeName>() '
      'before calling App.make<$typeName>().';
}
