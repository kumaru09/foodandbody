import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_entity.dart';
import 'package:foodandbody/models/weight_list.dart';

class BodyRepository {
  final DateTime now = DateTime.now();

  Future<Body> getBodyLatest() async {
    final CollectionReference bodyHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bodyhistories');
    final body =
        await bodyHistories.orderBy('date', descending: true).limit(1).get();
    if (body.docs.isNotEmpty) {
      return Body.fromEmtity(BodyEntity.fromSnapshot(body.docs.first));
    } else {
      return Body.empty;
    }
  }

  Future<void> getWeightLatest() async {
    final CollectionReference bodyHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('weight');
    final weight =
        await bodyHistories.orderBy('date', descending: true).limit(1).get();
    if (weight.docs.isNotEmpty) {
      return weight.docs.first.get('weight');
    }
    return null;
  }

  Future<List<Body>> getBodyList() async {
    final CollectionReference bodyHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bodyhistories');
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

  Future<List<WeightList>> getWeightList() async {
    final CollectionReference bodyHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('weight');
    final data =
        await bodyHistories.orderBy('date', descending: true).limit(10).get();
    if (data.docs.isNotEmpty) {
      return data.docs.map((e) => WeightList.fromSanpShot(e)).toList();
    }
    return List.empty();
  }

  Future<void> addWeight(int weight) async {
    final CollectionReference bodyHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('weight');
    try {
      await bodyHistories.add({'date': Timestamp.now(), 'weight': weight});
    } catch (e) {
      throw Exception('error adding weight');
    }
  }
}
