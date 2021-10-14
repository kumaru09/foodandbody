import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/app.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/screens/login/login.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

class MockAuthenRepository extends Mock implements AuthenRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

void main() {
  group('App', () {
    late AuthenRepository authenRepository;
    late UserRepository userRepository;
    late PlanRepository planRepository;
    late User user;
    late PlanBloc planBloc;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<PlanEvent>(FakePlanEvent());
      registerFallbackValue<PlanState>(FakePlanState());
      HttpOverrides.global = null;
    });

    setUp(() {
      userRepository = MockUserRepository();
      authenRepository = MockAuthenRepository();
      planRepository = MockPlanRepository();
      user = MockUser();
      planBloc = MockPlanBloc();
      when(() => authenRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.email).thenReturn('test@gmail.com');
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(RepositoryProvider.value(
          value: planRepository,
          child: App(
            authenRepository: authenRepository,
            userRepository: userRepository,
          )));
      // await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AuthenRepository authenRepository;
    late UserRepository userRepository;
    late PlanRepository planRepository;
    late AppBloc appBloc;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      HttpOverrides.global = null;
    });

    setUp(() {
      authenRepository = MockAuthenRepository();
      userRepository = MockUserRepository();
      planRepository = MockPlanRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets(
        'navigates to IntialPage when authenticated but not found userInfo',
        (tester) async {
      final user = MockUser();
      when(() => user.info).thenReturn(null);
      when(() => appBloc.state).thenReturn(AppState.initialize(user));
      await tester.pumpWidget(RepositoryProvider.value(
        value: userRepository,
        child: MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: const AppView(),
          ),
        ),
      ));
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: planRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(Home), findsOneWidget);
    });
  });
}
