// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../builder/field.dart';

/// Renders a single [Field] using ForeUI widgets.
class FieldRenderer extends StatelessWidget {
  /// Creates a [FieldRenderer].
  const FieldRenderer({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  /// The field definition.
  final Field field;

  /// Current value.
  final dynamic value;

  /// Called when the value changes.
  final ValueChanged<dynamic> onChanged;

  /// Optional validation error text.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    if (field.hidden) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: switch (field.type) {
        FieldType.text => _textField(context),
        FieldType.email => _emailField(context),
        FieldType.password => _passwordField(context),
        FieldType.textarea => _textareaField(context),
        FieldType.number => _numberField(context),
        FieldType.select => _selectField(context),
        FieldType.multiSelect => _multiSelectField(context),
        FieldType.checkbox => _checkboxField(context),
        FieldType.radio => _radioField(context),
        FieldType.date || FieldType.dateTime => _dateField(context),
        FieldType.time => _timeField(context),
        _ => _textField(context),
      },
    );
  }

  Widget _textField(BuildContext context) => FTextFormField(
        control: FTextFieldControl.managed(
          initial: TextEditingValue(text: value?.toString() ?? ''),
        ),
        label: Text(field.label ?? field.name),
        hint: field.placeholder,
        description: field.hint != null ? Text(field.hint!) : null,
        readOnly: field.readOnly,
        forceErrorText: errorText,
        onSaved: (_) {},
        validator: (v) => field.validate(v),
        onSubmit: (v) => onChanged(v),
      );

  Widget _emailField(BuildContext context) => FTextFormField.email(
        control: FTextFieldControl.managed(
          initial: TextEditingValue(text: value?.toString() ?? ''),
        ),
        hint: field.placeholder,
        description: field.hint != null ? Text(field.hint!) : null,
        readOnly: field.readOnly,
        forceErrorText: errorText,
        onSaved: (_) {},
        validator: (v) => field.validate(v),
        onSubmit: (v) => onChanged(v),
      );

  Widget _passwordField(BuildContext context) => FTextFormField.password(
        control: FTextFieldControl.managed(
          initial: TextEditingValue(text: value?.toString() ?? ''),
        ),
        hint: field.placeholder,
        description: field.hint != null ? Text(field.hint!) : null,
        forceErrorText: errorText,
        onSaved: (_) {},
        validator: (v) => field.validate(v),
        onSubmit: (v) => onChanged(v),
      );

  Widget _textareaField(BuildContext context) => FTextFormField.multiline(
        control: FTextFieldControl.managed(
          initial: TextEditingValue(text: value?.toString() ?? ''),
        ),
        label: Text(field.label ?? field.name),
        hint: field.placeholder,
        description: field.hint != null ? Text(field.hint!) : null,
        readOnly: field.readOnly,
        forceErrorText: errorText,
        onSaved: (_) {},
        validator: (v) => field.validate(v),
        onSubmit: (v) => onChanged(v),
      );

  Widget _numberField(BuildContext context) => FTextFormField(
        control: FTextFieldControl.managed(
          initial: TextEditingValue(text: value?.toString() ?? ''),
        ),
        label: Text(field.label ?? field.name),
        hint: field.placeholder,
        description: field.hint != null ? Text(field.hint!) : null,
        readOnly: field.readOnly,
        keyboardType: TextInputType.number,
        forceErrorText: errorText,
        onSaved: (_) {},
        validator: (v) => field.validate(v),
        onSubmit: (v) => onChanged(num.tryParse(v) ?? v),
      );

  Widget _selectField(BuildContext context) {
    final options = field.options ?? [];
    return FSelect<String>.rich(
      control: FSelectControl.managed(initial: value?.toString()),
      label: Text(field.label ?? field.name),
      description: field.hint != null ? Text(field.hint!) : null,
      hint: field.placeholder ?? 'Select...',
      format: (v) => options.firstWhere(
        (o) => o.value.toString() == v,
        orElse: () => FieldOption(value: v, label: v),
      ).label,
      forceErrorText: errorText,
      onSaved: (v) => onChanged(
        v == null
            ? null
            : options.firstWhere(
                (o) => o.value.toString() == v,
                orElse: () => FieldOption(value: v, label: v),
              ).value,
      ),
      children: options
          .map((o) => FSelectItem.item(
                title: Text(o.label),
                value: o.value.toString(),
              ))
          .toList(),
    );
  }

  Widget _multiSelectField(BuildContext context) {
    final options = field.options ?? [];
    return FMultiSelect<String>.rich(
      label: Text(field.label ?? field.name),
      description: field.hint != null ? Text(field.hint!) : null,
      hint: Text(field.placeholder ?? 'Select...'),
      format: (v) => Text(options.firstWhere(
        (o) => o.value.toString() == v,
        orElse: () => FieldOption(value: v, label: v),
      ).label),
      forceErrorText: errorText,
      onSaved: (v) => onChanged(
        v.map((s) => options.firstWhere(
          (o) => o.value.toString() == s,
          orElse: () => FieldOption(value: s, label: s),
        ).value).toList(),
      ),
      children: options
          .map((o) => FSelectItem.item(
                title: Text(o.label),
                value: o.value.toString(),
              ))
          .toList(),
    );
  }

  Widget _checkboxField(BuildContext context) => FCheckbox(
        label: Text(field.label ?? field.name),
        description: field.hint != null ? Text(field.hint!) : null,
        error: errorText != null ? Text(errorText!) : null,
        value: value as bool? ?? false,
        onChange: (v) => onChanged(v),
      );

  Widget _radioField(BuildContext context) {
    final options = field.options ?? [];
    return FSelectGroup<dynamic>(
      label: Text(field.label ?? field.name),
      description: field.hint != null ? Text(field.hint!) : null,
      children: options
          .map((o) => FSelectGroupItemMixin.radio(
                value: o.value,
                label: Text(o.label),
              ))
          .toList(),
      onSaved: (v) => onChanged(v?.firstOrNull),
    );
  }

  Widget _dateField(BuildContext context) => FDateField.calendar(
        label: Text(field.label ?? field.name),
        description: field.hint != null ? Text(field.hint!) : null,
        forceErrorText: errorText,
        onSaved: (v) => onChanged(v),
      );

  Widget _timeField(BuildContext context) => FTimeField.picker(
        label: Text(field.label ?? field.name),
        description: field.hint != null ? Text(field.hint!) : null,
        forceErrorText: errorText,
        onSaved: (v) => onChanged(v),
      );
}
