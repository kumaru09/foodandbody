import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/plan/plan.dart';

/*
  TODO: test "pressed add menu button"
  TODO: test "pressed plan menu card" 
*/
void main() {
  //widget
  const circularCalAndInfoKey = Key("circular_cal_and_info");
  const nutrientInfoKey = Key("nutrient_info");
  const ateMenuCardListKey = Key("ate_menu_card_list");
  const editGoalDialogKey = Key("edit_goal_dialog");

  //button
  const editGoalButtonKey = Key("edit_goal_button");
  const addMenuButtonKey = Key("add_menu_button");

  group("Plan Page", () {
    group("can render", () {
      testWidgets("calories and nutrient info card", (tester) async {
        await tester.pumpWidget(MaterialApp(home: Plan()));
        expect(find.byKey(circularCalAndInfoKey), findsOneWidget);
        expect(find.byKey(nutrientInfoKey), findsOneWidget);
      }); //test "calories and nutrient info card"

      testWidgets("plan menu card", (tester) async {
        await tester.pumpWidget(MaterialApp(home: Plan()));
        expect(find.byType(AnimatedList), findsOneWidget);
      }); //test "plan menu card"

      testWidgets("add menu button", (tester) async {
        await tester.pumpWidget(MaterialApp(home: Plan()));
        expect(find.byKey(addMenuButtonKey), findsOneWidget);
      }); //test "add menu button"

      testWidgets("ate menu card list", (tester) async {
        await tester.pumpWidget(MaterialApp(home: Plan()));
        expect(find.byKey(ateMenuCardListKey), findsOneWidget);
      }); //test "ate menu card list"
    }); //group "can render"

    group("when pressed", () {
      testWidgets("edit goal button", (tester) async {
        await tester.pumpWidget(MaterialApp(home: Plan()));
        await tester.tap(find.byKey(editGoalButtonKey));
        await tester.pump();
        expect(find.byKey(editGoalDialogKey), findsOneWidget);
      }); //test "edit goal button"
    }); //group "when pressed"
  }); //group "Plan Page"
}
