import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/plan/widget/plan_menu_card_list.dart';
import 'package:foodandbody/theme.dart';

void main() {
  group("Plan Menu Card List", () {
    testWidgets("can render", (tester) async {
      final planMenuCard = PlanMenuCardList();
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: planMenuCard,
        ),
      ));
      expect(find.byType(SizeTransition),
          findsNWidgets(planMenuCard.createState().planMenu.length));
    }); //test "can render"

    testWidgets("when pressed delete icon", (tester) async {
      final planMenuCard = PlanMenuCardList();
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData, home: Scaffold(body: planMenuCard)));
      final countCardList = planMenuCard.createState().planMenu.length;
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();
      expect(find.byType(SizeTransition), findsNWidgets(countCardList - 1));
    }); //test "when pressed delete icon"
  }); //group "Plan Menu Card List"
}
