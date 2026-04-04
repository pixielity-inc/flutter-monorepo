---
inclusion: manual
---

# Dependency Injection & Service Container

This document describes how dependency injection works in the Pixielity Flutter
monorepo. The system is inspired by Laravel's service container but adapted for
Flutter's widget tree model.

---

## Overview

The monorepo uses three complementary DI mechanisms:

| Mechanism | Package | When to use |
|---|---|---|
| `App.make<T>()` | `pixielity_container` | Services, repos, clients — outside widgets |
| `UiScope` + `context.x` | `pixielity_ui` | UI services inside widgets |
| Riverpod `ref.watch` | `flutter_riverpod` | Reactive state that triggers rebuilds |

---

## 1. IoC Container — `App.make<T>()`

The container is backed by `get_it` and exposed via the `App` facade.
It is the primary DI mechanism for everything that is **not a widget**.

### Register (in a ServiceProvider)

```dart
class UserServiceProvider extends ServiceProvider {
  @override
  void register() {
    // Singleton — one instance for the app lifetime
    App.singleton<ApiClient>((_) => ApiClient(
      baseUrl: Config.get<String>('api.versionedBaseUrl'),
    ));

    // Bind interface → implementation
    // Swap to MockUserRepository in tests by changing this one line
    App.singleton<UserRepository>((_) => HttpUserRepository(
      App.make<ApiClient>(),   // ← resolved from container
    ));

    App.singleton<UserService>((_) => UserService(
      App.make<UserRepository>(),  // ← resolved from container
    ));

    // Transient — new instance on every make()
    App.bind<Logger>((_) => ConsoleLogger());
  }
}
```

### Boot (in main.dart)

```dart
await Application.boot([
  UiServiceProvider(),      // always first — registers UI services
  UserServiceProvider(),    // registers ApiClient → UserRepository → UserService
  CoreServiceProvider(),
]);
```

### Resolve (anywhere outside the widget tree)

```dart
final service = App.make<UserService>();
final users   = await service.getUsers();
```

### Dependency graph

```
Application.boot()
  └── UserServiceProvider.register()
        ├── App.singleton<ApiClient>(...)
        │     └── Config.get('api.versionedBaseUrl')
        ├── App.singleton<UserRepository>(...)
        │     └── App.make<ApiClient>()
        └── App.singleton<UserService>(...)
              └── App.make<UserRepository>()
```

---

## 2. UiScope — Widget Tree Injection

`UiScope` is an `InheritedWidget` that makes UI services available to any
widget via `BuildContext` extensions. It bridges the gap between the IoC
container and the widget tree.

### Why UiScope exists

`pixielity_ui` widgets (like `AppPaletteSelector`) need `ThemeRegistry` but
`pixielity_ui` cannot depend on `pixielity_container` — that would create a
circular dependency. `UiScope` solves this by injecting services at the root
and propagating them down the tree automatically.

### Register (in main.dart)

```dart
runApp(
  ProviderScope(
    overrides: themeOverrides,
    child: UiScope(
      registry:         App.make<ThemeRegistry>(),    // pulled from IoC
      themeService:     App.make<ThemeService>(),     // pulled from IoC
      themeModeService: App.make<ThemeModeService>(), // pulled from IoC
      child: const AppWidget(),
    ),
  ),
);
```

### Resolve (in any widget)

```dart
class AppPaletteSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // No parameter passing needed — reads from UiScope automatically
    final registry = context.registry;
    final palette  = context.themeService.palette;
    context.themeModeService.toggle();
  }
}
```

### Performance

- Lookup is O(1) — Flutter stores inherited widgets in a hash map per element.
- `updateShouldNotify` returns `false` for stable service references.
- Zero rebuilds triggered by `UiScope` itself.

### When to create a new Scope

Only create a new Scope if you have a **new package** with widgets that need
services and cannot depend on `pixielity_container`.

```
pixielity_ui    → UiScope    (ThemeRegistry, ThemeService, ThemeModeService)
pixielity_auth  → AuthScope  (AuthService, SessionService)   ← if needed
pixielity_media → MediaScope (MediaService, UploadService)   ← if needed
```

For regular app features (users, products, orders) — use `App.make<T>()`.
No scope needed.

---

## 3. Riverpod — Reactive State

Use Riverpod when a value change should **trigger widget rebuilds**.

```dart
// Bridge: container → reactive state
final usersProvider = FutureProvider<List<User>>((ref) {
  return App.make<UserService>().getUsers();
});

// In a widget
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    return users.when(
      data:    (list) => ListView(...),
      loading: () => const AppLoadingIndicator(),
      error:   (e, _) => Text('$e'),
    );
  }
}
```

---

## Decision Guide

```
Need a dependency?
│
├── In a SERVICE, REPOSITORY, or COMMAND (not a widget)?
│   └── Constructor injection + App.make<T>() in ServiceProvider
│
├── In a WIDGET — is it a UI service from pixielity_ui?
│   └── UiScope → context.registry / context.themeService
│
├── In a WIDGET — does it need to trigger rebuilds?
│   └── Riverpod → ref.watch(myProvider)
│
└── In a WIDGET — is it an app service (UserService, ApiClient)?
    └── App.make<T>() in build() or initState()
        (or bridge via a FutureProvider/StreamProvider)
```

---

## Full Example: Model → Repository → Service

### Model (pure data, no dependencies)

```dart
@immutable
class User {
  const User({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id:    json['id']    as String,
    name:  json['name']  as String,
    email: json['email'] as String,
  );
}
```

### Repository (interface + implementation)

```dart
// Interface — the service depends on this, not the concrete class
abstract class UserRepository {
  Future<User> findById(String id);
  Future<List<User>> all();
  Future<User> save(User user);
  Future<void> delete(String id);
}

// Implementation — injected with ApiClient
class HttpUserRepository implements UserRepository {
  const HttpUserRepository(this._client);
  final ApiClient _client;

  @override
  Future<User> findById(String id) async {
    final res = await _client.get('/users/$id');
    return User.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<User>> all() async {
    final res = await _client.get('/users');
    return (res.data as List)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<User> save(User user) async {
    final res = await _client.post('/users', body: user.toJson());
    return User.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String id) => _client.delete('/users/$id');
}
```

### Service (injected with repository interface)

```dart
class UserService {
  const UserService(this._repository);
  final UserRepository _repository;

  Future<User>       getUser(String id)          => _repository.findById(id);
  Future<List<User>> getUsers()                  => _repository.all();
  Future<User>       saveUser(User user)          => _repository.save(user);
  Future<void>       deleteUser(String id)        => _repository.delete(id);

  Future<User> updateEmail(String id, String email) async {
    final user = await _repository.findById(id);
    return _repository.save(User(id: user.id, name: user.name, email: email));
  }
}
```

### ServiceProvider (wires everything)

```dart
class UserServiceProvider extends ServiceProvider {
  @override
  void register() {
    App.singleton<ApiClient>((_) => ApiClient(
      baseUrl: Config.get<String>('api.versionedBaseUrl'),
    ));

    // Bind interface → implementation (swap for mock in tests)
    App.singleton<UserRepository>((_) => HttpUserRepository(
      App.make<ApiClient>(),
    ));

    App.singleton<UserService>((_) => UserService(
      App.make<UserRepository>(),
    ));
  }
}
```

### Riverpod bridge (reactive state for widgets)

```dart
final usersProvider = FutureProvider<List<User>>(
  (_) => App.make<UserService>().getUsers(),
);

final userProvider = FutureProvider.family<User, String>(
  (_, id) => App.make<UserService>().getUser(id),
);
```

### Widget usage

```dart
class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(usersProvider).when(
      data:    (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) => Text(users[i].name),
      ),
      loading: () => const AppLoadingIndicator(),
      error:   (e, _) => AppEmptyState(
        icon:  LucideIcons.alertCircle,
        title: 'Failed to load users',
      ),
    );
  }
}
```

---

## Testing

Override any binding in tests without changing production code:

```dart
// In a test
setUp(() {
  // Replace HttpUserRepository with a mock
  App.bind<UserRepository>((_) => MockUserRepository());
  App.bind<UserService>((_) => UserService(App.make<UserRepository>()));
});

// Or override a Riverpod provider
testWidgets('shows users', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        usersProvider.overrideWith((_) async => [
          const User(id: '1', name: 'Alice', email: 'alice@test.com'),
        ]),
      ],
      child: const UserListPage(),
    ),
  );
});
```

---

## Summary

```
IoC Container (App.make)     → Services, Repos, Clients
UiScope (context.x)          → UI services in pixielity_ui widgets
Riverpod (ref.watch)          → Reactive state → widget rebuilds
Constructor injection         → Service → Service dependencies
```

No singletons. No static globals. Every dependency is explicit,
testable, and swappable.
