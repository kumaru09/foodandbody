import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:foodandbody/cache.dart';
import 'package:foodandbody/models/user.dart';
import 'package:meta/meta.dart';

class SignUpFailure implements Exception {}

class LogInWithEmailAndPasswordFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenRepository {
  AuthenRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _cache = cache ?? CacheClient();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final CacheClient _cache;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.wirte(key: userCacheKey, value: user);
      return user;
    });
  }

  User get currentUser {
    return _cache.read(key: userCacheKey) ?? User.empty;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut()
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(uid: uid, email: email, name: displayName, photo: photoURL);
  }
}