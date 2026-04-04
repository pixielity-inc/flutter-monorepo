// ignore_for_file: lines_longer_than_80_chars
// lib/src/widgets/app_search_bar.dart
//
// AppSearchBar — a reusable search input built on top of Forui's FTextField.
//
// Provides consistent padding, icon placement, and clear button.
// All colors come from the active FThemeData so it adapts to any palette.
//
// Usage:
//   AppSearchBar(
//     hint: 'Search keys...',
//     onChanged: (v) => setState(() => _query = v),
//   )

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A themed search bar with a leading search icon and optional clear button.
///
/// Built on [FTextField] so it inherits all Forui theming automatically.
/// The icon is properly padded inside the field — not flush with the border.
///
/// {@tool snippet}
/// ```dart
/// AppSearchBar(
///   hint: 'Search keys...',
///   onChanged: (query) => setState(() => _search = query),
/// )
/// ```
/// {@end-tool}
class AppSearchBar extends StatefulWidget {
  /// Creates an [AppSearchBar].
  const AppSearchBar({
    this.hint = 'Search...',
    this.onChanged,
    this.controller,
    super.key,
  });

  /// Placeholder text shown when the field is empty.
  final String hint;

  /// Called whenever the search text changes.
  final ValueChanged<String>? onChanged;

  /// Optional external controller. If not provided, one is created internally.
  final TextEditingController? controller;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text);
    // Rebuild to show/hide the clear button.
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return FTextField(
      control: FTextFieldControl.managed(controller: _controller),
      hint: widget.hint,
      // ── Leading search icon with proper internal padding ──────────────────
      // We wrap in a SizedBox with symmetric padding so the icon sits
      // comfortably inside the field — not flush with the border.
      prefixBuilder: (_, __, ___) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          LucideIcons.search,
          size: 16,
          color: theme.colors.mutedForeground,
        ),
      ),
      // ── Trailing clear button — only shown when field has text ────────────
      suffixBuilder: _controller.text.isEmpty
          ? null
          : (_, __, ___) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FTappable(
                  onPress: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  child: Icon(
                    LucideIcons.x,
                    size: 14,
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ),
    );
  }
}
