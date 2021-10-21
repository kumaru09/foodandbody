import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/history_entity.dart';

class HistoryRepository {
  final DateTime now = DateTime.now();
  late final DateTime dateBefore =
      DateTime(now.year, now.month, now.day).subtract(Duration(days: 10));

  Future<List<History>> getHistory() async {
    final CollectionReference foodHistories = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('foodhistories');
    final history = await foodHistories
        .where('date', isGreaterThanOrEqualTo: dateBefore)
        .get();
    if (history.docs.isNotEmpty) {
      return history.docs
          .map((history) =>
              History.fromEntity(HistoryEntity.fromSnapshot(history)))
          .toList();
    } else {
      return List.empty();
    }
  }
}
