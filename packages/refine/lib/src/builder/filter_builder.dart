// ignore_for_file: lines_longer_than_80_chars

import '../builder/field.dart';
import '../repository/query_params.dart';

/// The type of a filter input.
enum FilterType {
  /// Free-text search — maps to a `whereLike` on the given column.
  search,

  /// Single-value select — maps to `where(column, '=', value)`.
  select,

  /// Multi-value select — maps to `whereIn(column, values)`.
  multiSelect,

  /// Date range — maps to `whereBetween(column, from, to)`.
  dateRange,

  /// Boolean toggle — maps to `where(column, '=', true/false)`.
  toggle,

  /// Numeric range — maps to `whereBetween(column, min, max)`.
  numberRange,
}

/// A single filter input definition.
class FilterField {
  /// Creates a [FilterField].
  const FilterField({
    required this.key,
    required this.type,
    this.label,
    this.placeholder,
    this.options,
    this.optionsLoader,
    this.column,
  });

  /// Unique key for this filter (also used as the query param name).
  final String key;

  /// The filter input type.
  final FilterType type;

  /// Human-readable label.
  final String? label;

  /// Placeholder text for search inputs.
  final String? placeholder;

  /// Static options for select / multiSelect filters.
  final List<FieldOption>? options;

  /// Async options loader for select / multiSelect filters.
  final Future<List<FieldOption>> Function()? optionsLoader;

  /// The model column this filter targets. Defaults to [key] if null.
  final String? column;

  /// The resolved column name.
  String get resolvedColumn => column ?? key;
}

/// The compiled schema produced by [FilterBuilder.build].
class FilterSchema {
  /// Creates a [FilterSchema].
  const FilterSchema({required this.fields});

  /// All filter field definitions.
  final List<FilterField> fields;

  /// Convert a map of current filter values into a [QueryParams].
  ///
  /// Call this whenever filter values change to get the updated query.
  QueryParams<T> toQueryParams<T>(Map<String, dynamic> values) {
    final params = QueryParams<T>();

    for (final field in fields) {
      final value = values[field.key];
      if (value == null) continue;

      final col = field.resolvedColumn;

      switch (field.type) {
        case FilterType.search:
          final str = value.toString().trim();
          if (str.isNotEmpty) params.whereLike(col, '%$str%');

        case FilterType.select:
          params.where(col, '=', value);

        case FilterType.multiSelect:
          if (value is List && value.isNotEmpty) {
            params.whereIn(col, value.cast<dynamic>());
          }

        case FilterType.toggle:
          params.where(col, '=', value);

        case FilterType.dateRange:
          if (value is DateRangeValue) {
            if (value.from != null && value.to != null) {
              params.whereBetween(col, value.from, value.to);
            }
          }

        case FilterType.numberRange:
          if (value is NumberRangeValue) {
            if (value.min != null && value.max != null) {
              params.whereBetween(col, value.min, value.max);
            }
          }
      }
    }

    return params;
  }
}

/// Value holder for a date range filter.
class DateRangeValue {
  /// Creates a [DateRangeValue].
  const DateRangeValue({this.from, this.to});

  /// Start of the date range.
  final DateTime? from;

  /// End of the date range.
  final DateTime? to;
}

/// Value holder for a numeric range filter.
class NumberRangeValue {
  /// Creates a [NumberRangeValue].
  const NumberRangeValue({this.min, this.max});

  /// Minimum value.
  final num? min;

  /// Maximum value.
  final num? max;
}

/// Fluent DSL for building filter bar schemas.
///
/// The output [FilterSchema] converts live filter values into a
/// [QueryParams] that feeds directly into your service/repository.
///
/// ```dart
/// final schema = FilterBuilder()
///   .search('q', placeholder: 'Search posts...')
///   .select('status', options: [
///     FieldOption(value: 'draft', label: 'Draft'),
///     FieldOption(value: 'published', label: 'Published'),
///   ])
///   .dateRange('created_at', label: 'Date Range')
///   .build();
///
/// // Convert current values to QueryParams:
/// final params = schema.toQueryParams<Post>({'q': 'hello', 'status': 'draft'});
/// ```
class FilterBuilder {
  final List<FilterField> _fields = [];

  /// Add a free-text search filter.
  FilterBuilder search(
    String key, {
    String? label,
    String? placeholder,
    String? column,
  }) {
    _fields.add(FilterField(
      key: key,
      type: FilterType.search,
      label: label,
      placeholder: placeholder,
      column: column,
    ));
    return this;
  }

  /// Add a single-value select filter.
  FilterBuilder select(
    String key, {
    String? label,
    List<FieldOption> options = const [],
    Future<List<FieldOption>> Function()? optionsLoader,
    String? column,
  }) {
    _fields.add(FilterField(
      key: key,
      type: FilterType.select,
      label: label,
      options: options,
      optionsLoader: optionsLoader,
      column: column,
    ));
    return this;
  }

  /// Add a multi-value select filter.
  FilterBuilder multiSelect(
    String key, {
    String? label,
    List<FieldOption> options = const [],
    Future<List<FieldOption>> Function()? optionsLoader,
    String? column,
  }) {
    _fields.add(FilterField(
      key: key,
      type: FilterType.multiSelect,
      label: label,
      options: options,
      optionsLoader: optionsLoader,
      column: column,
    ));
    return this;
  }

  /// Add a date range filter.
  FilterBuilder dateRange(
    String key, {
    String? label,
    String? column,
  }) {
    _fields.add(FilterField(
      key: key,
      type: FilterType.dateRange,
      label: label,
      column: column,
    ));
    return this;
  }

  /// Add a boolean toggle filter.
  FilterBuilder toggle(
    String key, {
    String? label,
    String? column,
  }) {
    _fields.add(FilterField(
      key: key,
      type: FilterType.toggle,
      label: label,
      column: column,
    ));
    return this;
  }

  /// Add a numeric range filter.
  FilterBuilder numberRange(
    String key, {
    String? label,
    String? column,
  }) {
    _fields.add(FilterField(
      key: key,
      type: FilterType.numberRange,
      label: label,
      column: column,
    ));
    return this;
  }

  /// Build and return the immutable [FilterSchema].
  FilterSchema build() => FilterSchema(fields: List.unmodifiable(_fields));
}
