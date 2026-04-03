---
title: Package Structure Guide - Monorepo with Turbo
inclusion: auto
---

# Package Structure Guide - Monorepo with Turbo

This guide documents the standard package structure pattern for monorepo projects using Turbo and pnpm workspaces. Follow this pattern when creating new packages to ensure consistency and maintainability.

## 🏗️ Monorepo Structure

This project uses a monorepo structure with:

- **Turbo** - Build system orchestration and caching
- **pnpm workspaces** - Package management and linking
- **packages/** - Library packages (publishable to npm)
- **examples/** - Example applications (not published)

## 🎯 Package Organization

### Library Packages (`packages/`)

Core library packages that can be published to npm:

- `packages/container/` - Main DI container library (`@abdokouta/react-di`)
- Future packages can be added here

### Example Applications (`examples/`)

Example applications demonstrating package usage (not published):

- `examples/vite/` - Vite + React + HeroUI example
- Future examples can be added here

---

## 📁 Root Monorepo Structure

```
.
├── packages/                     # Library packages (publishable)
│   └── container/                # @abdokouta/react-di package
│       ├── src/                  # Source code
│       ├── __tests__/            # Tests
│       ├── dist/                 # Build output
│       ├── package.json          # Package manifest
│       ├── tsconfig.json         # TypeScript config
│       ├── tsup.config.ts        # Build config
│       └── vitest.config.ts      # Test config
├── examples/                     # Example applications (not published)
│   └── vite/                     # Vite example app
│       ├── src/                  # App source
│       ├── public/               # Static assets
│       ├── package.json          # App dependencies
│       └── vite.config.ts        # Vite config
├── .docs/                        # Documentation
├── .github/                      # GitHub workflows
│   └── workflows/
│       ├── ci.yml                # CI workflow
│       └── publish.yml           # Publish workflow
├── .kiro/                        # Kiro configuration
│   └── steering/                 # Steering files
├── node_modules/                 # Root dependencies
├── package.json                  # Root workspace config
├── pnpm-workspace.yaml           # pnpm workspace config
├── turbo.json                    # Turbo configuration
├── pnpm-lock.yaml                # pnpm lockfile
├── .gitignore                    # Git ignore rules
└── README.md                     # Project documentation
```

---

## 📦 Workspace Configuration

### Root package.json

```json
{
  "name": "@abdokouta/react-di-monorepo",
  "version": "1.0.4",
  "private": true,
  "description": "Dependency injection for React - NestJS-style modules powered by Inversiland",
  "workspaces": ["packages/*", "examples/*"],
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev",
    "lint": "turbo run lint",
    "test": "turbo run test",
    "clean": "turbo run clean",
    "format": "prettier --write \"**/*.{ts,tsx,js,jsx,json,md}\"",
    "format:check": "prettier --check \"**/*.{ts,tsx,js,jsx,json,md}\""
  },
  "devDependencies": {
    "prettier": "^3.8.1",
    "turbo": "^2.3.3"
  },
  "packageManager": "pnpm@10.32.1",
  "engines": {
    "node": ">=20.0.0",
    "pnpm": ">=10.0.0"
  }
}
```

**Key Points:**

- Root package is `private: true` (not published)
- Defines workspace patterns for packages and examples
- Uses Turbo for task orchestration
- Specifies package manager and Node.js version requirements

### pnpm-workspace.yaml

```yaml
packages:
  - "packages/*"
  - "examples/*"
```

**Key Points:**

- Defines workspace packages for pnpm
- Matches the workspaces in package.json
- Enables workspace protocol (`workspace:*`)

### turbo.json

```json
{
  "$schema": "https://turbo.build/schema.json",
  "ui": "tui",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "!.next/cache/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "test": {
      "dependsOn": ["^build"]
    },
    "clean": {
      "cache": false
    }
  }
}
```

**Key Points:**

- `^build` means "build dependencies first"
- `dev` is persistent (long-running)
- `lint` and `test` depend on build
- Outputs are cached for faster rebuilds

---

## 📁 Standard Package Structure

```
packages/{package-name}/
├── src/                          # Source code
│   ├── components/               # React components (if applicable)
│   │   └── {component-name}/
│   │       ├── {component-name}.component.tsx
│   │       ├── {component-name}.types.ts
│   │       ├── {component-name}.component.test.tsx
│   │       └── index.tsx
│   ├── contexts/                 # React contexts (if applicable)
│   │   ├── {context-name}.context.tsx
│   │   └── index.ts
│   ├── hooks/                    # React hooks (if applicable)
│   │   └── use-{hook-name}/
│   │       ├── use-{hook-name}.hook.ts
│   │       ├── use-{hook-name}.types.ts
│   │       ├── use-{hook-name}.hook.test.ts
│   │       └── index.ts
│   ├── services/                 # Business logic services
│   │   ├── {service-name}.service.ts
│   │   ├── {service-name}.service.test.ts
│   │   └── index.ts
│   ├── registries/               # Registry pattern (for extensible systems)
│   │   ├── {registry-name}.registry.ts
│   │   ├── helpers/
│   │   │   └── {helper-name}.helpers.ts
│   │   └── index.ts
│   ├── factories/                # Dynamic factories (for runtime generation)
│   │   ├── {factory-name}.factory.ts
│   │   ├── {factory-name}.factory.test.ts
│   │   └── index.ts
│   ├── interfaces/               # TypeScript interfaces
│   │   ├── {interface-name}.interface.ts
│   │   └── index.ts
│   ├── types/                    # TypeScript types
│   │   ├── {type-name}.type.ts
│   │   └── index.ts
│   ├── enums/                    # TypeScript enums
│   │   ├── {enum-name}.enum.ts
│   │   └── index.ts
│   ├── constants/                # Constants
│   │   ├── {constant-name}.constant.ts
│   │   ├── tokens.constant.ts    # DI tokens
│   │   └── index.ts
│   ├── utils/                    # Utility functions
│   │   ├── {util-name}.util.ts
│   │   ├── {util-name}.util.test.ts
│   │   └── index.ts
│   ├── config/                   # Configuration files
│   │   └── {package-name}.config.ts
│   ├── providers/                # React providers (if applicable)
│   │   └── {provider-name}/
│   │       ├── {provider-name}.provider.tsx
│   │       ├── {provider-name}.types.ts
│   │       └── index.tsx
│   ├── decorators/               # TypeScript decorators (if applicable)
│   │   ├── {decorator-name}.decorator.ts
│   │   └── index.ts
│   ├── index.ts                  # Main entry point
│   └── {package-name}.module.ts  # Module (MUST follow health.module.ts pattern)
├── __tests__/                    # Integration tests
│   └── {test-name}.test.ts
├── .examples/                    # Usage examples
│   └── {example-name}.example.ts
├── .docs/                        # Package-specific documentation
│   └── {doc-name}.md
├── config/                       # Build-time configuration
│   └── {config-name}.json
├── dist/                         # Build output (gitignored)
├── node_modules/                 # Dependencies (gitignored)
├── .gitignore                    # Git ignore rules
├── .prettierrc.js                # Prettier configuration
├── eslint.config.js              # ESLint configuration
├── package.json                  # Package manifest
├── README.md                     # Package documentation
├── tsconfig.json                 # TypeScript configuration
├── tsup.config.ts                # Build configuration
└── vitest.config.ts              # Test configuration
```

---

## 📦 Package Configuration Files

### 1. package.json

```json
{
  "name": "@abdokouta/{package-name}",
  "version": "0.0.0",
  "private": false,
  "type": "module",
  "description": "Brief description of the package",
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.mjs",
      "require": "./dist/index.js"
    }
  },
  "files": ["dist", "config"],
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch",
    "lint": "eslint . --max-warnings 0",
    "lint:fix": "eslint . --fix",
    "check-types": "tsc --noEmit",
    "clean": "rm -rf dist",
    "test": "vitest --run",
    "test:watch": "vitest",
    "test:coverage": "vitest --run --coverage",
    "test:ui": "vitest --ui",
    "format": "prettier --write \"src/**/*.{ts,tsx,js,jsx,json}\"",
    "format:check": "prettier --check \"src/**/*.{ts,tsx,js,jsx,json}\""
  },
  "peerDependencies": {
    "react": "^18.0.0 || ^19.0.0"
  },
  "peerDependenciesMeta": {
    "react": {
      "optional": true
    }
  },
  "devDependencies": {
    "@nesvel/eslint-config": "^1.0.5",
    "@nesvel/prettier-config": "^1.0.3",
    "@nesvel/tsup-config": "^1.0.3",
    "@nesvel/typescript-config": "^1.0.4",
    "@types/node": "^25.5.0",
    "@types/react": "^19.2.14",
    "@vitest/ui": "^4.1.2",
    "eslint": "^10.1.0",
    "prettier": "^3.8.1",
    "react": "^19.2.4",
    "tsup": "^8.5.1",
    "typescript": "6.0.2",
    "vitest": "^4.1.2"
  }
}
```

**Key Points:**

- Use `@abdokouta/` scope for all packages
- Set `"private": false` for publishable packages
- Set `"type": "module"` for ESM support
- Provide dual exports (ESM + CJS) via `exports` field
- Mark `react` as optional peer dependency if package has React hooks/components
- For examples, use `workspace:*` for internal dependencies

**Required Scripts:**

- `build` - Build the package using tsup
- `dev` - Watch mode for development
- `test` - Run tests once (for CI)
- `test:watch` - Watch mode for tests during development
- `format` - Format code with Prettier
- `format:check` - Check formatting (for CI)
- `lint` - Lint code (optional, if using ESLint)
- `lint:fix` - Fix linting issues
- `check-types` - Type check without emitting files
- `clean` - Remove build artifacts

**Required devDependencies:**

- `@nesvel/prettier-config` - Prettier configuration
- `@nesvel/typescript-config` - TypeScript configuration
- `@nesvel/tsup-config` - Build configuration (optional)
- `prettier` - Code formatter
- `tsup` - Build tool
- `typescript` - TypeScript compiler
- `vitest` - Test runner
- `@vitest/ui` - Test UI (optional)
- `@types/node` - Node.js type definitions
- For React packages: `@types/react`, `react`, `@testing-library/react`, `@testing-library/jest-dom`, `jsdom`

### 2. tsconfig.json

```json
{
  "extends": "@nesvel/typescript-config/base.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": ".",

    /* Module resolution - Override Nesvel's NodeNext for compatibility */
    "module": "ESNext",
    "moduleResolution": "bundler",

    /* Decorators - Required for DI container */
    "experimentalDecorators": true,

    /* Build options */
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,

    /* Path aliases */
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    },

    /* Testing */
    "types": ["vitest/globals"]
  },
  "include": ["src/**/*", "__tests__/**/*"],
  "exclude": ["node_modules", "dist", "config"]
}
```

**Key Points:**

- Extend Nesvel's base TypeScript config
- Enable `experimentalDecorators` for DI support
- Use `@/*` path alias for clean imports
- Include vitest globals for testing

### 3. tsup.config.ts

```typescript
import { defineConfig } from "tsup";

export default defineConfig({
  entry: ["src/index.ts"],
  format: ["esm", "cjs"],
  dts: true,
  sourcemap: true,
  clean: true,
  minify: false,
  target: "es2020",
  platform: "neutral",
  external: ["@abdokouta/react-di", "react"],
  splitting: false,
  skipNodeModulesBundle: true,
  outExtension({ format }) {
    return { js: format === "esm" ? ".mjs" : ".js" };
  },
});
```

**Key Points:**

- Dual format output (ESM + CJS)
- Generate TypeScript declarations
- Don't minify library code
- External peer dependencies
- Proper file extensions (.mjs for ESM, .js for CJS)

**Note for Monorepo:**

- Packages can reference each other using `workspace:*` protocol
- Examples reference packages using `workspace:*` in dependencies

### 4. vitest.config.ts

```typescript
import { defineConfig } from "vitest/config";
import path from "path";

export default defineConfig({
  test: {
    globals: true,
    environment: "jsdom", // or 'node' for non-React packages
    setupFiles: ["__tests__/setup.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html"],
      exclude: [
        "node_modules/",
        "__tests__/",
        "dist/",
        "**/*.test.ts",
        "**/*.test.tsx",
      ],
    },
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
```

### 5. .gitignore

```
# Dependencies
node_modules/

# Build output
dist/
*.tsbuildinfo

# Testing
coverage/

# IDE
.DS_Store
.vscode/
.idea/

# Turbo
.turbo/

# Logs
*.log
```

**Important Notes:**

- `package-lock.json` or `pnpm-lock.yaml` MUST be committed to the repository (do NOT add to .gitignore)
- The lockfile is required for `npm ci` or `pnpm install --frozen-lockfile` in CI/CD pipelines
- For monorepo, only root lockfile is needed (`pnpm-lock.yaml` at root)

### 6. prettierrc.ts

```typescript
/**
 * @fileoverview Prettier Configuration
 *
 * Extends the Nesvel Prettier configuration for consistent code formatting.
 *
 * @see https://prettier.io/docs/en/configuration.html
 */

export default "@nesvel/prettier-config";
```

**Key Points:**

- MUST be named `prettierrc.ts` (not `.prettierrc.js`)
- MUST include docblock with `@fileoverview` and `@see` tags
- Extends `@nesvel/prettier-config` for consistency across packages
- Used by `format` and `format:check` scripts

### 7. Monorepo Commands

#### Root Level Commands (using Turbo)

```bash
# Build all packages
pnpm build

# Run dev mode for all packages
pnpm dev

# Run tests for all packages
pnpm test

# Lint all packages
pnpm lint

# Format all code
pnpm format

# Clean all build outputs
pnpm clean
```

#### Package-Specific Commands

```bash
# Build specific package
pnpm --filter @abdokouta/react-di build

# Run dev mode for specific package
pnpm --filter @abdokouta/react-di dev

# Run example app
pnpm --filter vite-template dev
```

#### Workspace Management

```bash
# Install dependencies for all workspaces
pnpm install

# Add dependency to specific package
pnpm --filter @abdokouta/react-di add inversify

# Add dev dependency to root
pnpm add -D -w turbo

# Link workspace packages
# Automatically handled by pnpm with workspace:* protocol
```

### 8. CI/CD Workflows (.github/workflows/)

Every package MUST have these two GitHub Actions workflows at the root level:

#### ci.yml - Continuous Integration

```yaml
# =============================================================================
# CI Workflow
# =============================================================================
# Runs automated tests and linting on every push and pull request to main/develop
# branches. Ensures code quality and prevents broken code from being merged.
#
# Jobs:
# - test: Runs tests on Node.js 20
# - lint: Checks code formatting with Prettier
# =============================================================================

name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  # ===========================================================================
  # Test Job
  # ===========================================================================
  # Runs the test suite using Turbo for caching
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v4
        with:
          version: 10

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "pnpm"

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Build packages
        run: pnpm build

      - name: Run tests
        run: pnpm test
        continue-on-error: true

  # ===========================================================================
  # Lint Job
  # ===========================================================================
  # Checks code formatting to ensure consistent code style
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v4
        with:
          version: 10

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "pnpm"

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Check formatting
        run: pnpm format:check
        continue-on-error: true
```

#### publish.yml - NPM Publishing

```yaml
# =============================================================================
# Publish to npm Workflow
# =============================================================================
# Automatically publishes packages to npm when a version tag is pushed.
# Triggered by tags matching the pattern v* (e.g., v1.0.0, v1.2.3)
#
# Requirements:
# - NPM_TOKEN secret must be configured in repository settings
# - Package version in package.json must match the tag version
#
# Process:
# 1. Checkout code
# 2. Setup pnpm and Node.js
# 3. Install dependencies
# 4. Build packages
# 5. Publish to npm with public access
# =============================================================================

name: Publish to npm

on:
  push:
    tags:
      - "v*"
  workflow_dispatch:

jobs:
  # ===========================================================================
  # Publish Job
  # ===========================================================================
  # Builds and publishes packages to npm registry
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v4
        with:
          version: 10

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          registry-url: "https://registry.npmjs.org"
          cache: "pnpm"

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Build packages
        run: pnpm build

      - name: Publish to npm
        run: |
          cd packages/container
          npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

**Key Points:**

- Use `pnpm install --frozen-lockfile` for reproducible builds
- Use `pnpm` for all commands (not `npm`)
- Setup pnpm before Node.js
- Enable pnpm caching with `cache: 'pnpm'`
- Publish from specific package directory
- Publish workflow requires `NPM_TOKEN` secret in repository settings
- Always use `--access public` for scoped packages

---

## 🏗️ Registry Pattern (for Extensible Systems)

When creating a package that needs to be extensible (like Logger, Cache, Redis, Config, Theming), implement the registry pattern:

### Registry Structure

```
src/
├── registries/
│   ├── {component-type}.registry.ts    # Main registry
│   ├── helpers/
│   │   └── {component-type}.helpers.ts # Helper functions
│   └── index.ts
```

### Registry Implementation Pattern

````typescript
/**
 * @fileoverview {ComponentType} Registry
 *
 * Centralized registry for managing {components} using BaseRegistry
 * from @abdokouta/support for consistent registry API.
 *
 * Key Features:
 * - Collection-based storage (O(1) operations)
 * - Built-in component registration
 * - Custom component support
 * - Type-safe component access
 *
 * @module @abdokouta/{package-name}
 * @category Registries
 */

import { BaseRegistry } from "@abdokouta/support";
import { Injectable } from "@abdokouta/react-di";
import type { ComponentInterface } from "@/interfaces/component.interface";

/**
 * {ComponentType} Registry Service (DI-injectable)
 *
 * Injectable service for managing {components}.
 *
 * @example
 * ```typescript
 * import { useInject } from '@abdokouta/react-di';
 * import { ComponentRegistryService } from '@abdokouta/{package-name}';
 *
 * const registry = useInject(ComponentRegistryService);
 *
 * // Register custom component
 * registry.register('custom', customComponent);
 *
 * // Get component
 * const component = registry.get('custom');
 * ```
 */
@Injectable()
export class ComponentRegistryService extends BaseRegistry<ComponentInterface> {
  private builtInComponents: Set<string> = new Set();

  constructor() {
    super({
      validateBeforeAdd: (_key: string, component: ComponentInterface) => {
        // Validation logic
        if (!component.requiredProperty) {
          return {
            valid: false,
            error: "Component must have requiredProperty",
          };
        }
        return { valid: true };
      },
    });

    // Register built-in components
    this.loadBuiltInComponents();
  }

  private loadBuiltInComponents(): void {
    // Register built-in components here
    this.registerComponent("builtin1", builtIn1Component, true);
    this.registerComponent("builtin2", builtIn2Component, true);
  }

  registerComponent(
    name: string,
    component: ComponentInterface,
    isBuiltIn = false,
  ): void {
    // Check for name conflicts with built-in components
    if (!isBuiltIn && this.builtInComponents.has(name)) {
      throw new Error(
        `Cannot register component "${name}": This name is reserved for a built-in component.`,
      );
    }

    this.add(name, component);

    if (isBuiltIn) {
      this.builtInComponents.add(name);
    }
  }

  getBuiltInComponentNames(): string[] {
    return Array.from(this.builtInComponents);
  }

  isBuiltInComponent(name: string): boolean {
    return this.builtInComponents.has(name);
  }
}

/**
 * Global singleton instance
 */
export const componentRegistry = new ComponentRegistryService();

/**
 * Decorator for automatic registration
 *
 * @example
 * ```typescript
 * @Component({ name: 'custom' })
 * export class CustomComponent implements ComponentInterface {
 *   // implementation
 * }
 * ```
 */
export function Component(options: { name: string }) {
  return function (target: any) {
    componentRegistry.registerComponent(options.name, target);
    return target;
  };
}
````

### Module Static Methods Pattern

The module class MUST provide these three static methods following the health.module.ts pattern:

1. **forRoot(config)** - Primary configuration method
2. **registerComponent(options)** - Register a single component
3. **registerComponents(optionsArray)** - Register multiple components

````typescript
// In {package-name}.module.ts

@Module({})
export class PackageModule {
  private static registry = ComponentRegistryService.make();

  /**
   * Configure the module with options
   *
   * @param config - Module configuration
   * @returns Dynamic module
   */
  static forRoot(config: IPackageModuleOptions = {}): DynamicModule {
    // Implementation shown in Module Pattern section above
  }

  /**
   * Register a custom component
   *
   * @param options - Component registration options
   * @returns Dynamic module
   *
   * @example
   * ```typescript
   * PackageModule.registerComponent({
   *   component: CustomComponent,
   *   name: 'custom',
   * });
   * ```
   */
  static registerComponent(
    options: IComponentRegistrationOptions,
  ): DynamicModule {
    PackageModule.registry.register(options);

    return {
      module: PackageModule,
      providers: [options.component],
      exports: [options.component],
    };
  }

  /**
   * Register multiple components
   *
   * @param optionsArray - Array of component registration options
   * @returns Dynamic module
   */
  static registerComponents(
    optionsArray: IComponentRegistrationOptions[],
  ): DynamicModule {
    PackageModule.registry.registerMultiple(optionsArray);

    const components = optionsArray.map((options) => options.component);

    return {
      module: PackageModule,
      providers: components,
      exports: components,
    };
  }

  /**
   * Get all registered component names (utility method)
   */
  static getComponentNames(): string[] {
    return PackageModule.registry.keys();
  }
}
````

---

## 📝 Index File Pattern

Every folder with multiple files MUST have an `index.ts` that re-exports the public API.

### Index File Types

There are two types of index files:

1. **Main Folder Index Files** - Located at the root of major folders (e.g., `src/interfaces/index.ts`, `src/types/index.ts`, `src/decorators/index.ts`)
   - MUST have full docblock with `@fileoverview`, `@module`, and `@category`
   - MUST use section headers with `// ============================================================================`
   - MUST group exports by category

2. **Sub-Folder Index Files** - Located in nested folders (e.g., `src/hooks/use-inject/index.ts`)
   - MUST have simple docblock with `@fileoverview`, `@module`, and `@category`
   - NO section headers needed
   - Simple re-exports only

### Root index.ts Pattern

````typescript
/**
 * @abdokouta/{package-name}
 *
 * Brief description of the package and its purpose.
 *
 * @example
 * Basic usage:
 * ```typescript
 * import { Service, useHook } from '@abdokouta/{package-name}';
 *
 * // Usage example
 * ```
 *
 * @module @abdokouta/{package-name}
 */

// ============================================================================
// Module (DI Configuration)
// ============================================================================
export { PackageModule } from "./{package-name}.module";

// ============================================================================
// Core Services
// ============================================================================
export { MainService } from "./services/main.service";
export type { MainServiceInterface } from "./interfaces/main-service.interface";

// ============================================================================
// Registries (if applicable)
// ============================================================================
export { ComponentRegistryService, componentRegistry } from "./registries";
export { Component } from "./registries";

// ============================================================================
// Components (if applicable)
// ============================================================================
export { MyComponent } from "./components";
export type { MyComponentProps } from "./components";

// ============================================================================
// Hooks (if applicable)
// ============================================================================
export { useMyHook } from "./hooks";
export type { UseMyHookReturn } from "./hooks";

// ============================================================================
// Interfaces
// ============================================================================
export type { MyInterface } from "./interfaces";

// ============================================================================
// Types
// ============================================================================
export type { MyType } from "./types";

// ============================================================================
// Enums
// ============================================================================
export { MyEnum } from "./enums";

// ============================================================================
// Configuration
// ============================================================================
export { DEFAULT_CONFIG } from "./config";

// ============================================================================
// Constants
// ============================================================================
export { MY_CONSTANT } from "./constants";

// ============================================================================
// Utilities
// ============================================================================
export { myUtil } from "./utils";
````

### Main Folder Index Pattern

```typescript
/**
 * @fileoverview Interfaces Index
 *
 * Re-exports all interface definitions.
 *
 * @module @abdokouta/{package-name}
 * @category Interfaces
 */

// ============================================================================
// Module Configuration Interfaces
// ============================================================================
export type { IContainerConfig } from "./container-config.interface";
export type { IModuleOptions } from "./module-options.interface";
export type { IModuleAsyncOptions } from "./module-async-options.interface";

// ============================================================================
// Lifecycle Interfaces
// ============================================================================
export type { OnModuleInit, OnModuleDestroy } from "./lifecycle.interface";
export { hasOnModuleInit, hasOnModuleDestroy } from "./lifecycle.interface";

// ============================================================================
// Component Interfaces
// ============================================================================
export type { ContainerProviderProps } from "./container-provider-props.interface";
```

### Sub-Folder Index Pattern

```typescript
/**
 * @fileoverview useInject Hook
 *
 * Re-exports the useInject hook.
 *
 * @module @abdokouta/{package-name}
 * @category Hooks
 */

export { useInject } from "./use-inject.hook";
```

**Key Points:**

- Group exports by category with comment headers in main folder index files
- Export both classes and their interfaces
- Export decorators from registries
- Maintain consistent ordering across packages
- Use relative imports (e.g., `"../types"`) instead of path aliases (e.g., `"@/types"`)
- Sub-folder index files should be simple with just a docblock and exports

**Import Path Rules:**

- NEVER use path aliases like `@/types/service-identifier.type` in source files
- ALWAYS use relative imports like `"../types"` or `"@/types"`
- Import from the folder's index file, not individual files (e.g., `from "@/types"` not `from "@/types/service-identifier.type"`)

---

## 🧪 Testing Pattern

### Test File Structure

```typescript
import { describe, it, expect, beforeEach, afterEach } from "vitest";
import { MyService } from "./my-service.service";

describe("MyService", () => {
  let service: MyService;

  beforeEach(() => {
    service = new MyService();
  });

  afterEach(() => {
    // Cleanup
  });

  describe("methodName", () => {
    it("should do something when condition is met", () => {
      // Arrange
      const input = "test";

      // Act
      const result = service.methodName(input);

      // Assert
      expect(result).toBe("expected");
    });

    it("should throw error when invalid input", () => {
      // Arrange
      const invalidInput = null;

      // Act & Assert
      expect(() => service.methodName(invalidInput)).toThrow("Error message");
    });
  });
});
```

---

## 🎨 Component Pattern (React)

### Component File Structure

````typescript
/**
 * @fileoverview {ComponentName} Component
 *
 * Brief description of what the component does.
 *
 * @module @abdokouta/{package-name}
 * @category Components
 */

import React from 'react';
import type { ComponentNameProps } from './component-name.types';

/**
 * {ComponentName} Component
 *
 * Detailed description of the component's purpose and behavior.
 *
 * @example
 * ```tsx
 * <ComponentName prop1="value" prop2={123} />
 * ```
 */
export const ComponentName: React.FC<ComponentNameProps> = ({
  prop1,
  prop2,
  ...rest
}) => {
  // Component implementation

  return (
    <div {...rest}>
      {/* JSX */}
    </div>
  );
};

ComponentName.displayName = 'ComponentName';
````

### Component Types File

```typescript
/**
 * Props for ComponentName component
 */
export interface ComponentNameProps {
  /**
   * Description of prop1
   */
  prop1: string;

  /**
   * Description of prop2
   * @default 0
   */
  prop2?: number;
}
```

---

## 🪝 Hook Pattern (React)

### Hook File Structure

````typescript
/**
 * @fileoverview use{HookName} Hook
 *
 * Brief description of what the hook does.
 *
 * @module @abdokouta/{package-name}
 * @category Hooks
 */

import { useState, useEffect } from "react";
import type {
  UseHookNameReturn,
  UseHookNameOptions,
} from "./use-hook-name.types";

/**
 * use{HookName} Hook
 *
 * Detailed description of the hook's purpose and behavior.
 *
 * @param options - Hook options
 * @returns Hook return value
 *
 * @example
 * ```tsx
 * const { value, setValue } = useHookName({ initialValue: 'test' });
 * ```
 */
export const useHookName = (
  options?: UseHookNameOptions,
): UseHookNameReturn => {
  const [value, setValue] = useState(options?.initialValue);

  useEffect(() => {
    // Effect logic
  }, [value]);

  return {
    value,
    setValue,
  };
};
````

### Hook Types File

```typescript
/**
 * Options for useHookName hook
 */
export interface UseHookNameOptions {
  /**
   * Initial value
   */
  initialValue?: string;
}

/**
 * Return value for useHookName hook
 */
export interface UseHookNameReturn {
  /**
   * Current value
   */
  value: string | undefined;

  /**
   * Set value function
   */
  setValue: (value: string) => void;
}
```

---

## 🔧 Service Pattern (DI)

### Service File Structure

````typescript
/**
 * @fileoverview {ServiceName} Service
 *
 * Brief description of what the service does.
 *
 * @module @abdokouta/{package-name}
 * @category Services
 */

import { Injectable, Inject } from "@abdokouta/react-di";
import type { ServiceNameInterface } from "@/interfaces/service-name.interface";
import { DEPENDENCY_TOKEN } from "@/constants/tokens.constant";

/**
 * {ServiceName} Service
 *
 * Detailed description of the service's purpose and behavior.
 *
 * @example
 * ```typescript
 * @Injectable()
 * class MyClass {
 *   constructor(
 *     @Inject(ServiceName) private service: ServiceName
 *   ) {}
 * }
 * ```
 */
@Injectable()
export class ServiceName implements ServiceNameInterface {
  constructor(@Inject(DEPENDENCY_TOKEN) private dependency: DependencyType) {}

  /**
   * Method description
   *
   * @param param - Parameter description
   * @returns Return value description
   */
  public methodName(param: string): string {
    // Implementation
    return this.dependency.process(param);
  }
}
````

---

## 🏛️ Module Pattern (NestJS/Dynamic Modules)

### Module File Structure

All packages that provide configurable functionality MUST follow this standard module pattern, inspired by the health.module.ts reference implementation.

````typescript
/**
 * @fileoverview {PackageName} Module
 *
 * Brief description of what the module provides.
 *
 * Features:
 * - Feature 1
 * - Feature 2
 * - Feature 3
 *
 * @module {PackageName}Module
 *
 * @example Basic Usage
 * ```typescript
 * import { PackageModule } from '@abdokouta/{package-name}';
 *
 * @Module({
 *   imports: [PackageModule.forRoot()],
 * })
 * export class AppModule {}
 * ```
 *
 * @example With Configuration
 * ```typescript
 * import { PackageModule } from '@abdokouta/{package-name}';
 *
 * @Module({
 *   imports: [
 *     PackageModule.forRoot({
 *       option1: 'value1',
 *       option2: true,
 *     })
 *   ],
 * })
 * export class AppModule {}
 * ```
 *
 * @example With Custom Registration
 * ```typescript
 * @Module({
 *   imports: [
 *     PackageModule.forRoot({ ... }),
 *     PackageModule.registerComponent({
 *       component: CustomComponent,
 *       name: 'custom',
 *     }),
 *   ],
 * })
 * export class AppModule {}
 * ```
 */
@Module({})
export class PackageModule {
  /**
   * Global registry instance
   *
   * Shared across all module instances to manage registered components.
   *
   * @private
   * @static
   */
  private static registry = ComponentRegistryService.make();

  /**
   * Register Module with Configuration
   *
   * Primary method for configuring and initializing the module.
   * Merges user configuration with sensible defaults.
   *
   * @static
   * @param {IPackageModuleOptions} config - Module configuration options
   * @returns {DynamicModule} Configured dynamic module
   *
   * @example Basic configuration
   * ```typescript
   * @Module({
   *   imports: [
   *     PackageModule.forRoot({
   *       basePath: 'api',
   *       enabled: true,
   *     })
   *   ]
   * })
   * export class AppModule {}
   * ```
   *
   * @example Advanced configuration
   * ```typescript
   * @Module({
   *   imports: [
   *     PackageModule.forRoot({
   *       basePath: 'api',
   *       enabled: true,
   *       components: {
   *         component1: true,
   *         component2: false,
   *       },
   *       customComponents: [CustomComponent1, CustomComponent2],
   *       customChecks: [customCheck1, customCheck2],
   *     })
   *   ]
   * })
   * export class AppModule {}
   * ```
   */
  static forRoot(config: IPackageModuleOptions = {}): DynamicModule {
    // Merge with defaults
    const mergedConfig: IPackageModuleOptions = {
      basePath: config.basePath || "default",
      enabled: config.enabled !== false,
      components: {
        component1: config.components?.component1 !== false,
        component2: config.components?.component2 === true,
      },
      customComponents: config.customComponents || [],
      customChecks: config.customChecks || [],
    };

    // Build providers array
    const providers: any[] = [
      // Core providers
      CoreService,
    ];

    // Conditionally add components based on config
    if (mergedConfig.components?.component1) {
      providers.push(Component1);
      PackageModule.registry.register({
        component: Component1,
        name: "component1",
      });
    }

    if (mergedConfig.components?.component2) {
      providers.push(Component2);
      PackageModule.registry.register({
        component: Component2,
        name: "component2",
      });
    }

    // Add custom components
    if (mergedConfig.customComponents) {
      providers.push(...mergedConfig.customComponents);
    }

    // Add registry service
    providers.push({
      provide: ComponentRegistryService,
      useValue: PackageModule.registry,
    });

    // Add configuration provider
    providers.push({
      provide: PACKAGE_MODULE_CONFIG,
      useValue: mergedConfig,
    });

    // Add all registered components from registry
    const registeredComponents =
      PackageModule.registry.getAllComponentClasses();
    providers.push(...registeredComponents);

    // Create dynamic controller/service with config (if needed)
    const DynamicController = createDynamicController(mergedConfig);

    return {
      module: PackageModule,
      imports: [
        // Required module imports
      ],
      controllers: [DynamicController],
      providers,
      exports: providers.filter(
        (p) => typeof p !== "object" || p.provide !== PACKAGE_MODULE_CONFIG,
      ),
    };
  }

  /**
   * Register a custom component
   *
   * Registers a component to be used across the application.
   * The component will be automatically available in the module.
   *
   * This method provides a clean way to register custom components
   * without manual dependency injection, following the same pattern
   * as SearchModule.registerIndex() from @nesvel/nestjs-search.
   *
   * @static
   * @param {IComponentRegistrationOptions} options - Component registration options
   * @returns {DynamicModule} A dynamic module with the registered component
   *
   * @example Register a custom component
   * ```typescript
   * @Module({
   *   imports: [
   *     PackageModule.forRoot({ ... }),
   *     PackageModule.registerComponent({
   *       component: CustomComponent,
   *       name: 'custom',
   *     }),
   *   ],
   * })
   * export class AppModule {}
   * ```
   *
   * @example Register with options
   * ```typescript
   * @Module({
   *   imports: [
   *     PackageModule.forRoot({ ... }),
   *     PackageModule.registerComponent({
   *       component: CustomComponent,
   *       name: 'custom',
   *       options: {
   *         priority: 10,
   *         enabled: true,
   *       },
   *     }),
   *   ],
   * })
   * export class AppModule {}
   * ```
   */
  static registerComponent(
    options: IComponentRegistrationOptions,
  ): DynamicModule {
    // Register the component in the global registry
    PackageModule.registry.register(options);

    return {
      module: PackageModule,
      providers: [options.component],
      exports: [options.component],
    };
  }

  /**
   * Register multiple custom components
   *
   * Convenience method to register multiple components at once.
   * Functionally equivalent to calling registerComponent() multiple times.
   *
   * @static
   * @param {IComponentRegistrationOptions[]} optionsArray - Array of component registration options
   * @returns {DynamicModule} A dynamic module with all registered components
   *
   * @example Register multiple components
   * ```typescript
   * @Module({
   *   imports: [
   *     PackageModule.forRoot({ ... }),
   *     PackageModule.registerComponents([
   *       { component: CustomComponent1, name: 'custom1' },
   *       { component: CustomComponent2, name: 'custom2' },
   *       { component: CustomComponent3, name: 'custom3' },
   *     ]),
   *   ],
   * })
   * export class AppModule {}
   * ```
   *
   * @example Register with mixed options
   * ```typescript
   * @Module({
   *   imports: [
   *     PackageModule.forRoot({ ... }),
   *     PackageModule.registerComponents([
   *       {
   *         component: CustomComponent1,
   *         name: 'custom1',
   *         options: { priority: 10 }
   *       },
   *       {
   *         component: CustomComponent2,
   *         name: 'custom2',
   *         options: { enabled: false }
   *       },
   *     ]),
   *   ],
   * })
   * export class AppModule {}
   * ```
   */
  static registerComponents(
    optionsArray: IComponentRegistrationOptions[],
  ): DynamicModule {
    // Register all components in the global registry
    PackageModule.registry.registerMultiple(optionsArray);

    // Extract all component classes
    const components = optionsArray.map((options) => options.component);

    return {
      module: PackageModule,
      providers: components,
      exports: components,
    };
  }
}
````

### Module Pattern Key Principles

1. **Static Registry**: Use a private static registry instance shared across all module instances
2. **forRoot() Method**: Primary configuration method that merges user config with defaults
3. **Registration Methods**: Provide `registerComponent()` and `registerComponents()` for extensibility
4. **Dynamic Module**: Return DynamicModule with proper imports, providers, controllers, and exports
5. **Configuration Provider**: Inject configuration using a constant token
6. **Comprehensive JSDoc**: Include multiple examples showing basic, advanced, and edge case usage
7. **Conditional Providers**: Only add providers based on configuration flags
8. **Registry Integration**: Register components in the global registry for cross-module access

### Module Configuration Interface

```typescript
/**
 * Configuration options for PackageModule
 */
export interface IPackageModuleOptions {
  /**
   * Base path for routes/endpoints
   * @default 'default'
   */
  basePath?: string;

  /**
   * Enable/disable the module
   * @default true
   */
  enabled?: boolean;

  /**
   * Component configuration
   */
  components?: {
    /**
     * Enable component 1
     * @default true
     */
    component1?: boolean;

    /**
     * Enable component 2
     * @default false
     */
    component2?: boolean;
  };

  /**
   * Custom components to register
   * @default []
   */
  customComponents?: any[];

  /**
   * Custom checks/validators
   * @default []
   */
  customChecks?: any[];
}

/**
 * Component registration options
 */
export interface IComponentRegistrationOptions {
  /**
   * Component class to register
   */
  component: any;

  /**
   * Unique name for the component
   */
  name: string;

  /**
   * Optional component-specific options
   */
  options?: Record<string, any>;
}
```

---

## 📚 Documentation Requirements

### 1. README.md

Every package MUST have a comprehensive README.md with:

```markdown
# @abdokouta/{package-name}

Brief description of the package.

## Installation

\`\`\`bash
pnpm add @abdokouta/{package-name}
\`\`\`

## Features

- Feature 1
- Feature 2
- Feature 3

## Usage

### Basic Usage

\`\`\`typescript
import { Service } from '@abdokouta/{package-name}';

// Usage example
\`\`\`

### Advanced Usage

\`\`\`typescript
// Advanced example
\`\`\`

## API Reference

### Services

#### ServiceName

Description of the service.

**Methods:**

- `methodName(param: string): string` - Method description

### Hooks

#### useHookName

Description of the hook.

**Parameters:**

- `options` - Hook options

**Returns:**

- `value` - Current value
- `setValue` - Set value function

## Configuration

Configuration options and examples.

## Testing

\`\`\`bash
pnpm test
\`\`\`

## License

MIT
```

### 2. JSDoc Comments

All exported functions, classes, interfaces, and types MUST have JSDoc comments with:

- `@fileoverview` - File description
- `@module` - Module name
- `@category` - Category (Services, Hooks, Components, etc.)
- `@param` - Parameter descriptions
- `@returns` - Return value description
- `@example` - Usage examples
- `@throws` - Error descriptions (if applicable)

---

## ✅ Checklist for Creating a New Package

### Initial Setup

- [ ] Create package directory: `packages/{category}/{package-name}/`
- [ ] Create `package.json` with correct name, version, and dependencies
- [ ] Create `tsconfig.json` with correct configuration
- [ ] Create `tsup.config.ts` for build configuration
- [ ] Create `vitest.config.ts` for test configuration
- [ ] Create `.gitignore` file
- [ ] Create `.prettierrc.js` file
- [ ] Create `eslint.config.js` file

### Source Structure

- [ ] Create `src/` directory
- [ ] Create `src/index.ts` as main entry point
- [ ] Create `src/{package-name}.module.ts` following the standard module pattern
  - [ ] Add `@Module({})` decorator
  - [ ] Add private static registry instance
  - [ ] Implement `forRoot(config)` method with comprehensive JSDoc
  - [ ] Implement `registerComponent(options)` method
  - [ ] Implement `registerComponents(optionsArray)` method
  - [ ] Add multiple usage examples in JSDoc
- [ ] Create folder structure based on package needs:
  - [ ] `services/` for business logic
  - [ ] `registries/` for extensible systems
  - [ ] `interfaces/` for TypeScript interfaces
  - [ ] `types/` for TypeScript types
  - [ ] `enums/` for TypeScript enums
  - [ ] `constants/` for constants (including config tokens)
  - [ ] `utils/` for utility functions
  - [ ] `hooks/` for React hooks (if applicable)
  - [ ] `components/` for React components (if applicable)
  - [ ] `contexts/` for React contexts (if applicable)
  - [ ] `providers/` for React providers (if applicable)
  - [ ] `factories/` for dynamic factories (if needed)

### Registry Pattern (if applicable)

- [ ] Create `registries/` folder
- [ ] Create registry service extending `BaseRegistry`
- [ ] Create global singleton instance
- [ ] Create decorator for auto-registration
- [ ] Add static methods to module class
- [ ] Register built-in components
- [ ] Add validation logic

### Testing

- [ ] Create `__tests__/` directory
- [ ] Create test setup file
- [ ] Write unit tests for all services
- [ ] Write integration tests
- [ ] Achieve >80% code coverage

### Documentation

- [ ] Create comprehensive `README.md`
- [ ] Add JSDoc comments to all exports
- [ ] Create `.examples/` directory with usage examples
- [ ] Create `.docs/` directory for additional documentation (if needed)

### Build & Publish

- [ ] Run `pnpm build` to verify build works
- [ ] Run `pnpm test` to verify all tests pass
- [ ] Run `pnpm lint` to verify code quality
- [ ] Add package to workspace in root `pnpm-workspace.yaml`
- [ ] Update root `package.json` if needed

---

## 🚀 Quick Start Template

Use this command to scaffold a new package:

```bash
# Create package directory
mkdir -p packages/production/{package-name}/src

# Create basic files
touch packages/production/{package-name}/package.json
touch packages/production/{package-name}/tsconfig.json
touch packages/production/{package-name}/tsup.config.ts
touch packages/production/{package-name}/vitest.config.ts
touch packages/production/{package-name}/.gitignore
touch packages/production/{package-name}/README.md
touch packages/production/{package-name}/src/index.ts

# Create folder structure
mkdir -p packages/production/{package-name}/src/{services,interfaces,types,enums,constants,utils}
mkdir -p packages/production/{package-name}/__tests__
mkdir -p packages/production/{package-name}/.examples

# Create index files
touch packages/production/{package-name}/src/services/index.ts
touch packages/production/{package-name}/src/interfaces/index.ts
touch packages/production/{package-name}/src/types/index.ts
touch packages/production/{package-name}/src/enums/index.ts
touch packages/production/{package-name}/src/constants/index.ts
touch packages/production/{package-name}/src/utils/index.ts
```

Then fill in the configuration files using the templates above.

---

## 📖 Additional Resources

- [Health Module Reference](sources/health.module.ts) - **STANDARD MODULE PATTERN** - All modules MUST follow this pattern
- [Refine Conventions](.kiro/steering/refine-conventions.md) - File naming and structure conventions
- [BaseRegistry Documentation](packages/production/support/src/collections/base-registry.ts) - Registry pattern implementation
- [Container Documentation](packages/production/container/README.md) - Dependency injection system
- [Theming Package](packages/production/theming/) - Reference implementation with registries
- [Logger Package](packages/production/logger/) - Reference implementation with transporters and formatters

---

## 💡 Best Practices

1. **Follow the Single Responsibility Principle** - Each file should have one clear purpose
2. **Use the Standard Module Pattern** - All modules MUST follow the health.module.ts pattern with forRoot(), registerComponent(), and registerComponents() methods
3. **Use Dependency Injection** - Leverage `@abdokouta/react-di` for loose coupling
4. **Write Tests First** - TDD approach ensures better code quality
5. **Document Everything** - JSDoc comments with multiple examples help other developers understand your code
6. **Use TypeScript Strictly** - Enable strict mode and avoid `any` types
7. **Follow Naming Conventions** - Consistency makes the codebase easier to navigate
8. **Keep It Simple** - Don't over-engineer, start simple and refactor as needed
9. **Use Registries for Extensibility** - When building pluggable systems, use the registry pattern with static registry instances
10. **Maintain Backward Compatibility** - Don't break existing APIs without major version bump
11. **Write Comprehensive Examples** - Examples in `.examples/` and JSDoc help users understand usage
12. **Static Registry Pattern** - Use private static registry instances in modules for cross-instance component management
13. **Configuration Merging** - Always merge user configuration with sensible defaults in forRoot()
14. **Conditional Providers** - Only add providers to the module based on configuration flags

---

**Last Updated:** 2026-03-30
**Maintained By:** Pixielity Team
