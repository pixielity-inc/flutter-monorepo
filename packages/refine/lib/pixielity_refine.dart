// ignore_for_file: lines_longer_than_80_chars
/// pixielity_refine
///
/// Refine-like framework for Flutter.
///
/// Architecture (bottom → top):
///
///   Repository  — pure data access (API / DB / cache). No business logic.
///   Service     — business logic. Resolved via GetIt (App.make<T>()).
///   Providers   — Riverpod providers. Flutter equivalent of React Query
///                 hooks (useList, useOne, useCreate …).
///   Resource    — metadata (name, service, form, table, filter) + registry.
///   Builders    — fluent DSLs: Form, Table, Filter, Chart, Dashboard, Nav.
///   Renderers   — Material widgets driven by builder schemas.
///   Pages       — auto CRUD widgets (ListPage / CreatePage / EditPage).
///
/// DI strategy:
///   GetIt (via pixielity_container) owns service/repository lifetimes.
///   Riverpod owns UI-reactive state.
///
/// Usage:
/// ```dart
/// import 'package:pixielity_refine/pixielity_refine.dart';
/// ```
library;

// ── Repository ────────────────────────────────────────────────────────────────
export 'src/repository/base_repository.dart';
export 'src/repository/query_params.dart';

// ── Service ───────────────────────────────────────────────────────────────────
export 'src/service/base_service.dart';

// ── Riverpod providers ────────────────────────────────────────────────────────
export 'src/providers/create_provider.dart';
export 'src/providers/delete_provider.dart';
export 'src/providers/list_provider.dart';
export 'src/providers/one_provider.dart';
export 'src/providers/update_provider.dart';

// ── Auth provider ─────────────────────────────────────────────────────────────
export 'src/providers/auth/auth_notifier.dart';
export 'src/providers/auth/auth_provider.dart';

// ── Access control provider ───────────────────────────────────────────────────
export 'src/providers/access_control/access_control_provider.dart';
export 'src/providers/access_control/use_can.dart';

// ── Live provider (real-time) ─────────────────────────────────────────────────
export 'src/providers/live/live_provider.dart';

// ── Notification provider ─────────────────────────────────────────────────────
export 'src/providers/notification/notification_provider.dart';

// ── Audit log provider ────────────────────────────────────────────────────────
export 'src/providers/audit_log/audit_log_provider.dart';

// ── Resource ──────────────────────────────────────────────────────────────────
export 'src/resource/resource.dart';
export 'src/resource/resource_registry.dart';

// ── Builders ──────────────────────────────────────────────────────────────────
export 'src/builder/chart_builder.dart';
export 'src/builder/dashboard_builder.dart';
export 'src/builder/field.dart';
export 'src/builder/filter_builder.dart';
export 'src/builder/form_builder.dart';
export 'src/builder/navigation_builder.dart';
export 'src/builder/table_builder.dart';

// ── Renderers ─────────────────────────────────────────────────────────────────
export 'src/renderer/chart_renderer.dart';
export 'src/renderer/dashboard_renderer.dart';
export 'src/renderer/field_renderer.dart';
export 'src/renderer/filter_renderer.dart';
export 'src/renderer/form_renderer.dart';
export 'src/renderer/navigation_renderer.dart';
export 'src/renderer/table_renderer.dart';

// ── Auto CRUD pages ───────────────────────────────────────────────────────────
export 'src/pages/create_page.dart';
export 'src/pages/edit_page.dart';
export 'src/pages/list_page.dart';

// ── Service provider ──────────────────────────────────────────────────────────
export 'src/refine_service_provider.dart';
