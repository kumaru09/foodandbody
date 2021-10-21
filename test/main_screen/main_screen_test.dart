import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/plan.dart';
import 'package:foodandbody/theme.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:foodandbody/models/history.dart' as foodhistories;

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

class MockPlan extends Mock implements foodhistories.History {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockUser extends Mock implements User {}

void main() {
  const bottomAppBarKey = Key('bottom_app_bar');
  const homeButtonKey = Key('home_button');
  const planButtonKey = Key('plan_button');
  const cameraButtonKey = Key('camera_floating_button');
  const bodyButtonKey = Key('body_button');
  const historyButtonKey = Key('history_button');
  late PlanRepository planRepository;
  late foodhistories.History plan;
  late PlanBloc planBloc;
  late AppBloc appBloc;
  late User user;

  setUpAll(() {
    registerFallbackValue<PlanEvent>(FakePlanEvent());
    registerFallbackValue<PlanState>(FakePlanState());
    registerFallbackValue<AppEvent>(FakeAppEvent());
    registerFallbackValue<AppState>(FakeAppState());
  });

  setUp(() {
    planBloc = MockPlanBloc();
    appBloc = MockAppBloc();
    user = MockUser();
    plan = MockPlan();
    when(() => planBloc.state).thenReturn(PlanLoaded(plan));
    when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    when(() => plan.menuList)
        .thenReturn(<Menu>[Menu(name: 'test', calories: 100)]);
    when(() => plan.totalNutrientList)
        .thenReturn(Nutrient().copyWith(protein: 120, carb: 80, fat: 30));
    when(() => user.info).thenReturn(Info(
        goalNutrient: Nutrient().copyWith(protein: 180, carb: 145, fat: 75),
        goal: 2200));
    when(() => plan.planNutrientList)
        .thenReturn(Nutrient().copyWith(protein: 130, carb: 95, fat: 40));
    when(() => plan.totalCal).thenReturn(1000);
    planRepository = MockPlanRepository();
    when(() => planRepository.getPlanById())
        .thenAnswer((_) => Future(() => plan));
  });

  group("Main Screen", () {
    test("has a page", () {
      expect(MainScreen.page(), isA<MaterialPage>());
    });

    testWidgets("has a bottom app bar", (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(RepositoryProvider.value(
            value: planRepository,
            child: MaterialApp(
              theme: AppTheme.themeData,
              home: Scaffold(
                  body: MainScreen(
                index: 4,
              )),
            )));
        expect(find.byKey(bottomAppBarKey), findsOneWidget);
        expect(find.byKey(homeButtonKey), findsOneWidget);
        expect(find.byKey(planButtonKey), findsOneWidget);
        expect(find.byKey(cameraButtonKey), findsOneWidget);
        expect(find.byKey(bodyButtonKey), findsOneWidget);
        expect(find.byKey(historyButtonKey), findsOneWidget);
      });
    });

    group("when pressed", () {
      testWidgets("home button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(RepositoryProvider.value(
              value: planRepository,
              child: MaterialApp(
                  theme: AppTheme.themeData,
                  home: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: planBloc),
                        BlocProvider.value(value: appBloc)
                      ],
                      child: Scaffold(
                          body: MainScreen(
                        index: 4,
                      ))))));
          await tester.tap(find.byKey(homeButtonKey));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          expect(find.byType(Home), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
        });
      });

      testWidgets("plan button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(RepositoryProvider.value(
              value: planRepository,
              child: MaterialApp(
                  theme: AppTheme.themeData,
                  home: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: planBloc),
                        BlocProvider.value(value: appBloc)
                      ],
                      child: Scaffold(
                          body: MainScreen(
                        index: 4,
                      ))))));
          await tester.tap(find.byKey(planButtonKey));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          expect(find.byType(Plan), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
        });
      });

      testWidgets("body button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(RepositoryProvider.value(
              value: planRepository,
              child: MaterialApp(
                  theme: AppTheme.themeData,
                  home: Scaffold(
                      body: MainScreen(
                    index: 4,
                  )))));
          await tester.tap(find.byKey(bodyButtonKey));
          await tester.pump();
          expect(find.byType(Body), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
        });
      });

      testWidgets("history button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(RepositoryProvider.value(
              value: planRepository,
              child: MaterialApp(
                  theme: AppTheme.themeData,
                  home: Scaffold(
                      body: MainScreen(
                    index: 4,
                  )))));
          await tester.tap(find.byKey(historyButtonKey));
          await tester.pump();
          expect(find.byType(History), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
        });
      });

      testWidgets("camera button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(RepositoryProvider.value(
              value: planRepository,
              child: MaterialApp(
                  theme: AppTheme.themeData,
                  home: Scaffold(
                      body: MainScreen(
                    index: 4,
                  )))));
          await tester.tap(find.byKey(cameraButtonKey));
          await tester.pumpAndSettle();
          expect(find.byKey(bottomAppBarKey), findsNothing);
          expect(find.byType(Camera), findsOneWidget);
        });
      });
    });
  });
}
