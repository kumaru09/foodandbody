import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

Uri _menuUrl({required String path}) {
  return Uri.parse('https://foodandbody-api.azurewebsites.net/api/Menu/$path');
}

void main() {
  late PlanRepository planRepository;
  late FakeFirebaseFirestore instance;
  final user = MockUser(uid: 'uid');
  final firebaseAuth = MockFirebaseAuth(mockUser: user);
  final mockClient = MockClient();
  final exercise = ExerciseRepo(
      id: '1', name: 'run', min: 10, calory: 200, timestamp: Timestamp.now());

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
  });

  group('PlanRepository', () {
    setUp(() async {
      instance = FakeFirebaseFirestore();
      planRepository = PlanRepository(
          firebaseAuth: firebaseAuth,
          firebaseFirestore: instance,
          httpClient: mockClient);
      await planRepository.getPlanById();
    });

    test('addPlanMenu new menu but not eat', () async {
      await planRepository.addPlanMenu('กุ้งเผา', 100, 100, false);
      final menuList = await planRepository.getPlanById();
      expect(menuList.menuList.any((element) => element.name == 'กุ้งเผา'),
          equals(true));
    });

    test('addPlanMenu new menu eat now', () async {
      await planRepository.addPlanMenu('กุ้งเผา', 100, 100, true);
      final menuList = await planRepository.getPlanById();
      expect(menuList.menuList.any((element) => element.name == 'กุ้งเผา'),
          equals(true));
      expect(menuList.menuList.any((element) => element.timestamp != null),
          equals(true));
    });

    test('addPlanMenu update menu eat now from plan', () async {
      await planRepository.addPlanMenu('กุ้งเผา', 100, 100, false);
      await planRepository.addPlanMenu('กุ้งเผา', 100, 100, true);
      final menuList = await planRepository.getPlanById();
      expect(menuList.menuList.any((element) => element.timestamp != null),
          equals(true));
      expect(menuList.totalCal, equals(96));
      expect(menuList.menuList.any((element) => element.name == 'กุ้งเผา'),
          equals(true));
    });

    test('addPlanMenu update menu change volume eat now from plan', () async {
      await planRepository.addPlanMenu('กุ้งเผา', 100, 100, false);
      await planRepository.addPlanMenu('กุ้งเผา', 100, 200, true);
      final menuList = await planRepository.getPlanById();
      expect(menuList.menuList.any((element) => element.name == 'กุ้งเผา'),
          equals(true));
      expect(menuList.menuList.any((element) => element.timestamp != null),
          equals(true));
      expect(menuList.totalCal, equals(192));
    });

    test('addPlanMenu throws when get menu fail', () async {
      when(() => mockClient.get(_menuUrl(path: 'กุ้ง'))).thenThrow(Exception());
      expect(
          () async => await planRepository.addPlanMenu('กุ้ง', 100, 100, false),
          throwsA(isA<Exception>()));
    });

    test('deletePlan success', () async {
      await planRepository.addPlanMenu('กุ้งเผา', 100, 100, false);
      var menuList = await planRepository.getPlanById();
      expect(menuList.menuList.any((element) => element.name == 'กุ้งเผา'),
          equals(true));
      await planRepository.deletePlan('กุ้งเผา', 100);
      menuList = await planRepository.getPlanById();
      expect(menuList.menuList.any((element) => element.name == 'กุ้งเผา'),
          equals(false));
    });

    test('addWaterPlan success', () async {
      await planRepository.addWaterPlan(2);
      final water = await planRepository.getWaterPlan();
      expect(water, equals(2));
    });

    test('getWaterPlan return totalWater on success', () async {
      await planRepository.addWaterPlan(2);
      final water = await planRepository.getWaterPlan();
      expect(water, equals(2));
    });

    test('getWaterPlan return 0 on success', () async {
      final water = await planRepository.getWaterPlan();
      expect(water, equals(0));
    });

    test('addExercise success', () async {
      await planRepository.addExercise(exercise);
      final exerciseList = await planRepository.getExercise();
      expect(exerciseList.contains(exercise), equals(true));
    });

    test('getExercise return ListEmpty on success', () async {
      final exerciseList = await planRepository.getExercise();
      expect(exerciseList.isEmpty, equals(true));
    });

    test('getExercise return exerciseList on success', () async {
      await planRepository.addExercise(exercise);
      final exerciseList = await planRepository.getExercise();
      expect(exerciseList.contains(exercise), equals(true));
    });

    test('deleteExercise success', () async {
      await planRepository.addExercise(exercise);
      var exerciseList = await planRepository.getExercise();
      expect(exerciseList.contains(exercise), equals(true));
      await planRepository.deleteExercise(exercise);
      exerciseList = await planRepository.getExercise();
      expect(exerciseList.isEmpty, equals(true));
    });
  });

  group('PlanRepository', () {
    setUp(() async {
      instance = FakeFirebaseFirestore();
      planRepository = PlanRepository(
          firebaseAuth: firebaseAuth,
          firebaseFirestore: instance,
          httpClient: mockClient);
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
    });
    test('getPlanById return history on success and doc isEmpty', () async {
      final menuList = await planRepository.getPlanById();
      expect(menuList.date.seconds, equals(Timestamp.now().seconds));
    });

    test('getPlanById return history on success and doc isNotEmpty', () async {
      await planRepository.getPlanById();
      await planRepository.addPlanMenu('กุ้งเผา', 100, 100, false);
      final menuList = await planRepository.getPlanById();
      expect(menuList.date.seconds, equals(Timestamp.now().seconds));
      expect(menuList.menuList.any((element) => element.name == 'กุ้งเผา'),
          equals(true));
    });

    test('addWaterPlan throws when doc isEmpty', () {
      expect(() async => await planRepository.addExercise(exercise),
          throwsA(isA<Exception>()));
    });

    test('addExercise throws when doc isEmpty', () {
      expect(() async => await planRepository.addExercise(exercise),
          throwsA(isA<Exception>()));
    });

    test('deleteExercise throws when doc isEmpty', () {
      expect(() async => await planRepository.deleteExercise(exercise),
          throwsA(isA<Exception>()));
    });
  });
}
