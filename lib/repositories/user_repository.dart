import 'dart:async';
import 'dart:developer';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/info_entity.dart';
import 'package:foodandbody/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:foodandbody/repositories/i_user_repository.dart';

class UserRepository implements IUserRepository {
  UserRepository({required User user}) : _user = user;

  final User _user;

  final cloud_firestore.CollectionReference users =
      cloud_firestore.FirebaseFirestore.instance.collection('users');

  @override
  Future<void> addUserInfo(Info info) {
    return users.doc(this._user.uid).set(info.toEntity().toDocument());
  }

  @override
  Stream<Info> info() {
    return users.doc(this._user.uid).snapshots().map((snapshot) {
      return snapshot.exists
          ? Info.fromEntity(InfoEntity.fromSnapshot(snapshot))
          : Info.fromEntity(InfoEntity.empty);
    });
  }

  @override
  Future<void> updateInfo(Info info) {
    return users.doc(this._user.uid).update(info.toEntity().toDocument());
  }
}
