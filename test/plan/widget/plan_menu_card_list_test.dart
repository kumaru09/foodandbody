import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/widget/plan_menu_card_list.dart';
import 'package:foodandbody/theme.dart';
import 'package:mocktail/mocktail.dart';

class MockPlan extends Mock implements History {}

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

void main() {
  final Menu mockMenu = Menu(
    name: 'อาหาร',
    calories: 300,
    protein: 30,
    carb: 30,
    fat: 10,
    serve: 1,
    volumn: 1,
  );
  final List<Menu> mockMenuList = [mockMenu];
  final History plan = History(Timestamp.now(), menuList: mockMenuList);

  late PlanBloc planBloc;

  setUp(() {
    planBloc = MockPlanBloc();
    when(() => planBloc
            .add(DeleteMenu(name: mockMenu.name, volume: mockMenu.volumn)))
        .thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue<PlanEvent>(FakePlanEvent());
    registerFallbackValue<PlanState>(FakePlanState());
  });

  group("Plan Menu Card List", () {
    testWidgets("can render", (tester) async {
      final planMenuCard = PlanMenuCardList(plan);
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: planMenuCard,
        ),
      ));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text(mockMenu.name), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    }); //test "can render"

    testWidgets("render new plan menu list when pressed delete icon", (tester) async {
      final planMenuCard = PlanMenuCardList(plan);
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: BlocProvider.value(
            value: planBloc,
            child: Scaffold(body: planMenuCard),
          )));
      final countCardList = planMenuCard.createState().planMenu.length;
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();
      expect(find.byType(SizeTransition), findsNWidgets(countCardList - 1));
    }); //test "when pressed delete icon"
  }); //group "Plan Menu Card List"
}
