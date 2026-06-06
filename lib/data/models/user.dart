class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> interests;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.interests = const [],
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid:       map['uid'] as String? ?? '',
      name:      map['name'] as String? ?? '',
      email:     map['email'] as String? ?? '',
      interests: List<String>.from(map['interests'] as List? ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid':       uid,
      'name':      name,
      'email':     email,
      'interests': interests,
      'createdAt': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    List<String>? interests,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid:       uid ?? this.uid,
      name:      name ?? this.name,
      email:     email ?? this.email,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'UserModel(uid: $uid, name: $name, email: $email, interests: $interests)';
}