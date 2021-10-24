import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_entity.dart';
import 'package:foodandbody/models/history_entity.dart';

class BodyRepository {
  final DateTime now = DateTime.now();

  Future<Body> getBodyLatest() async {
    final CollectionReference bodyHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bodyHistories');
    final body =
        await bodyHistories.orderBy('date', descending: true).limit(1).get();
    if (body.docs.isNotEmpty) {
      return Body.fromEmtity(BodyEntity.fromSnapshot(body.docs.first));
    } else {
      return Body.empty;
    }
  }

  Future<List<Body>> getBodyList() async {
    final CollectionReference bodyHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bodyHistories');
    final body =
        await bodyHistories.orderBy('date', descending: true).limit(10).get();
    if (body.docs.isNotEmpty) {
      return body.docs
          .map((body) => Body.fromEmtity(BodyEntity.fromSnapshot(body)))
          .toList();
    } else {
      return List.empty();
    }
  }
}
