// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pixielity_refine/pixielity_refine.dart';

/// Demonstrates all [FormBuilder] field types rendered via [FormRenderer].
class FormDemoPage extends StatefulWidget {
  /// Creates a [FormDemoPage].
  const FormDemoPage({super.key});

  @override
  State<FormDemoPage> createState() => _FormDemoPageState();
}

class _FormDemoPageState extends State<FormDemoPage> {
  Map<String, dynamic>? _submitted;

  final _schema = FormBuilder()
      .text('name', label: 'Full Name', placeholder: 'Jane Doe', required: true)
      .email('email', label: 'Email', placeholder: 'jane@example.com')
      .password('password', label: 'Password')
      .textarea('bio', label: 'Bio', placeholder: 'Tell us about yourself...')
      .number('age', label: 'Age')
      .select(
        'role',
        label: 'Role',
        options: [
          FieldOption(value: 'admin', label: 'Admin'),
          FieldOption(value: 'editor', label: 'Editor'),
          FieldOption(value: 'viewer', label: 'Viewer'),
        ],
      )
      .multiSelect(
        'tags',
        label: 'Tags',
        options: [
          FieldOption(value: 'flutter', label: 'Flutter'),
          FieldOption(value: 'dart', label: 'Dart'),
          FieldOption(value: 'forui', label: 'ForeUI'),
          FieldOption(value: 'riverpod', label: 'Riverpod'),
        ],
      )
      .checkbox('agree', label: 'I agree to the terms')
      .date('dob', label: 'Date of Birth')
      .build();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('FormBuilder Demo'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FCard(
              title: const Text('All Field Types'),
              subtitle: const Text('FormBuilder + FormRenderer + ForeUI'),
              child: FormRenderer(
                schema: _schema,
                submitLabel: 'Submit Form',
                onSubmit: (data) => setState(() => _submitted = data),
              ),
            ),
            if (_submitted != null) ...[
              const SizedBox(height: 16),
              FCard(
                title: const Text('Submitted Data'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _submitted!.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${e.key}: ${e.value}',
                        style: context.theme.typography.sm,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
