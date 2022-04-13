import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuth extends Mock implements MockFirebaseAuth {}

class MockFacebookAuth extends Mock implements FacebookAuth {}

class MockAuthProviderManager extends Mock implements AuthProviderManager {}

class MockGoogle extends Mock implements GoogleSignIn {}

void main() {
  group('AuthenRepository', () {
    late AuthenRepository authenRepository;
    late AuthenRepository auth;
    late MockGoogleSignIn googleSignIn;
    late MockFirebaseAuth firebaseAuth;
    late MockAuth mockAuth;
    late MockFacebookAuth mockFacebookAuth;
    late MockAuthProviderManager authProviderManager;
    late MockGoogle mockGoogle;
    final user = MockUser(email: 'user001@email.com');
    final userModel = User(
        uid: 'some_random_id', email: 'user001@email.com', emailVerified: true);
    setUp(() {
      googleSignIn = MockGoogleSignIn();
      firebaseAuth = MockFirebaseAuth(mockUser: user);
      mockAuth = MockAuth();
      mockGoogle = MockGoogle();
      mockFacebookAuth = MockFacebookAuth();
      authProviderManager = MockAuthProviderManager();
      authenRepository = AuthenRepository(
          firebaseAuth: firebaseAuth,
          googleSignIn: googleSignIn,
          facebookAuth: mockFacebookAuth,
          authProviderManager: authProviderManager);
      auth = AuthenRepository(
          firebaseAuth: mockAuth,
          googleSignIn: mockGoogle,
          facebookAuth: mockFacebookAuth,
          authProviderManager: authProviderManager);
    });

    group('signup', () {
      test('with email and password success', () async {
        try {
          authenRepository.signUp(
              email: 'user001@email.com', password: 'password');
        } catch (_) {}
        await authenRepository.user.isEmpty;
        expect(await authenRepository.user.first,
            userModel.copyWith(uid: 'mock_uid', name: 'Mock User'));
      });

      test('throws when fail', () async {
        when(() => mockAuth.createUserWithEmailAndPassword(
            email: 'email', password: 'password')).thenThrow(Exception());
        expect(
            () async => await auth.signUp(email: 'email', password: 'password'),
            throwsA(isA<SignUpFailure>()));
      });
    });

    group('login', () {
      test('with email and password return user on success', () async {
        try {
          await authenRepository.logInWithEmailAndPassword(
              email: 'user001@email.com', password: 'password');
        } catch (_) {}
        await authenRepository.user.isEmpty;
        expect(await authenRepository.user.first, userModel);
      });

      test('with email and password throws when fail', () {
        when(() => mockAuth.signInWithEmailAndPassword(
            email: 'email', password: 'password')).thenThrow(Exception());
        expect(
            () async => await auth.logInWithEmailAndPassword(
                email: 'email', password: 'password'),
            throwsA(isA<LogInWithEmailAndPasswordFailure>()));
      });

      test('with google return user on success', () async {
        try {
          await authenRepository.logInWithGoogle();
        } catch (_) {}
        await authenRepository.user.isEmpty;
        expect(await authenRepository.user.first, userModel);
      });

      test('with google throws when fail', () {
        when(() => mockAuth.signInWithCredential(any())).thenThrow(Exception());
        expect(() async => await auth.logInWithGoogle(),
            throwsA(isA<LogInWithGoogleFailure>()));
      });

      test('with facebook return user on success', () async {
        when(() => mockFacebookAuth.login()).thenAnswer((_) async =>
            LoginResult(
                status: LoginStatus.success,
                accessToken: AccessToken(
                    applicationId: '',
                    declinedPermissions: [''],
                    grantedPermissions: [''],
                    token: 'token',
                    expires: DateTime.now(),
                    lastRefresh: DateTime.now(),
                    userId: '',
                    isExpired: false)));
        when(() => authProviderManager.getFacebookOAuthCredential(any()))
            .thenAnswer((invocation) => firebase_auth.OAuthCredential(
                providerId: 'providerId', signInMethod: 'signInMethod'));
        try {
          await authenRepository.logInWithFacebook();
        } catch (_) {}
        await authenRepository.user.isEmpty;
        expect(await authenRepository.user.first, userModel);
      });

      test('with facebook throws when fail', () {
        when(() => mockAuth.signInWithCredential(any()))
            .thenThrow(LogInWithFacebookFailure());
        when(() => mockFacebookAuth.login()).thenAnswer((_) async =>
            LoginResult(
                status: LoginStatus.success,
                accessToken: AccessToken(
                    applicationId: '',
                    declinedPermissions: [''],
                    grantedPermissions: [''],
                    token: 'token',
                    expires: DateTime.now(),
                    lastRefresh: DateTime.now(),
                    userId: '',
                    isExpired: false)));
        when(() => authProviderManager.getFacebookOAuthCredential(any()))
            .thenAnswer((invocation) => firebase_auth.OAuthCredential(
                providerId: 'providerId', signInMethod: 'signInMethod'));
        expect(() => auth.logInWithFacebook(),
            throwsA(isA<LogInWithFacebookFailure>()));
      });
    });

    test('calls sendForgetPasswordEmail', () async {
      try {
        await auth.sendForgetPasswordEmail('email');
      } catch (_) {}
      verify(() => mockAuth.sendPasswordResetEmail(email: 'email')).called(1);
    });

    test('sendForgetPasswordEmail throws when fail', () {
      when(() => mockAuth.sendPasswordResetEmail(email: 'email'))
          .thenThrow(Exception());
      expect(() async => await auth.sendForgetPasswordEmail('email'),
          throwsA(isA<Exception>()));
    });

    test('calls sendVerifyEmail', () async {
      when(() => mockAuth.currentUser).thenReturn(user);
      try {
        await auth.sendVerifyEmail();
      } catch (_) {}
      verify(() => mockAuth.currentUser!.sendEmailVerification()).called(1);
    });

    test('sendVerifyEmail throws when fail', () async {
      when(() => mockAuth.currentUser!.sendEmailVerification())
          .thenThrow(Exception());
      expect(() => auth.sendVerifyEmail(), throwsA(isA<Exception>()));
    });

    test('calls logout success when login with email and password', () async {
      try {
        await authenRepository.logInWithEmailAndPassword(
            email: 'email', password: 'password');
        await authenRepository.user.isEmpty;
      } catch (_) {}
      expect(await authenRepository.user.first, userModel);
      try {
        await authenRepository.logOut();
      } catch (_) {}
      expect(await authenRepository.user.first, User.empty);
    });

    test('calls logout success when login with google', () async {
      try {
        await authenRepository.logInWithGoogle();
        await authenRepository.user.isEmpty;
      } catch (_) {}
      expect(await authenRepository.user.first, userModel);
      try {
        await authenRepository.logOut();
      } catch (_) {}
      expect(await authenRepository.user.first, User.empty);
    });

    test('calls logout success when login with facebook', () async {
      when(() => mockFacebookAuth.login()).thenAnswer((_) async => LoginResult(
          status: LoginStatus.success,
          accessToken: AccessToken(
              applicationId: '',
              declinedPermissions: [''],
              grantedPermissions: [''],
              token: 'token',
              expires: DateTime.now(),
              lastRefresh: DateTime.now(),
              userId: '',
              isExpired: false)));
      when(() => authProviderManager.getFacebookOAuthCredential(any()))
          .thenAnswer((invocation) => firebase_auth.OAuthCredential(
              providerId: 'providerId', signInMethod: 'signInMethod'));
      try {
        await authenRepository.logInWithFacebook();
        await authenRepository.user.isEmpty;
      } catch (_) {}
      expect(await authenRepository.user.first, userModel);
      try {
        await authenRepository.logOut();
      } catch (_) {}
      expect(await authenRepository.user.first, User.empty);
    });

    test('logout throws when fail', () {
      when(() => mockAuth.signOut()).thenThrow(LogOutFailure());
      expect(() => auth.logOut(), throwsA(isA<LogOutFailure>()));
    });

    test('calls deleteUser success', () async {
      try {
        await auth.deleteUser('password');
      } catch (_) {}
      verify(() => mockAuth.currentUser!.delete()).called(1);
    });

    test('deleteUser throws when fail', () {
      when(() => mockAuth.currentUser!.delete()).thenThrow(DeleteUserFailure());
      expect(
          () => auth.deleteUser('password'), throwsA(isA<DeleteUserFailure>()));
    });
  });
}
