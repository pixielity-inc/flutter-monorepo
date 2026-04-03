# Contributing — flutter-monorepo

## Prerequisites

| Tool    | Minimum | Install                        |
|---------|---------|--------------------------------|
| Flutter | 3.x     | https://flutter.dev/docs/get-started/install |
| Dart    | 3.x     | bundled with Flutter           |
| Melos   | 6.x     | `dart pub global activate melos` |

## Getting started

```bash
# 1. Clone
git clone https://github.com/your-org/flutter-monorepo.git
cd flutter-monorepo

# 2. Install git hooks
melos run hooks:install

# 3. Bootstrap all packages
melos bootstrap

# 4. Run the app
cd apps/example_app && flutter run
```

## Workflow

1. Branch from `main`: `git checkout -b feat/my-feature`
2. Make changes with tests and docblocks.
3. `melos run lint` and `melos run test` must pass.
4. Commit using Conventional Commits: `feat(example_app): add X`
5. Open a PR against `main`.

## Publishing a package

```bash
# Bump version in packages/<name>/pubspec.yaml
git tag example_package-v1.2.3
git push --tags
```

The `cd_publish.yml` workflow handles the rest.
