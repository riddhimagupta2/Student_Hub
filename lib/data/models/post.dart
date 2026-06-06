import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String content;
  final String category;
  final DateTime timestamp;
  final String userId;

  const PostModel({
    required this.postId,
    required this.content,
    required this.category,
    required this.timestamp,
    required this.userId,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, {String? id}) {
    DateTime ts;
    final rawTs = map['timestamp'];
    if (rawTs is Timestamp) {
      ts = rawTs.toDate();
    } else if (rawTs is String) {
      ts = DateTime.tryParse(rawTs) ?? DateTime.now();
    } else {
      ts = DateTime.now();
    }

    return PostModel(
      postId:    id ?? map['postId'] as String? ?? '',
      content:   map['content'] as String? ?? '',
      category:  map['category'] as String? ?? 'General Discussion',
      timestamp: ts,
      userId:    map['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId':    postId,
      'content':   content,
      'category':  category,
      'timestamp': FieldValue.serverTimestamp(),
      'userId':    userId,
    };
  }

  PostModel copyWith({
    String? postId,
    String? content,
    String? category,
    DateTime? timestamp,
    String? userId,
  }) {
    return PostModel(
      postId:    postId ?? this.postId,
      content:   content ?? this.content,
      category:  category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      userId:    userId ?? this.userId,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    if (diff.inDays < 7)     return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  @override
  String toString() =>
      'PostModel(postId: $postId, category: $category, timestamp: $timestamp)';
}