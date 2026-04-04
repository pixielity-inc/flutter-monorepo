// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../builder/field.dart';
import 'field_renderer.dart';

/// Renders a complete form from a list of [Field] definitions using ForeUI.
///
/// ```dart
/// FormRenderer(
///   schema: FormBuilder()
///     .text('title', label: 'Title', required: true)
///     .number('price', label: 'Price')
///     .build(),
///   initialValues: {'title': post.title},
///   onSubmit: (data) => createPost.mutate(data),
/// )
/// ```
class FormRenderer extends StatefulWidget {
  /// Creates a [FormRenderer].
  const FormRenderer({
    super.key,
    required this.schema,
    required this.onSubmit,
    this.initialValues = const {},
    this.submitLabel = 'Submit',
    this.isLoading = false,
  });

  /// The list of field definitions.
  final List<Field> schema;

  /// Called with the form data on submit.
  final void Function(Map<String, dynamic> data) onSubmit;

  /// Optional initial values keyed by field name.
  final Map<String, dynamic> initialValues;

  /// Label for the submit button.
  final String submitLabel;

  /// Whether to show a loading state on the submit button.
  final bool isLoading;

  @override
  State<FormRenderer> createState() => _FormRendererState();
}

class _FormRendererState extends State<FormRenderer> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _values;
  final Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    _values = {
      for (final f in widget.schema)
        f.name: widget.initialValues[f.name] ?? f.defaultValue,
    };
  }

  void _handleSubmit() {
    var valid = true;
    final errors = <String, String?>{};

    for (final field in widget.schema) {
      final error = field.validate(_values[field.name]);
      if (error != null) {
        errors[field.name] = error;
        valid = false;
      }
    }

    setState(() => _errors.addAll(errors));

    if (valid && (_formKey.currentState?.validate() ?? true)) {
      widget.onSubmit(Map.unmodifiable(_values));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...widget.schema.map(
            (field) => FieldRenderer(
              field: field,
              value: _values[field.name],
              errorText: _errors[field.name],
              onChanged: (v) => setState(() {
                _values[field.name] = v;
                _errors.remove(field.name);
              }),
            ),
          ),
          const SizedBox(height: 8),
          FButton(
            onPress: widget.isLoading ? null : _handleSubmit,
            child: widget.isLoading
                ? const FCircularProgress()
                : Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
