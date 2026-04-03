import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Home page showcasing Forui components.
///
/// Demonstrates [FCard], [FButton], [FBadge], [FAlert], [FSwitch],
/// [FTextField], [FAccordion], [FDeterminateProgress], and [FToast].
class HomePage extends StatefulWidget {
  /// Creates the [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _count = 0;
  bool _darkMode = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              const SizedBox(height: 16),
              Text(
                'Hello, Flutter Monorepo!',
                style: theme.typography.xl3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Powered by Forui · Melos · Riverpod',
                style: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FBadge(child: const Text('Forui')),
                  const SizedBox(width: 8),
                  FBadge(
                    variant: FBadgeVariant.secondary,
                    child: const Text('Flutter 3.41'),
                  ),
                  const SizedBox(width: 8),
                  FBadge(
                    variant: FBadgeVariant.outline,
                    child: const Text('Dart 3.11'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Alert ──
              FAlert(
                icon: Icon(FIcons.circleCheck),
                title: Text('Monorepo Ready'),
                subtitle: Text(
                  'Forui is configured and working. Start building!',
                ),
              ),
              const SizedBox(height: 24),

              // ── Counter Card ──
              FCard(
                title: const Text('Counter'),
                subtitle: const Text('A simple stateful counter demo'),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      '$_count',
                      style: theme.typography.xl3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FButton(
                          variant: FButtonVariant.outline,
                          onPress: () => setState(() => _count--),
                          suffix: const Icon(FIcons.minus),
                          child: const Text('Decrease'),
                        ),
                        const SizedBox(width: 12),
                        FButton(
                          onPress: () => setState(() => _count++),
                          suffix: const Icon(FIcons.plus),
                          child: const Text('Increase'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FButton(
                      variant: FButtonVariant.secondary,
                      onPress: () {
                        setState(() => _count = 0);
                        FToaster.of(context).show(
                          builder: (context, overlay) => const FToast(
                            icon: Icon(FIcons.circleCheck),
                            title: Text('Counter reset!'),
                          ),
                        );
                      },
                      suffix: const Icon(FIcons.rotateCcw),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Settings Card ──
              FCard(
                title: const Text('Settings'),
                subtitle: const Text('Toggle preferences with Forui switches'),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dark Mode', style: theme.typography.sm),
                        FSwitch(
                          value: _darkMode,
                          onChange: (v) => setState(() => _darkMode = v),
                        ),
                      ],
                    ),
                    const FDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Notifications', style: theme.typography.sm),
                        FSwitch(
                          value: _notifications,
                          onChange: (v) => setState(() => _notifications = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Text Field ──
              FCard(
                title: const Text('Input'),
                subtitle: const Text('Forui text field with hint and label'),
                child: const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: FTextField(
                    label: Text('Your name'),
                    hint: 'Enter your name...',
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Progress ──
              FCard(
                title: const Text('Progress'),
                subtitle: const Text('Determinate progress indicator'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: FDeterminateProgress(
                    value: _count.clamp(0, 100) / 100,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Accordion ──
              FAccordion(
                children: [
                  FAccordionItem(
                    title: Text('What is Forui?'),
                    child: Text(
                      'Forui is a beautiful, minimalistic, and '
                      'platform-agnostic UI library for Flutter.',
                    ),
                  ),
                  FAccordionItem(
                    title: Text('What is this monorepo?'),
                    child: Text(
                      'A production-ready Flutter monorepo template '
                      'powered by Melos, with Clean Architecture, '
                      'Riverpod, CI/CD, and git hooks.',
                    ),
                  ),
                  FAccordionItem(
                    title: Text('How do I add a new feature?'),
                    child: Text(
                      'Run ./bin/cli feature <name> to scaffold a '
                      'new feature package.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
