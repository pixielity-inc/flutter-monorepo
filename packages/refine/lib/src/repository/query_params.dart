// ignore_for_file: lines_longer_than_80_chars

/// Represents a single WHERE clause condition.
class WhereClause {
  const WhereClause({
    required this.column,
    required this.operator,
    required this.value,
    this.boolean = 'and',
  });

  final String column;
  final String operator;
  final dynamic value;
  final String boolean; // 'and' | 'or'
}

/// Represents an ORDER BY clause.
class OrderClause {
  const OrderClause({required this.column, this.direction = 'asc'});

  final String column;
  final String direction; // 'asc' | 'desc'
}

/// Represents a pagination result wrapping a list of [T].
class PaginatedResult<T> {
  const PaginatedResult({
    required this.data,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  final List<T> data;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  bool get hasMorePages => currentPage < lastPage;
}

/// Fluent query parameter builder — mirrors Laravel's Query Builder DSL.
///
/// Used by [BaseRepository] methods to accumulate constraints before
/// executing a query.
///
/// ```dart
/// final params = QueryParams<Post>()
///   .where('status', '=', 'active')
///   .orWhere('featured', '=', true)
///   .orderBy('created_at', direction: 'desc')
///   .limit(10);
/// ```
class QueryParams<T> {
  final List<WhereClause> wheres = [];
  final List<OrderClause> orders = [];
  final List<String> columns = ['*'];
  int? _limit;
  int? _offset;
  Map<String, dynamic>? _extra;

  // ── Selects ────────────────────────────────────────────────────────────────

  /// Select specific [cols] — mirrors `select()`.
  QueryParams<T> select(List<String> cols) {
    columns
      ..clear()
      ..addAll(cols);
    return this;
  }

  // ── Where ──────────────────────────────────────────────────────────────────

  /// Add an AND WHERE clause — mirrors `where()`.
  QueryParams<T> where(String column, String operator, dynamic value) {
    wheres.add(WhereClause(column: column, operator: operator, value: value));
    return this;
  }

  /// Add an OR WHERE clause — mirrors `orWhere()`.
  QueryParams<T> orWhere(String column, String operator, dynamic value) {
    wheres.add(WhereClause(column: column, operator: operator, value: value, boolean: 'or'));
    return this;
  }

  /// Add a WHERE NOT clause — mirrors `whereNot()`.
  QueryParams<T> whereNot(String column, dynamic value) {
    wheres.add(WhereClause(column: column, operator: '!=', value: value));
    return this;
  }

  /// Add a WHERE IN clause — mirrors `whereIn()`.
  QueryParams<T> whereIn(String column, List<dynamic> values) {
    wheres.add(WhereClause(column: column, operator: 'in', value: values));
    return this;
  }

  /// Add a WHERE NOT IN clause — mirrors `whereNotIn()`.
  QueryParams<T> whereNotIn(String column, List<dynamic> values) {
    wheres.add(WhereClause(column: column, operator: 'not_in', value: values));
    return this;
  }

  /// Add a WHERE NULL clause — mirrors `whereNull()`.
  QueryParams<T> whereNull(String column) {
    wheres.add(WhereClause(column: column, operator: 'is_null', value: null));
    return this;
  }

  /// Add a WHERE NOT NULL clause — mirrors `whereNotNull()`.
  QueryParams<T> whereNotNull(String column) {
    wheres.add(WhereClause(column: column, operator: 'is_not_null', value: null));
    return this;
  }

  /// Add a WHERE BETWEEN clause — mirrors `whereBetween()`.
  QueryParams<T> whereBetween(String column, dynamic from, dynamic to) {
    wheres.add(WhereClause(column: column, operator: 'between', value: [from, to]));
    return this;
  }

  /// Add a WHERE NOT BETWEEN clause — mirrors `whereNotBetween()`.
  QueryParams<T> whereNotBetween(String column, dynamic from, dynamic to) {
    wheres.add(WhereClause(column: column, operator: 'not_between', value: [from, to]));
    return this;
  }

  /// Add a WHERE LIKE clause — mirrors `whereLike()`.
  QueryParams<T> whereLike(String column, String value) {
    wheres.add(WhereClause(column: column, operator: 'like', value: value));
    return this;
  }

  // ── Ordering ───────────────────────────────────────────────────────────────

  /// Add an ORDER BY clause — mirrors `orderBy()`.
  QueryParams<T> orderBy(String column, {String direction = 'asc'}) {
    orders.add(OrderClause(column: column, direction: direction));
    return this;
  }

  /// Add an ORDER BY DESC clause — mirrors `orderByDesc()`.
  QueryParams<T> orderByDesc(String column) => orderBy(column, direction: 'desc');

  /// Order by `created_at` descending — mirrors `latest()`.
  QueryParams<T> latest([String column = 'created_at']) => orderByDesc(column);

  /// Order by `created_at` ascending — mirrors `oldest()`.
  QueryParams<T> oldest([String column = 'created_at']) => orderBy(column);

  // ── Pagination ─────────────────────────────────────────────────────────────

  /// Set the max number of results — mirrors `limit()` / `take()`.
  QueryParams<T> limit(int value) {
    _limit = value;
    return this;
  }

  /// Alias for [limit] — mirrors `take()`.
  QueryParams<T> take(int value) => limit(value);

  /// Set the number of results to skip — mirrors `offset()` / `skip()`.
  QueryParams<T> offset(int value) {
    _offset = value;
    return this;
  }

  /// Alias for [offset] — mirrors `skip()`.
  QueryParams<T> skip(int value) => offset(value);

  /// Set offset for a given page — mirrors `forPage()`.
  QueryParams<T> forPage(int page, {int perPage = 15}) {
    _limit = perPage;
    _offset = (page - 1) * perPage;
    return this;
  }

  // ── Extra ──────────────────────────────────────────────────────────────────

  /// Attach arbitrary extra params (e.g. API-specific filters).
  QueryParams<T> with_(Map<String, dynamic> extra) {
    _extra = extra;
    return this;
  }

  // ── Serialise ──────────────────────────────────────────────────────────────

  /// Serialise to a flat [Map] suitable for passing as HTTP query params.
  Map<String, dynamic> toMap() {
    return {
      if (columns.isNotEmpty && columns != ['*']) 'columns': columns,
      if (wheres.isNotEmpty) 'filters': wheres.map((w) => {
        'column': w.column,
        'operator': w.operator,
        'value': w.value,
        'boolean': w.boolean,
      }).toList(),
      if (orders.isNotEmpty) 'sort': orders.map((o) => {
        'column': o.column,
        'direction': o.direction,
      }).toList(),
      if (_limit != null) 'limit': _limit,
      if (_offset != null) 'offset': _offset,
      if (_extra != null) ..._extra!,
    };
  }

  int? get limitValue => _limit;
  int? get offsetValue => _offset;
}
