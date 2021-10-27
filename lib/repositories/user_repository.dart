import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/info_entity.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:foodandbody/repositories/i_user_repository.dart';

class UserRepository implements IUserRepository {
  final cloud_firestore.CollectionReference users =
      cloud_firestore.FirebaseFirestore.instance.collection('users');

  @override
  Future<void> addUserInfo(String uid, Info info) async {
    final infoE = info.copyWith(
        goalNutrient: Nutrient(
            protein: (info.goal! * 0.30) / 4,
            carb: (info.goal! * 0.35) / 4,
            fat: (info.goal! * 0.35) / 9));
    await users
        .doc(uid)
        .collection('weight')
        .add({'weight': info.weight, "date": cloud_firestore.Timestamp.now()});
    return await users.doc(uid).set(infoE.toEntity().toDocument());
  }

  @override
  Future<User> getInfo(User user) async {
    final data = await users.doc(user.uid).get();
    if (data.exists) {
      final info = Info.fromEntity(InfoEntity.fromSnapshot(data));
      return user.copyWith(info: info);
    } else {
      log("Cached get failed");
      return user.copyWith(info: null);
    }
  }

  @override
  Future<void> updateInfo(User user) {
    return users.doc(user.uid).update(user.info!.toEntity().toDocument());
  }
}
