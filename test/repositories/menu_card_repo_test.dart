import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockMenuCardClient extends Mock implements MenuCardClient {}

class MockMenuCardCache extends Mock implements MenuCardCache {}

class MockClient extends Mock implements http.Client {}

Uri _menuUrl({required String path}) {
  return Uri.parse('https://foodandbody-api.azurewebsites.net/api/Menu/$path');
}

void main() {
  group('MenuCardRepository', () {
    late FakeFirebaseFirestore instance;
    final user = MockUser(uid: 'uid');
    final firebaseAuth = MockFirebaseAuth(mockUser: user);
    final mockClient = MockClient();
    late MenuCardRepository menuCardRepository;
    late MenuCardClient menuCardClient;
    late MenuCardCache menuCardCache;

    const List<MenuList> mockFavMenuList = [
      MenuList(name: 'cacheFavMenu1', calory: 100, imageUrl: 'imageUrl'),
      MenuList(name: 'cacheFavMenu2', calory: 100, imageUrl: 'imageUrl'),
      MenuList(name: 'cacheFavMenu3', calory: 100, imageUrl: 'imageUrl'),
    ];
    const List<MenuList> mockMyFavMenuList = [
      MenuList(name: 'cacheMyFavMenu1', calory: 100, imageUrl: 'imageUrl'),
      MenuList(name: 'cacheMyFavMenu2', calory: 100, imageUrl: 'imageUrl'),
      MenuList(name: 'cacheMyFavMenu3', calory: 100, imageUrl: 'imageUrl'),
    ];

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
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา1'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา1","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา2'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา2","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา3'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา3","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา4'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา4","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา5'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา5","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา6'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา6","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา7'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา7","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา8'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา8","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient
              .get(_menuUrl(path: 'กุ้งเผา9'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา9","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient.get(
              _menuUrl(path: 'กุ้งเผา10'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา10","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      when(() =>
          mockClient.get(
              _menuUrl(path: 'กุ้งเผา11'))).thenAnswer((invocation) async =>
          http.Response(
              '{"name":"กุ้งเผา11","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
    });

    setUp(() async {
      instance = FakeFirebaseFirestore();
      menuCardClient = MenuCardClient(httpClient: mockClient);
      menuCardCache = MockMenuCardCache();
      when(() => menuCardCache.get(true)).thenReturn(mockMyFavMenuList);
      when(() => menuCardCache.get(false)).thenReturn(mockFavMenuList);
      menuCardRepository = MenuCardRepository(menuCardCache, menuCardClient,
          firebaseAuth: firebaseAuth, firebaseFirestore: instance);
    });

    group('getMenuList', () {
      group('return', () {
        test('fetch empty list when not have menu yet', () async {
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false);
          expect(menuList.isEmpty, equals(true));
        });

        test('fetch menu list when have menu', () async {
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false);
          expect(menuList.any((element) => element.name == 'กุ้งเผา'),
              equals(true));
          verify(() => mockClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        });

        test(
            'fetch menu list 10 element order by most count when have a lot menu',
            () async {
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา1', "count": 1});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา2', "count": 2});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา3', "count": 3});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา4', "count": 4});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา5', "count": 5});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา6', "count": 6});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา7', "count": 7});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา8', "count": 8});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา9', "count": 9});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา10', "count": 10});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา11', "count": 11});
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false);
          expect(menuList[0].name, equals('กุ้งเผา11'));
          expect(menuList[1].name, equals('กุ้งเผา10'));
          expect(menuList[2].name, equals('กุ้งเผา9'));
          expect(menuList[3].name, equals('กุ้งเผา8'));
          expect(menuList[4].name, equals('กุ้งเผา7'));
          expect(menuList[5].name, equals('กุ้งเผา6'));
          expect(menuList[6].name, equals('กุ้งเผา5'));
          expect(menuList[7].name, equals('กุ้งเผา4'));
          expect(menuList[8].name, equals('กุ้งเผา3'));
          expect(menuList[9].name, equals('กุ้งเผา2'));
        });

        test(
            'favCache empty list when checkCache is true and not have menu in favCache',
            () async {
          menuCardRepository = MenuCardRepository(
              MenuCardCache(), menuCardClient,
              firebaseAuth: firebaseAuth, firebaseFirestore: instance);
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true);
          expect(menuList.isEmpty, equals(true));
        });

        test(
            'favCache menu list when checkCache is true and have menu in favCache',
            () async {
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true);
          expect(menuList[0].name, equals('cacheFavMenu1'));
          expect(menuList[1].name, equals('cacheFavMenu2'));
          expect(menuList[2].name, equals('cacheFavMenu3'));
        });

        test(
            'myFavCache empty list when checkCache is true and not have menu in myFavCache',
            () async {
          menuCardRepository = MenuCardRepository(
              MenuCardCache(), menuCardClient,
              firebaseAuth: firebaseAuth, firebaseFirestore: instance);
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: true, checkCache: true);
          expect(menuList.isEmpty, equals(true));
        });

        test(
            'myFavCache menu list when checkCache is true and have menu in myFavCache',
            () async {
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: true, checkCache: true);
          expect(menuList[0].name, equals('cacheMyFavMenu1'));
          expect(menuList[1].name, equals('cacheMyFavMenu2'));
          expect(menuList[2].name, equals('cacheMyFavMenu3'));
        });
      });

      group('call', () {
        test('cache get(true) when isMyFav is true and checkCache true',
            () async {
          await menuCardRepository.getMenuList(isMyFav: true, checkCache: true);
          verify(() => menuCardCache.get(true)).called(1);
        });

        test('cache get(false) when isMyFav is false and checkCache true',
            () async {
          await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true);
          verify(() => menuCardCache.get(false)).called(1);
        });

        test(
            'cache set myFavCache when checkCache false and httpClient fetch myFavMenuCard',
            () async {
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: true, checkCache: false);
          verify(() => menuCardCache.set(true, menuList)).called(1);
          verify(() => mockClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        });

        test(
            'cache set favCache when checkCache false and httpClient fetch favMenuCard',
            () async {
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          final menuList = await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false);
          verify(() => menuCardCache.set(false, menuList)).called(1);
          verify(() => mockClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        });

        test('httpClient get when isMyFav is true and checkCache false',
            () async {
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          await menuCardRepository.getMenuList(
              isMyFav: true, checkCache: false);
          verify(() => mockClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        });

        test('httpClient get when isMyFav is false and checkCache false',
            () async {
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          await menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false);
          verify(() => mockClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        });
      });
    });
    group('getNameMenuListById', () {
      group('return', () {
        test('empty list when not have menu yet', () async {
          final menuList = await menuCardRepository.getNameMenuListById();
          expect(menuList.isEmpty, equals(true));
        });

        test('menu name list when have menu ', () async {
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          final menuList = await menuCardRepository.getNameMenuListById();
          expect(menuList[0], 'กุ้งเผา');
        });

        test(
            'menu name list 10 element order by most count when have a lot menu ',
            () async {
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา1', "count": 1});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา2', "count": 2});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา3', "count": 3});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา4', "count": 4});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา5', "count": 5});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา6', "count": 6});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา7', "count": 7});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา8', "count": 8});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา9', "count": 9});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา10', "count": 10});
          await instance
              .collection('users')
              .doc('uid')
              .collection('favorites')
              .add({'menu': 'กุ้งเผา11', "count": 11});
          final menuList = await menuCardRepository.getNameMenuListById();
          expect(menuList[0], 'กุ้งเผา11');
          expect(menuList[1], 'กุ้งเผา10');
          expect(menuList[2], 'กุ้งเผา9');
          expect(menuList[3], 'กุ้งเผา8');
          expect(menuList[4], 'กุ้งเผา7');
          expect(menuList[5], 'กุ้งเผา6');
          expect(menuList[6], 'กุ้งเผา5');
          expect(menuList[7], 'กุ้งเผา4');
          expect(menuList[8], 'กุ้งเผา3');
          expect(menuList[9], 'กุ้งเผา2');
        });
      });
    });
    group('getNameMenuListAll', () {
      group('return', () {
        test('empty list when not have menu yet', () async {
          final menuList = await menuCardRepository.getNameMenuListAll();
          expect(menuList.isEmpty, equals(true));
        });

        test('menu name list when have menu ', () async {
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา', "count": 1});
          final menuList = await menuCardRepository.getNameMenuListAll();
          expect(menuList[0], 'กุ้งเผา');
        });

        test(
            'menu name list 10 element order by most count when have a lot menu ',
            () async {
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา1', "count": 1});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา2', "count": 2});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา3', "count": 3});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา4', "count": 4});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา5', "count": 5});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา6', "count": 6});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา7', "count": 7});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา8', "count": 8});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา9', "count": 9});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา10', "count": 10});
          await instance
              .collection('favorites')
              .add({'menu': 'กุ้งเผา11', "count": 11});
          final menuList = await menuCardRepository.getNameMenuListAll();
          expect(menuList[0], 'กุ้งเผา11');
          expect(menuList[1], 'กุ้งเผา10');
          expect(menuList[2], 'กุ้งเผา9');
          expect(menuList[3], 'กุ้งเผา8');
          expect(menuList[4], 'กุ้งเผา7');
          expect(menuList[5], 'กุ้งเผา6');
          expect(menuList[6], 'กุ้งเผา5');
          expect(menuList[7], 'กุ้งเผา4');
          expect(menuList[8], 'กุ้งเผา3');
          expect(menuList[9], 'กุ้งเผา2');
        });
      });
    });
  });
}
