/// Post model matching the fake-rest refine API.
class Post {
  /// Creates a [Post].
  const Post({
    required this.id,
    required this.title,
    required this.status,
    this.slug = '',
    this.content = '',
    this.hit = 0,
    this.categoryId,
    this.createdAt,
  });

  /// Deserialise from JSON.
  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        content: json['content'] as String? ?? '',
        hit: json['hit'] as int? ?? 0,
        categoryId: (json['category'] as Map?)?['id'] as int?,
        status: json['status'] as String? ?? 'draft',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  /// Record ID.
  final int id;

  /// Post title.
  final String title;

  /// URL slug.§
  final String slug;

  /// Body content.
  final String content;

  /// View count.
  final int hit;

  /// Category ID.
  final int? categoryId;

  /// Publication status.
  final String status;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Serialise to JSON for create/update.
  Map<String, dynamic> toJson() => {
        'title': title,
        'slug': slug,
        'content': content,
        'status': status,
        if (categoryId != null) 'category': {'id': categoryId},
      };

  @override
  String toString() => title;
}
