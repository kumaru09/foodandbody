import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/info_entity.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as p;

class UpdatePasswordFaliure implements Exception {
  final message;

  const UpdatePasswordFaliure([this.message = 'เกิดข้อผิดพลาด กรุณาลองใหม่']);

  factory UpdatePasswordFaliure.fromCode(String code) {
    switch (code) {
      case 'weak-password':
        return const UpdatePasswordFaliure();
      case 'requires-recent-login':
        return const UpdatePasswordFaliure(
            'ไม่สามารถแก้ไขได้ กรุณาเข้าสู่ระบบใหม่อีกครั้ง');
      default:
        return const UpdatePasswordFaliure();
    }
  }
}

class UploadProfilePicFailure implements Exception {
  final message;

  const UploadProfilePicFailure(
      [this.message = 'อัปโหลดรูปภาพไม่สำเร็จ กรุณาลองใหม่']);

  factory UploadProfilePicFailure.fromCode(String code) {
    switch (code) {
      case '':
        return const UploadProfilePicFailure();
      default:
        return const UploadProfilePicFailure();
    }
  }
}

class UpdateInfoFailure implements Exception {
  final message;
  const UpdateInfoFailure([this.message = 'แก้ไขข้อมูลไม่สำเร็จ กรุณาลองใหม่']);
}

class GetInitInfoFailure implements Exception {
  @override
  String toString() {
    return 'no-init-info';
  }
}

class UserRepository {
  UserRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    firebase_storage.FirebaseStorage? firebaseStorage,
    cloud_firestore.FirebaseFirestore? firebaseFirestore,
    AuthProviderManager? authProviderManager,
    UploadManager? uploadManager,
    required this.cache,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firebaseStorage =
            firebaseStorage ?? firebase_storage.FirebaseStorage.instance,
        _firebaseFirestore =
            firebaseFirestore ?? cloud_firestore.FirebaseFirestore.instance,
        _authProviderManager = authProviderManager ?? AuthProviderManager(),
        _uploadManager = uploadManager ?? UploadManager();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final firebase_storage.FirebaseStorage _firebaseStorage;
  final cloud_firestore.FirebaseFirestore _firebaseFirestore;
  final AuthProviderManager _authProviderManager;
  late final cloud_firestore.CollectionReference users =
      _firebaseFirestore.collection('users');
  final InfoCache cache;
  final UploadManager _uploadManager;

  Future<void> addUserInfo(Info info) async {
    final uid = _firebaseAuth.currentUser?.uid;
    final infoE = info.copyWith(
        goalNutrient: Nutrient(
            protein: double.parse(((info.goal! * 0.30) / 4).toStringAsFixed(1)),
            carb: double.parse(((info.goal! * 0.35) / 4).toStringAsFixed(1)),
            fat: double.parse(((info.goal! * 0.35) / 9).toStringAsFixed(1))));
    await users.doc(uid).set(infoE.toEntity().toDocument());
    await users
        .doc(uid)
        .collection('weight')
        .add({'weight': info.weight, "date": cloud_firestore.Timestamp.now()});
    cache.set(infoE);
  }

  Future<Info?> getInfo([bool isCache = false]) async {
    try {
      if (isCache) {
        final cachedResult = cache.get();
        if (cachedResult != null) return cachedResult;
      }
      final data = await users.doc(_firebaseAuth.currentUser?.uid).get();
      if (data.exists) {
        final info = Info.fromEntity(InfoEntity.fromSnapshot(data));
        cache.set(info);
        return info;
      } else {
        return null;
      }
    } catch (_) {
      throw Exception();
    }
  }

  Future<void> updateInfo(Info newInfo) async {
    try {
      final info = users.doc(_firebaseAuth.currentUser?.uid);
      await info.update({
        'name': newInfo.name,
        'photoUrl': newInfo.photoUrl,
        'gender': newInfo.gender
      });
    } catch (e) {
      throw UpdateInfoFailure();
    }
  }

  Future<void> updateGoalInfo(int goal) async {
    try {
      final info = users.doc(_firebaseAuth.currentUser?.uid);
      final goalNutrient = Nutrient(
          protein: double.parse(((goal * 0.30) / 4).toStringAsFixed(1)),
          carb: double.parse(((goal * 0.35) / 4).toStringAsFixed(1)),
          fat: double.parse(((goal * 0.35) / 9).toStringAsFixed(1)));
      return await info
          .update({'goal': goal, 'goalNutrient': goalNutrient.toJson()});
    } catch (e) {
      throw Exception('error updating info: $e');
    }
  }

  Future<void> updateHeightInfo(int height) async {
    try {
      final info = users.doc(_firebaseAuth.currentUser?.uid);
      return await info.update({'height': height});
    } catch (e) {
      throw Exception('error updating info');
    }
  }

  Future<void> updateWeightInfo(int weight) async {
    try {
      final info = users.doc(_firebaseAuth.currentUser?.uid);
      await info.update({'weight': weight});
      final cloud_firestore.CollectionReference weights =
          users.doc(_firebaseAuth.currentUser?.uid).collection('weight');
      await weights.add({"date": Timestamp.now(), "weight": weight});
    } catch (e) {
      throw Exception('error updating info');
    }
  }

  Future<void> updatePassword(String newPassword, String oldPassword) async {
    try {
      final user = _firebaseAuth.currentUser!;
      firebase_auth.AuthCredential credential = _authProviderManager.credential(
          email: user.email!, oldPassword: oldPassword);
      await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw UpdatePasswordFaliure.fromCode(e.code);
    } catch (e) {
      throw UpdatePasswordFaliure();
    }
  }

  Future<Uri> uploadProfilePic(File file) async {
    try {
      final ext = p.extension(file.path);
      final uploadTask = await _firebaseStorage
          .ref('users/profile/${Timestamp.now().seconds}$ext')
          .putFile(file);
      final uri = await _uploadManager.getDownloadURL(uploadTask);
      return Uri.parse(uri);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw UploadProfilePicFailure.fromCode(e.code);
    } catch (e) {
      throw UploadProfilePicFailure();
    }
  }
}

class InfoCache {
  late Info? _cache;

  Info? get() => _cache;

  void set(Info result) => _cache = result;
}

class UploadManager {
  const UploadManager();
  Future<String> getDownloadURL(
      firebase_storage.TaskSnapshot uploadTask) async {
    return await uploadTask.ref.getDownloadURL();
  }
}

class AuthProviderManager {
  const AuthProviderManager();
  firebase_auth.AuthCredential credential(
      {required String email, required String oldPassword}) {
    return firebase_auth.EmailAuthProvider.credential(
        email: email, password: oldPassword);
  }
}
