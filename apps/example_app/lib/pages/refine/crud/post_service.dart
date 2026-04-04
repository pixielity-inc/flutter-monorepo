import 'package:pixielity_refine/pixielity_refine.dart';
import 'post_model.dart';

/// Business logic layer for [Post].
///
/// Extends [BaseService] — override any method to add validation,
/// transformation, or cross-repo logic.
class PostService extends BaseService<Post, int> {
  /// Creates a [PostService].
  PostService(super.repo);
}
