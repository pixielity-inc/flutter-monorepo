// ignore_for_file: lines_longer_than_80_chars
//
// container_explorer_page.dart
//
// Demonstrates the pixielity_container IoC container:
//   - Shows all registered bindings (singleton vs transient)
//   - Demonstrates App.bind(), App.singleton(), App.make()
//   - Shows the two-phase ServiceProvider boot cycle
//   - Lets the user trigger App.make<T>() and see the resolved value

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_container/pixielity_container.dart' as ioc;
import 'package:pixielity_example_app/pages/shared/explorer_scaffold.dart';

// ── Demo services registered for this page ────────────────────────────────────

/// A simple counter service used to demonstrate singleton vs transient binding.
///
/// Each time [increment] is called the internal counter increases.
/// When registered as a singleton, the same instance is reused across
/// all [App.make<CounterService>()] calls — so the count persists.
/// When registered as a transient binding, a fresh instance (count=0)
/// is returned every time.
class CounterService {
  /// Creates a [CounterService] with an optional [label].
  CounterService({this.label = 'default'}) {
    _instanceCount++;
    instanceId = _instanceCount;
  }

  /// A human-readable label for this service instance.
  final String label;

  /// The unique instance ID assigned at construction time.
  late final int instanceId;

  /// Tracks how many [CounterService] instances have been created in total.
  static int _instanceCount = 0;

  /// Resets the global instance counter (used when re-registering).
  static void resetCounter() => _instanceCount = 0;

  int _count = 0;

  /// The current counter value.
  int get count => _count;

  /// Increments the counter by 1.
  void increment() => _count++;

  @override
  String toString() => 'CounterService#$instanceId(count=$_count, label=$label)';
}

/// A simple greeter service used to demonstrate transient binding.
///
/// Each [App.make<GreeterService>()] call returns a new instance with
/// a fresh greeting, demonstrating that transient bindings do NOT share state.
class GreeterService {
  /// Creates a [GreeterService].
  GreeterService() {
    _instanceCount++;
    instanceId = _instanceCount;
  }

  /// Tracks how many [GreeterService] instances have been created.
  static int _instanceCount = 0;

  /// Resets the global instance counter.
  static void resetCounter() => _instanceCount = 0;

  /// The unique instance ID assigned at construction time.
  late final int instanceId;

  /// Returns a greeting string.
  String greet(String name) => 'Hello, $name! (from instance #$instanceId)';
}

// ── Page ──────────────────────────────────────────────────────────────────────

/// Container Explorer — demonstrates the pixielity_container IoC container.
///
/// Shows:
///   - How to register singletons and transient bindings
///   - How App.make<T>() resolves registered types
///   - How singleton instances share state across resolutions
///   - How transient instances are always freshly created
///   - The ServiceProvider pattern for grouping registrations
class ContainerExplorerPage extends StatefulWidget {
  /// Creates the [ContainerExplorerPage].
  const ContainerExplorerPage({super.key});

  @override
  State<ContainerExplorerPage> createState() => _ContainerExplorerPageState();
}

class _ContainerExplorerPageState extends State<ContainerExplorerPage> {
  // ── State ──────────────────────────────────────────────────────────────────

  /// Log of all container operations performed during this session.
  final List<_LogEntry> _log = [];

  /// The current singleton CounterService instance (if registered).
  CounterService? _singletonCounter;

  /// Whether the singleton binding is currently registered.
  bool _singletonRegistered = false;

  /// Whether the transient binding is currently registered.
  bool _transientRegistered = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Register demo bindings on page open.
    _registerSingleton();
    _registerTransient();
  }

  @override
  void dispose() {
    // Clean up demo bindings when leaving the page so they don't
    // interfere with the rest of the app's container state.
    if (ioc.Container.bound<CounterService>()) ioc.Container.forget<CounterService>();
    if (ioc.Container.bound<GreeterService>()) ioc.Container.forget<GreeterService>();
    super.dispose();
  }

  // ── Registration helpers ───────────────────────────────────────────────────

  /// Registers [CounterService] as a singleton.
  ///
  /// The same [CounterService] instance is returned on every
  /// [App.make<CounterService>()] call — state is shared.
  void _registerSingleton() {
    CounterService.resetCounter();
    if (ioc.Container.bound<CounterService>()) ioc.Container.forget<CounterService>();
    ioc.App.singleton<CounterService>((_) => CounterService(label: 'singleton'));
    _singletonCounter = null;
    setState(() {
      _singletonRegistered = true;
      _log.add(const _LogEntry(
        type: _LogType.register,
        message: 'App.singleton<CounterService>() registered',
        detail: 'Same instance returned on every make() call.',
      ));
    });
  }

  /// Registers [GreeterService] as a transient binding.
  ///
  /// A new [GreeterService] instance is created on every
  /// [App.make<GreeterService>()] call — no shared state.
  void _registerTransient() {
    GreeterService.resetCounter();
    if (ioc.Container.bound<GreeterService>()) ioc.Container.forget<GreeterService>();
    ioc.App.bind<GreeterService>((_) => GreeterService());
    setState(() {
      _transientRegistered = true;
      _log.add(const _LogEntry(
        type: _LogType.register,
        message: 'App.bind<GreeterService>() registered',
        detail: 'New instance created on every make() call.',
      ));
    });
  }

  // ── Resolution helpers ─────────────────────────────────────────────────────

  /// Resolves the singleton [CounterService] and increments its counter.
  ///
  /// Because it is a singleton, the same instance is returned each time —
  /// the counter value persists across multiple make() calls.
  void _makeSingleton() {
    final service = ioc.App.make<CounterService>();
    service.increment();
    setState(() {
      _singletonCounter = service;
      _log.add(_LogEntry(
        type: _LogType.resolve,
        message: 'App.make<CounterService>() → instance #${service.instanceId}',
        detail: 'count=${service.count} (same instance every time)',
      ));
    });
  }

  /// Resolves a new [GreeterService] transient instance.
  ///
  /// Because it is a transient binding, a brand-new instance is created
  /// on every call — the instance ID increments each time.
  void _makeTransient() {
    final service = ioc.App.make<GreeterService>();
    final greeting = service.greet('World');
    setState(() {
      _log.add(_LogEntry(
        type: _LogType.resolve,
        message: 'App.make<GreeterService>() → instance #${service.instanceId}',
        detail: greeting,
      ));
    });
  }

  /// Checks whether a type is registered using [ioc.Container.bound].
  void _checkBound() {
    final counterBound = ioc.Container.bound<CounterService>();
    final greeterBound = ioc.Container.bound<GreeterService>();
    setState(() {
      _log.add(_LogEntry(
        type: _LogType.inspect,
        message: 'Container.bound<T>() check',
        detail: 'CounterService: $counterBound | GreeterService: $greeterBound',
      ));
    });
  }

  /// Forgets the singleton binding and re-registers it.
  ///
  /// Demonstrates [ioc.Container.forget] — removes the existing singleton
  /// so the next [ioc.App.make] creates a fresh instance.
  void _forgetAndReset() {
    ioc.Container.forget<CounterService>();
    _registerSingleton();
    setState(() {
      _log.add(const _LogEntry(
        type: _LogType.forget,
        message: 'Container.forget<CounterService>() called',
        detail: 'Singleton removed. Re-registered with fresh instance.',
      ));
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ExplorerScaffold(
      title: 'Container',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Overview ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.package,
            title: 'Overview',
            children: [
              const InfoRow(label: 'Package', value: 'pixielity_container'),
              const InfoRow(label: 'Backed by', value: 'get_it'),
              const InfoRow(label: 'Pattern', value: 'Laravel Service Container'),
              InfoRow(
                label: 'CounterService bound',
                value: ioc.Container.bound<CounterService>().toString(),
              ),
              InfoRow(
                label: 'GreeterService bound',
                value: ioc.Container.bound<GreeterService>().toString(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Singleton demo ────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.link,
            title: 'Singleton Binding',
            children: [
              const InfoRow(
                label: 'Registration',
                value: 'App.singleton<CounterService>(...)',
                monospace: true,
              ),
              const InfoRow(
                label: 'Behaviour',
                value: 'Same instance on every make()',
              ),
              if (_singletonCounter != null) ...[
                InfoRow(
                  label: 'Instance ID',
                  value: '#${_singletonCounter!.instanceId}',
                ),
                InfoRow(
                  label: 'Counter value',
                  value: _singletonCounter!.count.toString(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FButton(
                      onPress: _singletonRegistered ? _makeSingleton : null,
                      child: const Text('make() + increment'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FButton(
                      variant: FButtonVariant.outline,
                      onPress: _forgetAndReset,
                      child: const Text('forget() + reset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Transient demo ────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.shuffle,
            title: 'Transient Binding',
            children: [
              const InfoRow(
                label: 'Registration',
                value: 'App.bind<GreeterService>(...)',
                monospace: true,
              ),
              const InfoRow(
                label: 'Behaviour',
                value: 'New instance on every make()',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FButton(
                      onPress: _transientRegistered ? _makeTransient : null,
                      child: const Text('make() — new instance'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FButton(
                      variant: FButtonVariant.outline,
                      onPress: _checkBound,
                      child: const Text('bound() check'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Operation log ─────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.scrollText,
            title: 'Operation Log',
            children: [
              if (_log.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No operations yet. Tap the buttons above.',
                    style: FTheme.of(context).typography.xs.copyWith(
                      color: FTheme.of(context).colors.mutedForeground,
                    ),
                  ),
                )
              else
                ..._log.reversed.map((e) => _LogRow(entry: e)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Log entry model ───────────────────────────────────────────────────────────

/// The type of container operation logged.
enum _LogType { register, resolve, forget, inspect }

/// A single entry in the container operation log.
class _LogEntry {
  const _LogEntry({
    required this.type,
    required this.message,
    required this.detail,
  });

  final _LogType type;
  final String message;
  final String detail;
}

// ── Log row widget ────────────────────────────────────────────────────────────

class _LogRow extends StatelessWidget {
  const _LogRow({required this.entry});

  final _LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    final (color, label) = switch (entry.type) {
      _LogType.register => (const Color(0xFF3B82F6), 'BIND'),
      _LogType.resolve  => (const Color(0xFF22C55E), 'MAKE'),
      _LogType.forget   => (const Color(0xFFEF4444), 'FORGET'),
      _LogType.inspect  => (const Color(0xFFF59E0B), 'CHECK'),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                label,
                style: theme.typography.xs.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Message + detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.message,
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.foreground,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  entry.detail,
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
