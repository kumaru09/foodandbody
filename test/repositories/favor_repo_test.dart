import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

Uri _menuUrl({required String path}) {
  return Uri.parse('https://foodandbody-api.azurewebsites.net/api/Menu/$path');
}

void main() {
  late FakeFirebaseFirestore instance;
  final user = MockUser(uid: 'uid');
  final firebaseAuth = MockFirebaseAuth(mockUser: user);
  late FavoriteRepository favoriteRepository;
  late MenuCardRepository menuCardRepository;
  final mockClient = MockClient();

  setUpAll(() {
    registerFallbackValue(Uri());
    firebaseAuth.signInWithEmailAndPassword(
        email: 'email', password: 'password');
    when(() =>
        mockClient
            .get(_menuUrl(path: 'กุ้งเผา'))).thenAnswer((invocation) async =>
        http.Response(
            '{"name":"กุ้งเผา","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            }));
    when(() => mockClient.get(
        _menuUrl(path: 'กุ้ง'))).thenAnswer((invocation) async => http.Response(
            '{"name":"กุ้ง","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            }));
  });

  group('FavoriteRepository', () {
    setUp(() async {
      instance = FakeFirebaseFirestore();
      await instance
          .collection('users')
          .doc('uid')
          .collection('favorites')
          .add({'menu': 'กุ้ง', "count": 1});
      await instance.collection('favorites').add({'menu': 'กุ้ง', "count": 1});
      menuCardRepository = MenuCardRepository(
          MenuCardCache(), MenuCardClient(httpClient: mockClient),
          firebaseAuth: firebaseAuth, firebaseFirestore: instance);
      favoriteRepository = FavoriteRepository(
          firebaseAuth: firebaseAuth, firebaseFirestore: instance);
    });

    test('addFavMenuById add new menu when not have menu yet', () async {
      await favoriteRepository.addFavMenuById('กุ้งเผา');
      final menuList = await menuCardRepository.getMenuList(
          isMyFav: true, checkCache: false);
      expect(
          menuList.any((element) => element.name == 'กุ้งเผา'), equals(true));
    });

    test('addFavMenuById update menu when have menu already', () async {
      await favoriteRepository.addFavMenuById('กุ้ง');
      await favoriteRepository.addFavMenuById('กุ้งเผา');
      final menuList = await menuCardRepository.getMenuList(
          isMyFav: true, checkCache: false);
      expect(menuList.first.name, equals('กุ้ง'));
      expect(menuList[1].name, equals('กุ้งเผา'));
    });

    test('addFavMenuAll add new menu when not have menu yet', () async {
      menuCardRepository = MenuCardRepository(
          MenuCardCache(), MenuCardClient(httpClient: mockClient),
          firebaseAuth: firebaseAuth, firebaseFirestore: instance);
      await favoriteRepository.addFavMenuAll('กุ้งเผา');
      final menuList = await menuCardRepository.getMenuList(
          isMyFav: false, checkCache: false);
      expect(
          menuList.any((element) => element.name == 'กุ้งเผา'), equals(true));
    });

    test('addFavMenuById update menu when have menu already', () async {
      await favoriteRepository.addFavMenuById('กุ้ง');
      await favoriteRepository.addFavMenuById('กุ้งเผา');
      final menuList = await menuCardRepository.getMenuList(
          isMyFav: true, checkCache: false);
      expect(menuList.first.name, equals('กุ้ง'));
      expect(menuList[1].name, equals('กุ้งเผา'));
    });
  });
}
