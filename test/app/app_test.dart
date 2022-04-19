import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/app.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/login/login.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:foodandbody/screens/register/verify_email.dart';
import 'package:foodandbody/services/arcore_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class MockUser extends Mock implements User {}

class MockInfo extends Mock implements Info {}

class MockARCoreService extends Mock implements ARCoreService {}

class MockAuthenRepository extends Mock implements AuthenRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {}

class FakeCameraEvent extends Fake implements CameraEvent {}

class FakeCameraState extends Fake implements CameraState {}

typedef Callback(MethodCall call);

setupCloudFirestoreMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
            'storageBucket': 'myapp.appspot.com',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

void main() {
  group('App', () {
    late AuthenRepository authenRepository;
    late UserRepository userRepository;
    late ARCoreService arCoreService;
    late User user;

    setupCloudFirestoreMocks();

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      HttpOverrides.global = null;
    });

    setUp(() async {
      userRepository = MockUserRepository();
      authenRepository = MockAuthenRepository();
      arCoreService = MockARCoreService();
      user = MockUser();
      when(() => authenRepository.user).thenAnswer((_) => Stream.value(user));
      when(() => authenRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.emailVerified).thenReturn(false);
      when(() => user.email).thenReturn('test@gmail.com');
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenRepository),
            RepositoryProvider.value(value: userRepository),
          ],
          child: App(
            authenRepository: authenRepository,
            userRepository: userRepository,
            arCoreService: arCoreService,
          ),
        ),
      );
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AuthenRepository authenRepository;
    late UserRepository userRepository;
    late AppBloc appBloc;
    late CameraBloc cameraBloc;
    final info = MockInfo();

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<CameraEvent>(FakeCameraEvent());
      registerFallbackValue<CameraState>(FakeCameraState());
      HttpOverrides.global = null;
    });

    setUp(() {
      authenRepository = MockAuthenRepository();
      userRepository = MockUserRepository();
      appBloc = MockAppBloc();
      cameraBloc = MockCameraBloc();
      when(() => userRepository.getInfo())
          .thenAnswer((_) => Future.value(info));
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenRepository),
            RepositoryProvider.value(value: userRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: appBloc),
              BlocProvider.value(value: cameraBloc),
            ],
            child: AppView(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets(
        'navigates to VerifyEmail when authenticated but not verify email',
        (tester) async {
      final user = MockUser();
      await Firebase.initializeApp();
      when(() => appBloc.state).thenReturn(AppState.notverified(user));
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenRepository),
            RepositoryProvider.value(value: userRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: appBloc),
              BlocProvider.value(value: cameraBloc),
            ],
            child: AppView(),
          ),
        ),
      );
      // await tester.pumpAndSettle();
      expect(find.byType(VerifyEmail), findsOneWidget);
    });

    testWidgets('navigates to MainScreen when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenRepository),
            RepositoryProvider.value(value: userRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: appBloc),
              BlocProvider.value(value: cameraBloc),
            ],
            child: AppView(),
          ),
        ),
      );
      expect(find.byType(MainScreen), findsOneWidget);
    });
  });
}
