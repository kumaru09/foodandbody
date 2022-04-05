import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/plan.dart';
import 'package:foodandbody/screens/plan/widget/plan_menu_card_list.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

class MockPlan extends Mock implements History {}

class MockPlanRepository extends Mock implements PlanRepository {}

void main() {
  //widget
  const circularCalAndInfoKey = Key("circular_cal_and_info");
  const nutrientInfoKey = Key("nutrient_info");
  const ateMenuCardListKey = Key("ate_menu_card_list");
  const addMenuButtonKey = Key("add_menu_button");

  const String name = 'อาหาร';
  const int weight = 50;
  const String goal = '1600';
  const Calory validGoal = Calory.dirty(goal);
  final List<Menu> mockMenuList = [
    Menu(
        name: name,
        calories: 300,
        protein: 30,
        carb: 30,
        fat: 10,
        serve: 1,
        volumn: 1)
  ];
  final History mockPlan = History(Timestamp.now(), menuList: mockMenuList);
  const Nutrient mockNutrient = Nutrient(protein: 100, carb: 100, fat: 100);
  final Info mockInfo = Info(
      name: 'user',
      goal: int.parse(goal),
      weight: weight,
      height: 160,
      gender: 'F',
      goalNutrient: mockNutrient);

  late PlanBloc planBloc;

  setUpAll(() {
    registerFallbackValue<PlanEvent>(FakePlanEvent());
    registerFallbackValue<PlanState>(FakePlanState());
  });

  setUp(() {
    planBloc = MockPlanBloc();
    when(() => planBloc.state).thenReturn(PlanState(
        status: PlanStatus.success,
        plan: mockPlan,
        info: mockInfo,
        goal: validGoal,
        exerciseStatus: FormzStatus.submissionSuccess));
  });
  group("Plan Page", () {
    group("render", () {
      testWidgets("calories and nutrient info card when PlanStatus is success",
          (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: planBloc,
            child: Plan(),
          ),
        ));
        expect(find.byKey(circularCalAndInfoKey), findsOneWidget);
        expect(find.byKey(nutrientInfoKey), findsOneWidget);
      }); //test "calories and nutrient info card"

      testWidgets("plan menu card when PlanStatus is success", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: planBloc,
            child: Plan(),
          ),
        ));
        expect(find.byType(PlanMenuCardList), findsOneWidget);
      }); //test "plan menu card"

      testWidgets("add menu button when PlanStatus is sucess", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: planBloc,
            child: Plan(),
          ),
        ));
        expect(find.byKey(addMenuButtonKey), findsOneWidget);
      }); //test "add menu button"

      testWidgets("ate menu card list when PlanStatus is success",
          (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: planBloc,
            child: Plan(),
          ),
        ));
        expect(find.byKey(ateMenuCardListKey), findsOneWidget);
      }); //test "ate menu card list"

      testWidgets("CircularProgressIndicator when PlanStatus is loading",
          (tester) async {
        when(() => planBloc.state)
            .thenReturn(PlanState(status: PlanStatus.loading));
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: planBloc,
            child: Plan(),
          ),
        ));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets("failure widget when PlanStatus is failure", (tester) async {
        when(() => planBloc.state)
            .thenReturn(PlanState(status: PlanStatus.failure));
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: planBloc,
            child: Plan(),
          ),
        ));
        expect(find.byType(Image), findsOneWidget);
        expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
        expect(find.text('ลองอีกครั้ง'), findsOneWidget);
      });

      // testWidgets("AlertDialog when goalStatus is failure", (tester) async {
      //   when(() => planBloc.state).thenReturn(PlanState(
      //     goalStatus: FormzStatus.submissionFailure,
      //     isDeleteMenu: false,
      //     status: PlanStatus.success,
      //     plan: mockPlan,
      //     info: mockInfo,
      //     goal: validGoal,
      //     exerciseStatus: FormzStatus.submissionSuccess,
      //   ));
      //   await tester.pumpWidget(MaterialApp(
      //     home: BlocProvider.value(
      //       value: planBloc,
      //       child: Plan(),
      //     ),
      //   ));
      //   await tester.pump();
      //   expect(find.byType(AlertDialog), findsOneWidget);
      //   expect(find.byIcon(Icons.report), findsOneWidget);
      //   expect(find.text('แก้ไขเป้าหมายแคลอรีไม่สำเร็จ'), findsOneWidget);
      //   expect(find.text('กรุณาลองอีกครั้ง'), findsOneWidget);
      // });

      // testWidgets("AlertDialog when deleteMenuStatus is failure", (tester) async {
      //   when(() => planBloc.state).thenReturn(PlanState(
      //     deleteMenuStatus: DeleteMenuStatus.failure,
      //     isDeleteMenu: true,
      //     status: PlanStatus.success,
      //     plan: mockPlan,
      //     info: mockInfo,
      //     goal: validGoal,
      //     exerciseStatus: FormzStatus.submissionSuccess,
      //   ));
      //   await tester.pumpWidget(MaterialApp(
      //     home: BlocProvider.value(
      //       value: planBloc,
      //       child: Plan(),
      //     ),
      //   ));
      //   await tester.pump();
      //   expect(find.byType(AlertDialog), findsOneWidget);
      //   expect(find.byIcon(Icons.report), findsOneWidget);
      //   expect(find.text('ลบเมนูไม่สำเร็จ'), findsOneWidget);
      //   expect(find.text('กรุณาลองอีกครั้ง'), findsOneWidget);
      // });
    }); //group "render"
  }); //group "Plan Page"
}
