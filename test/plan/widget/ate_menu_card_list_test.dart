import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/screens/plan/widget/ate_menu_card_list.dart';
import 'package:foodandbody/theme.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockPlan extends Mock implements History {}

void main() {
  //widget
  const ateMenuCardListKey = Key("ate_menu_card_list");
  late History plan;

  setUp(() {
    plan = MockPlan();
  });
  group("Ate Menu Card", () {
    testWidgets("can render", (tester) async {
      final ateMenuCardListWidget = AteMenuCardList(plan);
      final String menu = "ข้าวผัดกระเทียม";
      final double calories = 643.8;
      final String time = DateFormat.Hm().format(DateTime.now());
      ateMenuCardListWidget.ateMenu = [
        Menu(
            name: menu,
            calories: calories,
            timestamp: Timestamp.fromDate(DateTime.now()))
      ];
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: ateMenuCardListWidget,
        ),
      ));
      expect(find.byKey(ateMenuCardListKey), findsOneWidget);
      expect(find.text(menu), findsOneWidget);
      expect(find.text(calories.round().toString()), findsOneWidget);
      expect(find.text(time), findsOneWidget);
      expect(find.text("แคล"), findsOneWidget);
    });
  });
}
