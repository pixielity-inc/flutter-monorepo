/// Supported field types in the form builder DSL.
enum FieldType {
  text,
  number,
  email,
  password,
  textarea,
  select,
  multiSelect,
  checkbox,
  radio,
  date,
  dateTime,
  time,
  file,
  hidden,
  custom,
}

/// A single form field definition produced by [FormBuilder].
class Field {
  const Field({
    required this.name,
    required this.type,
    this.label,
    this.hint,
    this.placeholder,
    this.defaultValue,
    this.options,
    this.optionsLoader,
    this.required = false,
    this.readOnly = false,
    this.hidden = false,
    this.validators = const [],
    this.extra = const {},
  });

  /// The field key — maps to the model attribute name.
  final String name;

  /// The field type.
  final FieldType type;

  /// Human-readable label shown above the input.
  final String? label;

  /// Helper text shown below the input.
  final String? hint;

  /// Placeholder text inside the input.
  final String? placeholder;

  /// Default value pre-filled when the form opens.
  final dynamic defaultValue;

  /// Static list of options for [FieldType.select] / [FieldType.multiSelect]
  /// / [FieldType.radio].
  final List<FieldOption>? options;

  /// Async loader for dynamic options (e.g. from an API).
  final Future<List<FieldOption>> Function()? optionsLoader;

  /// Whether the field is required.
  final bool required;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether the field is hidden (still submitted but not rendered).
  final bool hidden;

  /// List of validator functions — each returns an error string or null.
  final List<String? Function(dynamic value)> validators;

  /// Arbitrary extra props passed through to the UI adapter.
  final Map<String, dynamic> extra;

  /// Validate [value] against all [validators].
  /// Returns the first error message, or null if valid.
  String? validate(dynamic value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  Field copyWith({
    String? label,
    String? hint,
    String? placeholder,
    dynamic defaultValue,
    List<FieldOption>? options,
    bool? required,
    bool? readOnly,
    bool? hidden,
    List<String? Function(dynamic)>? validators,
    Map<String, dynamic>? extra,
  }) {
    return Field(
      name: name,
      type: type,
      label: label ?? this.label,
      hint: hint ?? this.hint,
      placeholder: placeholder ?? this.placeholder,
      defaultValue: defaultValue ?? this.defaultValue,
      options: options ?? this.options,
      optionsLoader: optionsLoader,
      required: required ?? this.required,
      readOnly: readOnly ?? this.readOnly,
      hidden: hidden ?? this.hidden,
      validators: validators ?? this.validators,
      extra: extra ?? this.extra,
    );
  }
}

/// A single option in a select / radio / multi-select field.
class FieldOption {
  const FieldOption({required this.value, required this.label});

  final dynamic value;
  final String label;
}
