import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCloud extends Mock implements FirebaseFirestore {}

void main() {
  late FakeFirebaseFirestore instance;
  final user = MockUser(uid: 'uid');
  final firebaseAuth = MockFirebaseAuth(mockUser: user);
  late MockCloud mockCloud;
  late BodyRepository bodyRepository;
  late BodyRepository mockBodyRepository;

  setUpAll(() {
    firebaseAuth.signInWithEmailAndPassword(
        email: 'email', password: 'password');
    mockCloud = MockCloud();
    mockBodyRepository = BodyRepository(
        firebaseAuth: firebaseAuth, firebaseFirestore: mockCloud);
  });
  group('BodyRepository', () {
    setUp(() async {
      instance = FakeFirebaseFirestore();
      await instance
          .collection('users')
          .doc('uid')
          .collection('bodyhistories')
          .add(Body(
                  date: Timestamp.fromDate(DateTime(2022, 4, 6)),
                  shoulder: 40,
                  chest: 40,
                  waist: 40,
                  hip: 40)
              .toEntity()
              .toJson());
      await instance
          .collection('users')
          .doc('uid')
          .collection('bodyhistories')
          .add(Body(
                  date: Timestamp.fromDate(DateTime(2022, 4, 5)),
                  shoulder: 40,
                  chest: 33,
                  waist: 40,
                  hip: 35)
              .toEntity()
              .toJson());
      await instance
          .collection('users')
          .doc('uid')
          .collection('weight')
          .add({'date': DateTime(2022, 4, 6), 'weight': 80});
      await instance
          .collection('users')
          .doc('uid')
          .collection('weight')
          .add({'date': DateTime(2022, 4, 5), 'weight': 75});
      bodyRepository = BodyRepository(
          firebaseFirestore: instance, firebaseAuth: firebaseAuth);
    });

    test('getBodyLastest return bodyLastest on success and isNotEmpty',
        () async {
      final body = await bodyRepository.getBodyLatest();
      expect(body.date, equals(Timestamp.fromDate(DateTime(2022, 4, 6))));
    });

    test('getBodyLastest throws when fail', () {
      when(() => mockCloud
          .collection('users')
          .doc('uid')
          .collection('bodyhistories')
          .orderBy('date', descending: true)
          .limit(1)
          .get()).thenThrow(Exception());
      expect(() async => await mockBodyRepository.getBodyLatest(),
          throwsA(isA<Exception>()));
    });

    test('getWeightLastest return weight on success and isNotEmpty', () async {
      final weight = await bodyRepository.getWeightLatest();
      expect(weight, equals(80));
    });

    test('getWeightLastest throws when fail', () {
      when(() => mockCloud
          .collection('users')
          .doc('uid')
          .collection('weight')
          .orderBy('date', descending: true)
          .limit(1)
          .get()).thenThrow(Exception());
      expect(() async => await mockBodyRepository.getWeightLatest(),
          throwsA(isA<Exception>()));
    });

    test('getBobyList return BodyList on success and isNotEmpty', () async {
      final bodyList = await bodyRepository.getBodyList();
      expect(bodyList.isNotEmpty, equals(true));
    });

    test('getBodyList throws when fail', () {
      when(() => mockCloud
          .collection('users')
          .doc('uid')
          .collection('bodyhistories')
          .orderBy('date', descending: true)
          .limit(10)
          .get()).thenThrow(Exception());
      expect(() async => await mockBodyRepository.getWeightLatest(),
          throwsA(isA<Exception>()));
    });

    test('getWeightList return WeightList on success and isNotEmpty', () async {
      final weightList = await bodyRepository.getWeightList();
      expect(weightList.isNotEmpty, equals(true));
    });

    test('addWeight success', () async {
      await bodyRepository.addWeight(90);
      expect(await bodyRepository.getWeightLatest(), equals(90));
    });

    test('addWeight throws when fail', () {
      when(() => mockCloud
          .collection('users')
          .doc('uid')
          .collection('weight')
          .add({'date': Timestamp.now(), 'weight': 90})).thenThrow(Exception());
      expect(() async => await mockBodyRepository.addWeight(90),
          throwsA(isA<Exception>()));
    });

    test('updateBody success', () async {
      final body = Body(
          date: Timestamp.now(), shoulder: 42, chest: 44, waist: 35, hip: 32);
      await bodyRepository.updateBody(body);
      expect(await bodyRepository.getBodyLatest(), equals(body));
    });

    test('updateBody throws when fail', () {
      final body = Body(
          date: Timestamp.now(), shoulder: 42, chest: 44, waist: 35, hip: 32);
      when(() => mockCloud
          .collection('users')
          .doc('uid')
          .collection('bodyhistories')
          .add(body.toEntity().toJson())).thenThrow(Exception());
      expect(() async => await mockBodyRepository.updateBody(body),
          throwsA(isA<Exception>()));
    });
  });

  group('BodyRepository', () {
    setUp(() {
      instance = FakeFirebaseFirestore();
      bodyRepository = BodyRepository(
          firebaseFirestore: instance, firebaseAuth: firebaseAuth);
    });

    test('getBodyLastest return bodyEmpty on success and isEmpty', () async {
      final body = await bodyRepository.getBodyLatest();
      expect(body, equals(Body.empty));
    });

    test('getWeightLastest return null on success and isEmpty', () async {
      final weight = await bodyRepository.getWeightLatest();
      expect(weight, equals(null));
    });

    test('getBodyList return ListEmpty on success and isEmpty', () async {
      final bodyList = await bodyRepository.getBodyList();
      expect(bodyList, equals(List.empty()));
    });

    test('getWeightList return ListEmpty on success and isEmpty', () async {
      final weightList = await bodyRepository.getWeightList();
      expect(weightList, equals(List.empty()));
    });
  });
}
