import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_entity.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/models/weight_list.dart';

class BodyRepository {
  BodyRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final DateTime now = DateTime.now();
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  Future<Body> getBodyLatest() async {
    final CollectionReference bodyHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('bodyhistories');
    try {
      final body =
          await bodyHistories.orderBy('date', descending: true).limit(1).get();
      if (body.docs.isNotEmpty) {
        return Body.fromEmtity(BodyEntity.fromSnapshot(body.docs.first));
      } else {
        return Body.empty;
      }
    } catch (_) {
      throw Exception();
    }
  }

  Future<int?> getWeightLatest() async {
    final CollectionReference bodyHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('weight');
    try {
      final weight =
          await bodyHistories.orderBy('date', descending: true).limit(1).get();
      if (weight.docs.isNotEmpty) {
        return weight.docs.first.get('weight');
      }
      return null;
    } catch (_) {
      throw (Exception());
    }
  }

  Future<List<Body>> getBodyList() async {
    final CollectionReference bodyHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('bodyhistories');
    try {
      final body =
          await bodyHistories.orderBy('date', descending: true).limit(10).get();
      if (body.docs.isNotEmpty) {
        return body.docs
            .map((body) => Body.fromEmtity(BodyEntity.fromSnapshot(body)))
            .toList();
      } else {
        return List.empty();
      }
    } catch (_) {
      throw (Exception());
    }
  }

  Future<List<WeightList>> getWeightList() async {
    final CollectionReference bodyHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('weight');
    final data =
        await bodyHistories.orderBy('date', descending: true).limit(10).get();
    if (data.docs.isNotEmpty) {
      return data.docs.map((e) => WeightList.fromSanpShot(e)).toList();
    }
    return List.empty();
  }

  Future<void> addWeight(int weight) async {
    final CollectionReference bodyHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('weight');
    try {
      await bodyHistories.add({'date': Timestamp.now(), 'weight': weight});
    } catch (e) {
      throw Exception('error adding weight');
    }
  }

  Future<void> updateBody(Body body) async {
    final CollectionReference bodyHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('bodyhistories');
    try {
      await bodyHistories.add(body.toEntity().toJson());
    } catch (e) {
      throw Exception('error updating body');
    }
  }

  Future<void> addBodyCamera(BodyPredict bodyPredict) async {
    final CollectionReference bodyHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('bodyhistories');
    try {
      await bodyHistories.add(Body(
              date: Timestamp.now(),
              shoulder: bodyPredict.shoulder,
              chest: bodyPredict.chest,
              waist: bodyPredict.waist,
              hip: bodyPredict.hip)
          .toEntity()
          .toJson());
    } catch (e) {
      throw Exception('error updating body');
    }
  }
}
