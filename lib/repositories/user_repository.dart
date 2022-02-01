import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/info_entity.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:foodandbody/repositories/i_user_repository.dart';

class UpdatePasswordFaliure implements Exception {
  final message;

  const UpdatePasswordFaliure([this.message = 'เกิดข้อผิดพลาดบางอย่าง']);

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

class UpdateInfoFailure implements Exception {
  final message;
  const UpdateInfoFailure([this.message = 'เกิดข้อผิดพลาดบางอย่าง']);
}

class UserRepository implements IUserRepository {
  final cloud_firestore.CollectionReference users =
      cloud_firestore.FirebaseFirestore.instance.collection('users');

  @override
  Future<void> addUserInfo(Info info) async {
    final uid = firebase_auth.FirebaseAuth.instance.currentUser?.uid;
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
  }

  @override
  Future<Info> getInfo() async {
    final data = await users
        .doc(firebase_auth.FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (data.exists) {
      final info = Info.fromEntity(InfoEntity.fromSnapshot(data));
      return info;
    } else {
      throw Exception('No Info data');
    }
  }

  @override
  Future<void> updateInfo(Info newInfo) async {
    try {
      final info = cloud_firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(firebase_auth.FirebaseAuth.instance.currentUser?.uid);
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
      final info = cloud_firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(firebase_auth.FirebaseAuth.instance.currentUser?.uid);
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
      final info = cloud_firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(firebase_auth.FirebaseAuth.instance.currentUser?.uid);
      return await info.update({'height': height});
    } catch (e) {
      throw Exception('error updating info');
    }
  }

  Future<void> updateWeightInfo(int weight) async {
    try {
      final info = cloud_firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(firebase_auth.FirebaseAuth.instance.currentUser?.uid);
      await info.update({'weight': weight});
      final cloud_firestore.CollectionReference weights = cloud_firestore
          .FirebaseFirestore.instance
          .collection('users')
          .doc(firebase_auth.FirebaseAuth.instance.currentUser?.uid)
          .collection('weight');
      await weights.add({"date": Timestamp.now(), "weight": weight});
    } catch (e) {
      throw Exception('error updating info');
    }
  }

  Future<void> updatePassword(String newPassword, String oldPassword) async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser!;
      firebase_auth.AuthCredential credential =
          firebase_auth.EmailAuthProvider.credential(
              email: user.email!, password: oldPassword);
      await firebase_auth.FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw UpdatePasswordFaliure.fromCode(e.code);
    } catch (e) {
      throw UpdatePasswordFaliure();
    }
  }
}
