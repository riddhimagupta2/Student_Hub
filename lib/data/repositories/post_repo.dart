import '../models/post.dart';
import '../services/fiirestore_service.dart';

class PostRepository {
  final FirestoreService _firestoreService;

  PostRepository(this._firestoreService);

  Future<void> createPost(PostModel post) async {
    await _firestoreService.createPost(post);
  }

  Stream<List<PostModel>> getAllPostsStream() {
    return _firestoreService.getAllPostsStream();
  }

  Stream<List<PostModel>> getPostsByCategoryStream(String category) {
    if (category == 'All') return getAllPostsStream();
    return _firestoreService.getPostsByCategoryStream(category);
  }

  Future<void> deletePost(String postId) async {
    await _firestoreService.deletePost(postId);
  }
}
