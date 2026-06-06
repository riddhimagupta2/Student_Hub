import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/fiirestore_service.dart';

class AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository(this._authService, this._firestoreService);

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  User? get currentUser => _authService.currentUser;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _authService.updateDisplayName(name);

    final user = UserModel(
      uid: credential.user!.uid,
      name: name,
      email: email,
      interests: [],
      createdAt: DateTime.now(),
    );
    await _firestoreService.createUser(user);
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = await _firestoreService.getUser(credential.user!.uid);
    if (user == null) {
      final fallback = UserModel(
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? 'Student',
        email: email,
      );
      await _firestoreService.createUser(fallback);
      return fallback;
    }
    return user;
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  Future<UserModel?> fetchCurrentUser() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return null;
    return await _firestoreService.getUser(uid);
  }

  Future<void> updateProfile(UserModel user) async {
    await _firestoreService.updateUser(user);
    await _authService.updateDisplayName(user.name);
  }

  Future<void> updateInterests(String uid, List<String> interests) async {
    await _firestoreService.updateInterests(uid, interests);
  }
}
