import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuCardRepository {
  Future<List<String>> getNameMenuListById() async {
    final CollectionReference favorite = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('favorites');
    final data =
        await favorite.orderBy('count', descending: true).limit(10).get();
    if (data.docs.isNotEmpty) {
      return data.docs.map<String>((doc) => doc.get('menu')).toList();
    } else {
      return List.empty();
    }
  }

  Future<List<String>> getNameMenuListAll() async {
    final CollectionReference favorite =
        FirebaseFirestore.instance.collection('favorites');
    final data =
        await favorite.orderBy('count', descending: true).limit(10).get();
    if (data.docs.isNotEmpty) {
      return data.docs.map<String>((doc) => doc.get('menu')).toList();
    } else {
      return List.empty();
    }
  }
}
