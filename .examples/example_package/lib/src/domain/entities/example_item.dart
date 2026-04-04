// ignore_for_file: lines_longer_than_80_chars
// (freezed-generated part directives require long URIs)

import 'package:freezed_annotation/freezed_annotation.dart';

// Generated files produced by build_runner.
part 'example_item.freezed.dart';
part 'example_item.g.dart';

/// A single item in the example domain.
///
/// [ExampleItem] is immutable and value-comparable thanks to `freezed`.
/// Use [ExampleItem.fromJson] to deserialize from a JSON map, and
/// [toJson] to serialize back.
///
/// Example:
/// ```dart
/// final item = ExampleItem(id: '1', title: 'Hello', description: 'World');
/// final copy = item.copyWith(title: 'Updated');
/// ```
@freezed
class ExampleItem with _$ExampleItem {
  /// Creates an [ExampleItem].
  ///
  /// All fields are required and non-nullable to enforce data integrity
  /// at the domain boundary.
  const factory ExampleItem({
    /// Unique identifier for this item.
    required String id,

    /// Human-readable title of the item.
    required String title,

    /// Optional longer description providing additional context.
    // ignore: comment_references
    @Default('') String description,
  }) = _ExampleItem;

  /// Deserializes an [ExampleItem] from a JSON [map].
  factory ExampleItem.fromJson(Map<String, dynamic> json) =>
      _$ExampleItemFromJson(json);
}
