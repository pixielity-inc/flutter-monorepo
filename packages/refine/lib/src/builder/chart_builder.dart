// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/painting.dart';

/// Supported chart types.
enum ChartType {
  /// Line chart — trends over time.
  line,

  /// Bar chart — comparisons across categories.
  bar,

  /// Horizontal bar chart.
  horizontalBar,

  /// Pie chart — proportions of a whole.
  pie,

  /// Donut chart — pie with a hole.
  donut,

  /// Area chart — filled line chart.
  area,
}

/// A single data series in a chart.
class ChartSeries {
  /// Creates a [ChartSeries].
  const ChartSeries({
    required this.key,
    required this.label,
    required this.color,
    this.data = const [],
  });

  /// The data key — maps to a field in each data point map.
  final String key;

  /// Human-readable series label shown in the legend.
  final String label;

  /// Series color.
  final Color color;

  /// Pre-loaded data points. Can also be provided at render time.
  final List<Map<String, dynamic>> data;
}

/// Configuration for a chart axis.
class ChartAxis {
  /// Creates a [ChartAxis].
  const ChartAxis({
    required this.key,
    this.label,
    this.format,
  });

  /// The data key used for this axis.
  final String key;

  /// Optional axis label.
  final String? label;

  /// Optional value format: 'currency', 'percent', 'number', or a custom pattern.
  final String? format;
}

/// The compiled schema produced by [ChartBuilder.build].
class ChartSchema {
  /// Creates a [ChartSchema].
  const ChartSchema({
    required this.type,
    required this.series,
    this.xAxis,
    this.yAxis,
    this.title,
    this.height = 300,
    this.showLegend = true,
    this.showGrid = true,
    this.animated = true,
  });

  /// The chart type.
  final ChartType type;

  /// Data series definitions.
  final List<ChartSeries> series;

  /// X-axis configuration.
  final ChartAxis? xAxis;

  /// Y-axis configuration.
  final ChartAxis? yAxis;

  /// Optional chart title.
  final String? title;

  /// Chart height in logical pixels.
  final double height;

  /// Whether to show the legend.
  final bool showLegend;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Whether to animate on first render.
  final bool animated;
}

/// Fluent DSL for building chart schemas.
///
/// ```dart
/// final schema = ChartBuilder()
///   .type(ChartType.line)
///   .title('Monthly Revenue')
///   .series('revenue', label: 'Revenue', color: Colors.blue)
///   .series('orders', label: 'Orders', color: Colors.green)
///   .xAxis('month', label: 'Month')
///   .yAxis('value', label: 'Amount', format: 'currency')
///   .height(280)
///   .build();
/// ```
class ChartBuilder {
  ChartType _type = ChartType.line;
  final List<ChartSeries> _series = [];
  ChartAxis? _xAxis;
  ChartAxis? _yAxis;
  String? _title;
  double _height = 300;
  bool _showLegend = true;
  bool _showGrid = true;
  bool _animated = true;

  /// Set the chart type.
  ChartBuilder type(ChartType value) {
    _type = value;
    return this;
  }

  /// Set the chart title.
  ChartBuilder title(String value) {
    _title = value;
    return this;
  }

  /// Add a data series.
  ChartBuilder series(
    String key, {
    required String label,
    required Color color,
    List<Map<String, dynamic>> data = const [],
  }) {
    _series.add(ChartSeries(key: key, label: label, color: color, data: data));
    return this;
  }

  /// Configure the X axis.
  ChartBuilder xAxis(String key, {String? label, String? format}) {
    _xAxis = ChartAxis(key: key, label: label, format: format);
    return this;
  }

  /// Configure the Y axis.
  ChartBuilder yAxis(String key, {String? label, String? format}) {
    _yAxis = ChartAxis(key: key, label: label, format: format);
    return this;
  }

  /// Set the chart height.
  ChartBuilder height(double value) {
    _height = value;
    return this;
  }

  /// Show or hide the legend.
  ChartBuilder legend({bool show = true}) {
    _showLegend = show;
    return this;
  }

  /// Show or hide grid lines.
  ChartBuilder grid({bool show = true}) {
    _showGrid = show;
    return this;
  }

  /// Enable or disable entry animation.
  ChartBuilder animated({bool value = true}) {
    _animated = value;
    return this;
  }

  /// Build and return the immutable [ChartSchema].
  ChartSchema build() => ChartSchema(
        type: _type,
        series: List.unmodifiable(_series),
        xAxis: _xAxis,
        yAxis: _yAxis,
        title: _title,
        height: _height,
        showLegend: _showLegend,
        showGrid: _showGrid,
        animated: _animated,
      );
}
