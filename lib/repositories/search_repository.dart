import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchRepository {
  Future<List<dynamic>> getNameMenuListById() async {
    final CollectionReference favorite = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('favorites');
    final data =
        await favorite.orderBy('count', descending: true).limit(5).get();
    if (data.docs.isNotEmpty) {
      return data.docs.map((doc) => doc.get('name')).toList();
    } else {
      return List.empty();
    }
  }

  Future<List<dynamic>> getNameMenuListAll() async {
    final CollectionReference favorite =
        FirebaseFirestore.instance.collection('favorites');
    final data =
        await favorite.orderBy('count', descending: true).limit(5).get();
    if (data.docs.isNotEmpty) {
      return data.docs.map((doc) => doc.get('name')).toList();
    } else {
      return List.empty();
    }
  }
}
