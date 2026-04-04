/// Category model matching the fake-rest refine API.
class Category {
  /// Creates a [Category].
  const Category({required this.id, required this.title});

  /// Deserialise from JSON.
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
      );

  /// Record ID.
  final int id;

  /// Category title.
  final String title;

  @override
  String toString() => title;
}
