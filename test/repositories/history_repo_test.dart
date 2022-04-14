import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/repositories/history_repository.dart';
import 'package:test/test.dart';

void main() {
  late HistoryRepository historyRepository;
  late FakeFirebaseFirestore instance;
  final user = MockUser(uid: 'uid');
  final firebaseAuth = MockFirebaseAuth(mockUser: user);

  setUpAll(() {
    firebaseAuth.signInWithEmailAndPassword(
        email: 'email', password: 'password');
  });

  group('HistoryRepository', () {
    setUp(() async {
      instance = FakeFirebaseFirestore();
      await instance
          .collection('users')
          .doc('uid')
          .collection('foodhistories')
          .add(History(Timestamp.fromDate(DateTime(2022, 4, 5)), menuList: [
            Menu(
                name: 'name',
                calories: 120,
                protein: 10,
                carb: 10,
                fat: 5,
                serve: 1,
                volumn: 1)
          ]).toEntity().toJson());
      await instance
          .collection('users')
          .doc('uid')
          .collection('foodhistories')
          .add(History(Timestamp.fromDate(DateTime(2022, 4, 6)))
              .toEntity()
              .toJson());
      historyRepository = HistoryRepository(
          firebaseAuth: firebaseAuth, firebaseFirestore: instance);
    });

    test('getHistory return HistoryList on success and Doc exist', () async {
      final historyList = await historyRepository.getHistory();
      expect(historyList.isNotEmpty, equals(true));
    });

    test('getMenuListByDate return menuList on success and Doc exist',
        () async {
      final DateTime midNight = DateTime(2022, 4, 5);
      final DateTime beforeMidNight =
          midNight.add(new Duration(hours: 23, minutes: 59, seconds: 59));
      final menuList = await historyRepository.getMenuListByDate(
          Timestamp.fromDate(midNight), Timestamp.fromDate(beforeMidNight));
      expect(menuList.isNotEmpty, equals(true));
    });

    test('getMenuListByDate return menuListEmpty on success and Doc exist',
        () async {
      final DateTime midNight = DateTime(2022, 4, 6);
      final DateTime beforeMidNight =
          midNight.add(new Duration(hours: 23, minutes: 59, seconds: 59));
      final menuList = await historyRepository.getMenuListByDate(
          Timestamp.fromDate(midNight), Timestamp.fromDate(beforeMidNight));
      expect(menuList.isEmpty, equals(true));
    });
  });

  group('HistoryRepository', () {
    setUp(() async {
      instance = FakeFirebaseFirestore();
      historyRepository = HistoryRepository(
          firebaseAuth: firebaseAuth, firebaseFirestore: instance);
    });

    test('getHistory return ListEmpty on success and  Doc not exist', () async {
      final historyList = await historyRepository.getHistory();
      expect(historyList.isEmpty, equals(true));
    });

    test('getMenuListByDate return ListEmpty on success and Doc not exist',
        () async {
      final DateTime midNight = DateTime(2022, 4, 5);
      final DateTime beforeMidNight =
          midNight.add(new Duration(hours: 23, minutes: 59, seconds: 59));
      final menuList = await historyRepository.getMenuListByDate(
          Timestamp.fromDate(midNight), Timestamp.fromDate(beforeMidNight));
      expect(menuList.isEmpty, equals(true));
    });
  });
}
