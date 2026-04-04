// ignore_for_file: lines_longer_than_80_chars

import 'field.dart';

export 'field.dart';

/// Fluent DSL for building form schemas.
///
/// ```dart
/// final schema = FormBuilder()
///   .text('title', label: 'Title', required: true)
///   .number('price', label: 'Price')
///   .email('email', label: 'Email')
///   .select('status', options: [
///     FieldOption(value: 'draft', label: 'Draft'),
///     FieldOption(value: 'published', label: 'Published'),
///   ])
///   .date('published_at', label: 'Publish Date')
///   .build();
/// ```
class FormBuilder {
  final List<Field> _fields = [];

  // ── Text inputs ────────────────────────────────────────────────────────────

  FormBuilder text(
    String name, {
    String? label,
    String? hint,
    String? placeholder,
    dynamic defaultValue,
    bool required = false,
    bool readOnly = false,
    List<String? Function(dynamic)> validators = const [],
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.text, label: label, hint: hint,
      placeholder: placeholder, defaultValue: defaultValue,
      required: required, readOnly: readOnly, validators: validators, extra: extra,
    ));
    return this;
  }

  FormBuilder email(
    String name, {
    String? label,
    String? hint,
    String? placeholder,
    bool required = false,
    bool readOnly = false,
    List<String? Function(dynamic)> validators = const [],
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.email, label: label, hint: hint,
      placeholder: placeholder, required: required, readOnly: readOnly,
      validators: validators, extra: extra,
    ));
    return this;
  }

  FormBuilder password(
    String name, {
    String? label,
    String? hint,
    bool required = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.password, label: label, hint: hint,
      required: required, extra: extra,
    ));
    return this;
  }

  FormBuilder textarea(
    String name, {
    String? label,
    String? hint,
    String? placeholder,
    dynamic defaultValue,
    bool required = false,
    bool readOnly = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.textarea, label: label, hint: hint,
      placeholder: placeholder, defaultValue: defaultValue,
      required: required, readOnly: readOnly, extra: extra,
    ));
    return this;
  }

  // ── Numeric ────────────────────────────────────────────────────────────────

  FormBuilder number(
    String name, {
    String? label,
    String? hint,
    dynamic defaultValue,
    bool required = false,
    bool readOnly = false,
    List<String? Function(dynamic)> validators = const [],
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.number, label: label, hint: hint,
      defaultValue: defaultValue, required: required, readOnly: readOnly,
      validators: validators, extra: extra,
    ));
    return this;
  }

  // ── Select / Radio / Checkbox ──────────────────────────────────────────────

  FormBuilder select(
    String name, {
    String? label,
    String? hint,
    List<FieldOption> options = const [],
    Future<List<FieldOption>> Function()? optionsLoader,
    dynamic defaultValue,
    bool required = false,
    bool readOnly = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.select, label: label, hint: hint,
      options: options, optionsLoader: optionsLoader,
      defaultValue: defaultValue, required: required, readOnly: readOnly,
      extra: extra,
    ));
    return this;
  }

  FormBuilder multiSelect(
    String name, {
    String? label,
    String? hint,
    List<FieldOption> options = const [],
    Future<List<FieldOption>> Function()? optionsLoader,
    bool required = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.multiSelect, label: label, hint: hint,
      options: options, optionsLoader: optionsLoader,
      required: required, extra: extra,
    ));
    return this;
  }

  FormBuilder radio(
    String name, {
    String? label,
    List<FieldOption> options = const [],
    dynamic defaultValue,
    bool required = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.radio, label: label,
      options: options, defaultValue: defaultValue,
      required: required, extra: extra,
    ));
    return this;
  }

  FormBuilder checkbox(
    String name, {
    String? label,
    String? hint,
    bool defaultValue = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.checkbox, label: label, hint: hint,
      defaultValue: defaultValue, extra: extra,
    ));
    return this;
  }

  // ── Date / Time ────────────────────────────────────────────────────────────

  FormBuilder date(
    String name, {
    String? label,
    String? hint,
    DateTime? defaultValue,
    bool required = false,
    bool readOnly = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.date, label: label, hint: hint,
      defaultValue: defaultValue, required: required, readOnly: readOnly,
      extra: extra,
    ));
    return this;
  }

  FormBuilder dateTime(
    String name, {
    String? label,
    String? hint,
    DateTime? defaultValue,
    bool required = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.dateTime, label: label, hint: hint,
      defaultValue: defaultValue, required: required, extra: extra,
    ));
    return this;
  }

  FormBuilder time(
    String name, {
    String? label,
    String? hint,
    bool required = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.time, label: label, hint: hint,
      required: required, extra: extra,
    ));
    return this;
  }

  // ── File ───────────────────────────────────────────────────────────────────

  FormBuilder file(
    String name, {
    String? label,
    String? hint,
    bool required = false,
    Map<String, dynamic> extra = const {},
  }) {
    _fields.add(Field(
      name: name, type: FieldType.file, label: label, hint: hint,
      required: required, extra: extra,
    ));
    return this;
  }

  // ── Hidden ─────────────────────────────────────────────────────────────────

  FormBuilder hidden(String name, {dynamic defaultValue}) {
    _fields.add(Field(
      name: name, type: FieldType.hidden,
      defaultValue: defaultValue, hidden: true,
    ));
    return this;
  }

  // ── Custom ─────────────────────────────────────────────────────────────────

  /// Add a fully custom [field] definition.
  FormBuilder add(Field field) {
    _fields.add(field);
    return this;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  /// Return the immutable list of [Field] definitions.
  List<Field> build() => List.unmodifiable(_fields);

  /// Return the initial values map from all field [defaultValue]s.
  Map<String, dynamic> initialValues() {
    return {
      for (final f in _fields)
        if (f.defaultValue != null) f.name: f.defaultValue,
    };
  }
}
