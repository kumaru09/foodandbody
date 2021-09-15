import 'dart:async';
import 'dart:developer';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;

class UserRepository {

  Future<void> addUser(String uid,
      String name, int goal, int height, int weight, String gender) async {
    final cloud_firestore.CollectionReference usersRef =
        cloud_firestore.FirebaseFirestore.instance.collection('users');

    await usersRef
        .add({
          'id': uid,
          'name': name,
          'goal': goal,
          'height': height,
          'weight': weight,
          'gender': gender
        })
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }
}
