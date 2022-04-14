import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/history_entity.dart';
import 'package:foodandbody/models/menu.dart';

class HistoryRepository {
  HistoryRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  Future<List<History>> getHistory() async {
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final history =
        await foodHistories.orderBy('date', descending: true).limit(10).get();
    if (history.docs.isNotEmpty) {
      return history.docs
          .map((history) =>
              History.fromEntity(HistoryEntity.fromSnapshot(history)))
          .toList();
    } else {
      return List.empty();
    }
  }

  Future<List<Menu>> getMenuListByDate(
      Timestamp stateTime, Timestamp endTime) async {
    final CollectionReference foodHistories = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('foodhistories');
    final history = await foodHistories
        .where('date', isGreaterThanOrEqualTo: stateTime)
        .where('date', isLessThanOrEqualTo: endTime)
        .get();
    if (history.docs.isNotEmpty) {
      print('have menu from repo');
      return history.docs.first
          .get('menuList')
          .map<Menu>((menu) => Menu.fromJson(menu))
          .toList();
    } else {
      return List.empty();
    }
  }
}
