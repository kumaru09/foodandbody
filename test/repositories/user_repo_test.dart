import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCloud extends Mock implements FirebaseFirestore {}

class MockAuth extends Mock implements MockFirebaseAuth {}

class MockAuthProviderManager extends Mock implements AuthProviderManager {}

class MockStorage extends Mock implements FirebaseStorage {}

class MockUploadManager extends Mock implements UploadManager {}

class FakeTask extends Fake implements TaskSnapshot {}

void main() {
  late UserRepository userRepository;
  late UserRepository mockUserRepository;
  late FakeFirebaseFirestore instance;
  late MockFirebaseStorage storage;
  late MockCloud mockCloud;
  late MockAuth mockAuth;
  late MockAuthProviderManager authProviderManager;
  late MockUploadManager mockUploadManager;
  final user = MockUser(uid: 'uid');
  final firebaseAuth = MockFirebaseAuth(mockUser: user);
  final cache = InfoCache();
  final info = Info(
      name: 'name',
      gender: 'M',
      goal: 2000,
      goalNutrient: Nutrient(carb: 120, protein: 100, fat: 45),
      photoUrl: "",
      height: 178,
      weight: 75,
      birthDate: Timestamp.fromDate(DateTime(2000, 1, 1)));

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(File('img.png'));
    registerFallbackValue(FakeTask());
    firebaseAuth.signInWithEmailAndPassword(
        email: 'email', password: 'password');
  });
  group('UserRepository', () {
    setUp(() async {
      authProviderManager = MockAuthProviderManager();
      mockCloud = MockCloud();
      mockAuth = MockAuth();
      instance = FakeFirebaseFirestore();
      storage = MockFirebaseStorage();
      mockUploadManager = MockUploadManager();
      userRepository = UserRepository(
          cache: cache,
          firebaseAuth: firebaseAuth,
          firebaseFirestore: instance,
          firebaseStorage: storage);
      mockUserRepository = UserRepository(
          cache: cache,
          firebaseAuth: mockAuth,
          firebaseFirestore: mockCloud,
          firebaseStorage: storage,
          authProviderManager: authProviderManager,
          uploadManager: mockUploadManager);
    });

    test('addUserInfo', () async {
      await userRepository.addUserInfo(info);
      final user = await userRepository.getInfo();
      final cacheInfo = userRepository.cache.get();
      expect(user!.name, equals(info.name));
      expect(cacheInfo!.name, equals(info.name));
    });

    test('getInfo return null on success when doc isEmpty', () async {
      final user = await userRepository.getInfo();
      expect(user, equals(null));
    });

    test('getInfo return info on success when doc isNotEmpty', () async {
      await userRepository.addUserInfo(info);
      final user = await userRepository.getInfo();
      expect(user!.name, equals(info.name));
    });

    test('getInfo return info from cache', () async {
      await userRepository.addUserInfo(info);
      final user = await userRepository.getInfo(true);
      expect(user!.name, equals(info.name));
    });

    test('getInfo throws when fail', () async {
      when(() => mockCloud.doc(any()).get()).thenThrow(Exception());
      expect(() async => await mockUserRepository.getInfo(),
          throwsA(isA<Exception>()));
    });

    test('updateInfo success', () async {
      await userRepository.addUserInfo(info);
      var user = await userRepository.getInfo();
      expect(user!.name, equals('name'));
      await userRepository.updateInfo(Info(name: 'new'));
      user = await userRepository.getInfo();
      expect(user!.name, equals('new'));
    });

    test('updateInfo throws when fail', () async {
      when(() => mockCloud.doc(any()).update(any())).thenThrow(Exception());
      expect(() async => await mockUserRepository.updateInfo(info),
          throwsA(isA<UpdateInfoFailure>()));
    });

    test('updateGoalInfo success', () async {
      await userRepository.addUserInfo(info);
      var user = await userRepository.getInfo();
      expect(user!.goal, equals(2000));
      await userRepository.updateGoalInfo(1200);
      user = await userRepository.getInfo();
      expect(user!.goal, equals(1200));
    });

    test('updateGoalInfo throws when fail', () async {
      when(() => mockCloud.doc(any()).update(any())).thenThrow(Exception());
      expect(() async => await mockUserRepository.updateInfo(info),
          throwsA(isA<Exception>()));
    });

    test('updateHeightInfo success', () async {
      await userRepository.addUserInfo(info);
      var user = await userRepository.getInfo();
      expect(user!.height, equals(178));
      await userRepository.updateHeightInfo(180);
      user = await userRepository.getInfo();
      expect(user!.height, equals(180));
    });

    test('updateHeightInfo throws when fail', () async {
      when(() => mockCloud.doc(any()).update(any())).thenThrow(Exception());
      expect(() async => await mockUserRepository.updateHeightInfo(180),
          throwsA(isA<Exception>()));
    });

    test('updateWeigthInfo success', () async {
      await userRepository.addUserInfo(info);
      var user = await userRepository.getInfo();
      expect(user!.weight, equals(75));
      await userRepository.updateWeightInfo(80);
      user = await userRepository.getInfo();
      expect(user!.weight, equals(80));
    });

    test('updateWeigthInfo throws when fail', () async {
      when(() => mockCloud.doc(any()).update(any())).thenThrow(Exception());
      expect(() async => await mockUserRepository.updateWeightInfo(80),
          throwsA(isA<Exception>()));
    });

    test('updatePassword success', () async {
      when(() => mockAuth.currentUser)
          .thenAnswer(((invocation) => MockUser(uid: 'uid', email: 'email')));
      when(() => authProviderManager.credential(
              email: 'email', oldPassword: 'password'))
          .thenAnswer((invocation) => firebase_auth.AuthCredential(
              providerId: 'providerId', signInMethod: 'signInMethod'));
      await mockUserRepository.updatePassword('newPassword', 'password');
    });

    test('updatePassword throws when fail', () async {
      when(() => mockAuth.currentUser)
          .thenAnswer(((invocation) => MockUser(uid: 'uid', email: 'email')));
      when(() => authProviderManager.credential(
              email: 'email', oldPassword: 'password'))
          .thenAnswer((invocation) => firebase_auth.AuthCredential(
              providerId: 'providerId', signInMethod: 'signInMethod'));
      when(() => mockAuth.currentUser!.updatePassword('newPassword'))
          .thenThrow(Exception());
      expect(
          () async => await mockUserRepository.updatePassword(
              'newPassword', 'password'),
          throwsA(isA<UpdatePasswordFaliure>()));
    });

    test('uploadProfilePic return url on success', () async {
      final uri =
          'https://firebasestorage.googleapis.com/v0/b/foodbody-bnn.appspot.com/o/users%2Fprofile%2F1649087144.jpg?alt=media&token=524c92fe-fbef-440e-964e-cccf64e0108d';
      when(() => mockUploadManager.getDownloadURL(any()))
          .thenAnswer((_) async => uri);
      final file = File('img.png');
      final url = await mockUserRepository.uploadProfilePic(file);
      expect(url, equals(Uri.parse(uri)));
    });

    test('uploadProfilePic throws when fail', () async {
      when(() => mockUploadManager.getDownloadURL(any()))
          .thenThrow(Exception());
      final file = File('img.png');
      expect(() async => await mockUserRepository.uploadProfilePic(file),
          throwsA(isA<UploadProfilePicFailure>()));
    });
  });
}
