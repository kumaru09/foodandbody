import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:http/http.dart' as http;

class MenuCardRepository {
  MenuCardRepository(this.cache, this.client,
      {FirebaseFirestore? firebaseFirestore, FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final MenuCardCache cache;
  final MenuCardClient client;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;

  Future<List<MenuList>> getMenuList(
      {required bool isMyFav, required bool checkCache}) async {
    if (checkCache) {
      final cachedResult = cache.get(isMyFav);
      if (cachedResult != null) return cachedResult;
    }
    List<MenuList> menu = [];
    List<String> nameList =
        isMyFav ? await getNameMenuListById() : await getNameMenuListAll();
    for (var name in nameList) menu.add(await client.fetchMenu(name));
    cache.set(isMyFav, menu);
    return menu;
  }

  Future<List<String>> getNameMenuListById() async {
    final CollectionReference favorite = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('favorites');
    try {
      final data =
          await favorite.orderBy('count', descending: true).limit(10).get();
      if (data.docs.isNotEmpty) {
        return data.docs.map<String>((doc) => doc.get('menu')).toList();
      } else {
        return List.empty();
      }
    } catch (e) {
      print('getNameMenuListById error: $e');
      return List.empty();
    }
  }

  Future<List<String>> getNameMenuListAll() async {
    final CollectionReference favorite =
        _firebaseFirestore.collection('favorites');
    try {
      final data =
          await favorite.orderBy('count', descending: true).limit(10).get();
      if (data.docs.isNotEmpty) {
        return data.docs.map<String>((doc) => doc.get('menu')).toList();
      } else {
        return List.empty();
      }
    } catch (e) {
      print('getNameMenuListAll error: $e');
      return List.empty();
    }
  }
}

class MenuCardCache {
  final _cache = <bool, List<MenuList>>{};

  List<MenuList>? get(bool term) => _cache[term];

  void set(bool term, List<MenuList> result) => _cache[term] = result;

  bool contains(bool term) => _cache.containsKey(term);

  void remove(bool term) => _cache.remove(term);
}

class MenuCardClient {
  MenuCardClient({
    http.Client? httpClient,
  }) : this.httpClient = httpClient ?? http.Client();

  final http.Client httpClient;

  Future<MenuList> fetchMenu(String path) async {
    final response = await httpClient.get(
        Uri.parse("https://foodandbody-api.azurewebsites.net/api/Menu/$path"));
    if (response.statusCode == 200)
      return MenuList.fromJson(json.decode(response.body));
    throw Exception('error fetching menu');
  }
}
