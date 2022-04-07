import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRepository {
  FavoriteRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  Future<void> addFavMenuById(String name) async {
    final CollectionReference favorite = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('favorites');
    final menu = await favorite.where('menu', isEqualTo: name).get();
    if (menu.docs.isNotEmpty) {
      print('Haved Menu');
      await menu.docs.first.reference
          .update({'count': menu.docs.first.get('count') + 1});
    } else {
      print('not Have');
      await favorite.add({'menu': name, "count": 1});
    }
    print('Added Fav Menu');
  }

  Future<void> addFavMenuAll(String name) async {
    final CollectionReference favorite =
        _firebaseFirestore.collection('favorites');
    final menu = await favorite.where('menu', isEqualTo: name).get();
    if (menu.docs.isNotEmpty) {
      await menu.docs.first.reference
          .update({'count': menu.docs.first.get('count') + 1});
    } else {
      await favorite.add({'menu': name, "count": 1});
    }
    print('Added All Fav Menu');
  }
}
