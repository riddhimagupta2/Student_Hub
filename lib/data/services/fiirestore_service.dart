import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app/constants/constant.dart';
import '../models/post.dart';
import '../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _db.collection(AppConstants.usersCollection);

  CollectionReference<Map<String, dynamic>> get _postsRef =>
      _db.collection(AppConstants.postsCollection);

  Future<void> createUser(UserModel user) async {
    await _usersRef.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUser(UserModel user) async {
    await _usersRef.doc(user.uid).update(user.toMap());
  }

  Future<void> updateInterests(String uid, List<String> interests) async {
    await _usersRef.doc(uid).update({'interests': interests});
  }

  Future<void> createPost(PostModel post) async {
    final docRef = _postsRef.doc();
    final updatedPost = post.copyWith(postId: docRef.id);
    await docRef.set(updatedPost.toMap());
  }

  Stream<List<PostModel>> getAllPostsStream() {
    return _postsRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => PostModel.fromMap(d.data(), id: d.id))
              .toList(),
        );
  }

  Stream<List<PostModel>> getPostsByCategoryStream(String category) {
    return _postsRef
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snap) {
        final posts = snap.docs
            .map((d) => PostModel.fromMap(d.data(), id: d.id))
            .toList();

        posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return posts;
      },
    );
  }

  Future<void> deletePost(String postId) async {
    await _postsRef.doc(postId).delete();
  }
}
