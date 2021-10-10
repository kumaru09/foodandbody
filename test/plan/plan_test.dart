import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/plan.dart';
import 'package:mocktail/mocktail.dart';

/*
  TODO: test "pressed add menu button"
  TODO: test "pressed plan menu card" 
*/
class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

class MockPlan extends Mock implements History {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockUser extends Mock implements User {}

void main() {
  //widget
  const circularCalAndInfoKey = Key("circular_cal_and_info");
  const nutrientInfoKey = Key("nutrient_info");
  const ateMenuCardListKey = Key("ate_menu_card_list");
  const editGoalDialogKey = Key("edit_goal_dialog");

  //button
  const editGoalButtonKey = Key("edit_goal_button");
  const addMenuButtonKey = Key("add_menu_button");

  late PlanBloc planBloc;
  late History plan;
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
    plan = MockPlan();
    user = MockUser();
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
  });
  group("Plan Page", () {
    group("can render", () {
      testWidgets("calories and nutrient info card", (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(providers: [
          BlocProvider.value(value: planBloc),
          BlocProvider.value(value: appBloc)
        ], child: Plan())));
        expect(find.byKey(circularCalAndInfoKey), findsOneWidget);
        expect(find.byKey(nutrientInfoKey), findsOneWidget);
      }); //test "calories and nutrient info card"

      testWidgets("plan menu card", (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(providers: [
          BlocProvider.value(value: planBloc),
          BlocProvider.value(value: appBloc)
        ], child: Plan())));
        expect(find.byType(AnimatedList), findsOneWidget);
      }); //test "plan menu card"

      testWidgets("add menu button", (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(providers: [
          BlocProvider.value(value: planBloc),
          BlocProvider.value(value: appBloc)
        ], child: Plan())));
        expect(find.byKey(addMenuButtonKey), findsOneWidget);
      }); //test "add menu button"

      testWidgets("ate menu card list", (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(providers: [
          BlocProvider.value(value: planBloc),
          BlocProvider.value(value: appBloc)
        ], child: Plan())));
        expect(find.byKey(ateMenuCardListKey), findsOneWidget);
      }); //test "ate menu card list"
    }); //group "can render"

    group("when pressed", () {
      testWidgets("edit goal button", (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(providers: [
          BlocProvider.value(value: planBloc),
          BlocProvider.value(value: appBloc)
        ], child: Plan())));
        await tester.tap(find.byKey(editGoalButtonKey));
        await tester.pump();
        expect(find.byKey(editGoalDialogKey), findsOneWidget);
      }); //test "edit goal button"
    }); //group "when pressed"
  }); //group "Plan Page"
}
