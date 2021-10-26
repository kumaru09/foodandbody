import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRepository {
  Future<void> addFavMenuById(String name) async {
    final CollectionReference favorite = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
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
        FirebaseFirestore.instance.collection('favorites');
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
