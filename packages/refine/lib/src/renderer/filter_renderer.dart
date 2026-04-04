// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../builder/field.dart';
import '../builder/filter_builder.dart';
import '../repository/query_params.dart';

/// Renders a [FilterSchema] as a row of ForeUI filter inputs.
///
/// Manages filter state internally and calls [onChanged] with the
/// updated [QueryParams] whenever any filter value changes.
///
/// ```dart
/// FilterRenderer<Post>(
///   schema: filterSchema,
///   onChanged: (params) => ref.invalidate(postsProvider),
/// )
/// ```
class FilterRenderer<T> extends StatefulWidget {
  /// Creates a [FilterRenderer].
  const FilterRenderer({
    super.key,
    required this.schema,
    required this.onChanged,
    this.initialValues = const {},
  });

  /// The filter schema.
  final FilterSchema schema;

  /// Called whenever any filter value changes.
  final void Function(QueryParams<T> params) onChanged;

  /// Optional initial filter values.
  final Map<String, dynamic> initialValues;

  @override
  State<FilterRenderer<T>> createState() => _FilterRendererState<T>();
}

class _FilterRendererState<T> extends State<FilterRenderer<T>> {
  late Map<String, dynamic> _values;

  @override
  void initState() {
    super.initState();
    _values = Map.of(widget.initialValues);
  }

  void _update(String key, dynamic value) {
    setState(() {
      if (value == null ||
          (value is String && value.isEmpty) ||
          (value is List && value.isEmpty)) {
        _values.remove(key);
      } else {
        _values[key] = value;
      }
    });
    widget.onChanged(widget.schema.toQueryParams<T>(_values));
  }

  void _clear() {
    setState(() => _values.clear());
    widget.onChanged(QueryParams<T>());
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...widget.schema.fields.map((field) => _buildField(field)),
        if (_values.isNotEmpty)
          FButton(
            variant: .ghost,
            size: .sm,
            mainAxisSize: .min,
            prefix: const Icon(FIcons.x, size: 14),
            onPress: _clear,
            child: const Text('Clear'),
          ),
      ],
    );
  }

  Widget _buildField(FilterField field) {
    return switch (field.type) {
      FilterType.search => _SearchInput(
          field: field,
          value: _values[field.key]?.toString() ?? '',
          onChanged: (v) => _update(field.key, v),
        ),
      FilterType.select => _SelectInput(
          field: field,
          value: _values[field.key],
          onChanged: (v) => _update(field.key, v),
        ),
      FilterType.multiSelect => _MultiSelectInput(
          field: field,
          value: (_values[field.key] as List?)?.cast<dynamic>() ?? [],
          onChanged: (v) => _update(field.key, v),
        ),
      FilterType.toggle => _ToggleInput(
          field: field,
          value: _values[field.key] as bool? ?? false,
          onChanged: (v) => _update(field.key, v),
        ),
      FilterType.dateRange => _DateRangeInput(
          field: field,
          value: _values[field.key] as DateRangeValue?,
          onChanged: (v) => _update(field.key, v),
        ),
      FilterType.numberRange => _NumberRangeInput(
          field: field,
          value: _values[field.key] as NumberRangeValue?,
          onChanged: (v) => _update(field.key, v),
        ),
    };
  }
}

// ── Internal input widgets ─────────────────────────────────────────────────────

class _SearchInput extends StatefulWidget {
  const _SearchInput({
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final FilterField field;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: FTextField(
        control: FTextFieldControl.managed(
          initial: TextEditingValue(text: widget.value),
        ),
        label: widget.field.label != null ? Text(widget.field.label!) : null,
        hint: widget.field.placeholder ?? 'Search...',
        prefixBuilder: (_, __, ___) =>
            const Icon(FIcons.search, size: 16),
        onSubmit: widget.onChanged,
      ),
    );
  }
}

class _SelectInput extends StatelessWidget {
  const _SelectInput({
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final FilterField field;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = field.options ?? [];
    return SizedBox(
      width: 180,
      child: FSelect<String>.rich(
        control: FSelectControl.managed(initial: value?.toString()),
        label: field.label != null ? Text(field.label!) : null,
        hint: 'All',
        format: (v) => v.isEmpty
            ? 'All'
            : options
                .firstWhere(
                  (o) => o.value.toString() == v,
                  orElse: () => FieldOption(value: v, label: v),
                )
                .label,
        onSaved: (v) => onChanged(
          v == null || v.isEmpty
              ? null
              : options.firstWhere(
                  (o) => o.value.toString() == v,
                  orElse: () => FieldOption(value: v, label: v),
                ).value,
        ),
        children: [
          FSelectItem.item(title: const Text('All'), value: ''),
          ...options.map(
            (o) => FSelectItem.item(
              title: Text(o.label),
              value: o.value.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MultiSelectInput extends StatelessWidget {
  const _MultiSelectInput({
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final FilterField field;
  final List<dynamic> value;
  final ValueChanged<List<dynamic>> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = field.options ?? [];
    return SizedBox(
      width: 200,
      child: FMultiSelect<String>.rich(
        label: field.label != null ? Text(field.label!) : null,
        hint: Text(value.isEmpty ? 'All' : '${value.length} selected'),
        format: (v) => Text(options
            .firstWhere(
              (o) => o.value.toString() == v,
              orElse: () => FieldOption(value: v, label: v),
            )
            .label),
        onSaved: (v) => onChanged(
          v.map((s) => options.firstWhere(
            (o) => o.value.toString() == s,
            orElse: () => FieldOption(value: s, label: s),
          ).value).toList(),
        ),
        children: options.map(
          (o) => FSelectItem.item(
            title: Text(o.label),
            value: o.value.toString(),
          ),
        ).toList(),
      ),
    );
  }
}

class _ToggleInput extends StatelessWidget {
  const _ToggleInput({
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final FilterField field;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FSwitch(
      label: field.label != null ? Text(field.label!) : null,
      value: value,
      onChange: onChanged,
    );
  }
}

class _DateRangeInput extends StatelessWidget {
  const _DateRangeInput({
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final FilterField field;
  final DateRangeValue? value;
  final ValueChanged<DateRangeValue?> onChanged;

  @override
  Widget build(BuildContext context) {
    final label = value == null
        ? (field.label ?? 'Date Range')
        : '${_fmt(value!.from)} – ${_fmt(value!.to)}';

    return FButton(
      variant: .outline,
      size: .sm,
      mainAxisSize: .min,
      prefix: const Icon(FIcons.calendarDays, size: 14),
      onPress: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDateRange: value?.from != null && value?.to != null
              ? DateTimeRange(start: value!.from!, end: value!.to!)
              : null,
        );
        if (range != null) {
          onChanged(DateRangeValue(from: range.start, to: range.end));
        }
      },
      child: Text(label),
    );
  }

  String _fmt(DateTime? d) => d == null
      ? ''
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _NumberRangeInput extends StatefulWidget {
  const _NumberRangeInput({
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final FilterField field;
  final NumberRangeValue? value;
  final ValueChanged<NumberRangeValue?> onChanged;

  @override
  State<_NumberRangeInput> createState() => _NumberRangeInputState();
}

class _NumberRangeInputState extends State<_NumberRangeInput> {
  late final TextEditingController _minCtrl;
  late final TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _minCtrl = TextEditingController(
      text: widget.value?.min?.toString() ?? '',
    );
    _maxCtrl = TextEditingController(
      text: widget.value?.max?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    final min = num.tryParse(_minCtrl.text);
    final max = num.tryParse(_maxCtrl.text);
    widget.onChanged(
      min != null || max != null ? NumberRangeValue(min: min, max: max) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 90,
          child: FTextField(
            control: FTextFieldControl.managed(
              initial: TextEditingValue(text: _minCtrl.text),
            ),
            label: Text(widget.field.label != null
                ? '${widget.field.label} Min'
                : 'Min'),
            keyboardType: TextInputType.number,
            onSubmit: (_) => _emit(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('–'),
        ),
        SizedBox(
          width: 90,
          child: FTextField(
            control: FTextFieldControl.managed(
              initial: TextEditingValue(text: _maxCtrl.text),
            ),
            label: const Text('Max'),
            keyboardType: TextInputType.number,
            onSubmit: (_) => _emit(),
          ),
        ),
      ],
    );
  }
}
