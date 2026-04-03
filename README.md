# Flutter Monorepo

A production-ready Flutter monorepo template using **Melos** for package
orchestration and a **Dart CLI** as the developer experience layer.

[![CI](https://github.com/<org>/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/<org>/<repo>/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/<org>/<repo>/branch/main/graph/badge.svg)](https://codecov.io/gh/<org>/<repo>)

---

## Structure

```
flutter-monorepo/
├── apps/
│   └── example_app/          # Flutter app — composition root
├── packages/
│   └── example_package/      # Domain-layer package (entity, repo, use case)
├── tool/                     # Dart CLI
│   ├── cli.dart              # Entry point
│   ├── commands/             # One file per command
│   ├── core/                 # Process runner + logger
│   └── utils/                # Path helpers
├── .github/
│   ├── workflows/
│   │   ├── ci.yml            # Lint + test + coverage on every PR
│   │   ├── cd_build.yml      # Build APK/IPA on main + tags
│   │   └── cd_publish.yml    # Publish packages on version tags
│   ├── dependabot.yml        # Automated dependency updates
│   └── pull_request_template.md
├── .githooks/
│   └── pre-commit            # Local format + lint gate
├── .vscode/                  # Shared editor settings + launch configs
├── pubspec.yaml              # Workspace root + Melos config
└── analysis_options.yaml     # Shared lint rules (very_good_analysis)
```

---

## Prerequisites

```bash
dart --version    # >= 3.11
flutter --version # >= 3.16
dart pub global activate melos
```

---

## Setup

```bash
# Install root deps + bootstrap all packages
dart pub get && melos bootstrap

# Install git hooks (format + lint on every commit)
dart run tool/cli.dart hooks:install
```

---

## CLI

All commands run from the repo root.

```bash
# Development
dart run tool/cli.dart dev               # Run example_app
dart run tool/cli.dart dev --app=my_app  # Run a specific app

# Quality
dart run tool/cli.dart lint              # Analyze all packages (parallel)
dart run tool/cli.dart format            # Format all files (parallel)
dart run tool/cli.dart test              # Run all tests (parallel)
dart run tool/cli.dart gen               # Code generation (sequential)
dart run tool/cli.dart clean             # Clean build artifacts (parallel)

# Build
dart run tool/cli.dart build                          # APK
dart run tool/cli.dart build --target=ios             # iOS
dart run tool/cli.dart build --app=my_app --target=apk

# Scaffolding
dart run tool/cli.dart feature auth      # New feature package

# Pipelines
dart run tool/cli.dart pipeline:ci       # gen → lint + test (parallel)
dart run tool/cli.dart pipeline:dev      # gen → dev
dart run tool/cli.dart pipeline:release  # gen → lint → test → build

# Versioning & publishing
dart run tool/cli.dart version           # Preview version bumps
dart run tool/cli.dart version --no-dry-run  # Bump + update CHANGELOGs
dart run tool/cli.dart publish           # Dry-run publish
dart run tool/cli.dart publish --no-dry-run  # Publish to pub.dev

# Setup
dart run tool/cli.dart hooks:install     # Install git pre-commit hook

dart run tool/cli.dart help              # All commands
```

---

## CI / CD

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` | PR + push to `main` | Format check → lint → test → coverage |
| `cd_build.yml` | Push to `main` + version tags | Build APK + iOS artifact |
| `cd_publish.yml` | Tag `<package>-v*` | Publish package to pub.dev |

### Required secrets

| Secret | Used by | How to get it |
|---|---|---|
| `CODECOV_TOKEN` | `ci.yml` | [codecov.io](https://codecov.io) → repo settings |
| `PUB_CREDENTIALS` | `cd_publish.yml` | `cat ~/.pub-cache/credentials.json` after `dart pub login` |

---

## Architecture

```
Domain Layer   — pure Dart, no Flutter, no HTTP
    ↑
Data Layer     — repository implementations, DTOs
    ↑
Feature Layer  — UI + Riverpod state + domain wiring
    ↑
App Layer      — composition root, routing, DI
```

Dependency rule: each layer may only depend on layers below it.
The Domain Layer depends on nothing.

---

## Adding a new feature package

```bash
dart run tool/cli.dart feature booking
# → scaffolds packages/features/booking/ with full clean architecture tree
```

## Adding a new app

1. Create `apps/<name>/` as a standard Flutter app
2. Add `resolution: workspace` to its `pubspec.yaml`
3. Add `include: ../../analysis_options.yaml` to its `analysis_options.yaml`
4. Run `dart pub get` at the root

## Publishing a package

```bash
# Bump version + update CHANGELOG
dart run tool/cli.dart version --no-dry-run

# Publish
dart run tool/cli.dart publish --no-dry-run

# Or push a tag to trigger CI
git tag example_package-v1.0.0 && git push --tags
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
