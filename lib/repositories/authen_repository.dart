import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:foodandbody/cache.dart';
import 'package:foodandbody/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class SignUpFailure implements Exception {}

class LogInWithEmailAndPasswordFailure implements Exception {
  final String message;

  const LogInWithEmailAndPasswordFailure([
    this.message = 'เกิดข้อผิดพลาดบางอย่าง กรุณาลองใหม่อีกครั้ง',
  ]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
        );
      case 'not-verified':
        return const LogInWithEmailAndPasswordFailure(
            'อีเมลยังไม่ได้รับการยีนยัน กดยืนยันผ่านอีเมลของคุณ');
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }
}

class LogInWithEmailLinkFailure implements Exception {
  final String message;

  const LogInWithEmailLinkFailure(
      [this.message =
          'เกิดข้อผิดพลาดบางอย่าง กรุณาล็อกอินเพื่อขอลิ้งใหม่อีกครั้ง']);

  factory LogInWithEmailLinkFailure.fromCode(String code) {
    switch (code) {
      case 'expired-action-code':
        return const LogInWithEmailLinkFailure(
            'ลิ้งหมดอายุ กรุณาล็อกอินเพื่อขอลิ้งใหม่อีกครั้ง');
      case 'invalid-action-code':
        return const LogInWithEmailLinkFailure(
            'ลิ้งหมดอายุ กรุณาล็อกอินเพื่อขอลิ้งใหม่อีกครั้ง');
      default:
        return const LogInWithEmailLinkFailure();
    }
  }
}

class NotVerified implements Exception {
  @override
  String toString() {
    return 'not-verified';
  }
}

class LogOutFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class LogInWithFacebookFailure implements Exception {
  final String message;
  const LogInWithFacebookFailure(
      [this.message = 'เกิดข้อผิดพลาดบางอย่าง กรุณาลองใหม่อีกครั้ง']);
  factory LogInWithFacebookFailure.fromCode(String code) {
    switch (code) {
      case 'not-verified':
        return const LogInWithFacebookFailure(
            'อีเมลยังไม่ได้รับการยีนยัน กดยืนยันผ่านอีเมลของคุณ');
      default:
        return const LogInWithFacebookFailure();
    }
  }
}

class DeleteUserFailure implements Exception {
  final message;
  const DeleteUserFailure(
      [this.message = 'ไม่สามารถลบบัญชีผู้ใช้ได้ กรุณาลองใหม่อีกครั้ง']);

  factory DeleteUserFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return DeleteUserFailure(
            'ไม่สามารถลบบัญชีผู้ใช้ได้ รหัสผ่านไม่ถูกต้อง');
      case 'wrong-password':
        return DeleteUserFailure(
            'ไม่สามารถลบบัญชีผู้ใช้ได้ รหัสผ่านไม่ถูกต้อง');
      case 'requires-recent-login':
        return DeleteUserFailure(
            'ไม่สามารถลบบัญชีผู้ใช้ได้ กรุณาล็อกอินใหม่อีกครั้ง');
      default:
        return DeleteUserFailure();
    }
  }
}

class AuthenRepository {
  AuthenRepository(
      {CacheClient? cache,
      firebase_auth.FirebaseAuth? firebaseAuth,
      GoogleSignIn? googleSignIn,
      FacebookAuth? facebookAuth,
      AuthProviderManager? authProviderManager})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _cache = cache ?? CacheClient(),
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _authProviderManager = authProviderManager ?? AuthProviderManager();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final CacheClient _cache;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final AuthProviderManager _authProviderManager;

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
          email: email, password: password);
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // final emailVerified =
      //     firebase_auth.FirebaseAuth.instance.currentUser!.emailVerified;
      // if (!emailVerified) {
      //   sendVerifyEmail();
      //   await logOut();
      //   throw NotVerified();
      // }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw LogInWithEmailAndPasswordFailure.fromCode(_.toString());
    }
  }

  // Future<void> logInWithEmailLink(String email, String emailLink) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailLink(
  //         email: email, emailLink: emailLink);
  //   } on firebase_auth.FirebaseAuthException catch (e) {
  //     throw LogInWithEmailLinkFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw LogInWithEmailLinkFailure();
  //   }
  // }

  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } catch (_) {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();
      final firebase_auth.OAuthCredential facebookAuthCredential =
          _authProviderManager
              .getFacebookOAuthCredential(loginResult.accessToken!.token);
      await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    } catch (_) {
      throw LogInWithFacebookFailure.fromCode(_.toString());
    }
  }

  Future<void> sendForgetPasswordEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  Future<void> sendVerifyEmail() async {
    try {
      firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        var actionCodeSettings = firebase_auth.ActionCodeSettings(
          url:
              'https://foodbody-bnn.firebaseapp.com/finishSignUp?email=${user.email}',
          androidPackageName: 'com.bnnproject.foodandbody',
          dynamicLinkDomain: 'foodandbody.page.link',
          androidInstallApp: false,
          androidMinimumVersion: '21',
          handleCodeInApp: true,
        );
        await user.sendEmailVerification(actionCodeSettings);
        print('send to ${user.email}');
      }
    } catch (e) {
      print('sendVerifyEmail error: $e');
      throw (Exception());
    }
  }

  Future<void> deleteUser(String password) async {
    try {
      firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw DeleteUserFailure.fromCode(e.code);
    } catch (_) {
      throw DeleteUserFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
        uid: uid,
        email: email,
        name: displayName,
        photoUrl: photoURL,
        emailVerified: emailVerified);
  }
}

class AuthProviderManager {
  const AuthProviderManager();
  firebase_auth.OAuthCredential getFacebookOAuthCredential(String accessToken) {
    return firebase_auth.FacebookAuthProvider.credential(accessToken);
  }
}
