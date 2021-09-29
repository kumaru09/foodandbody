import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/plan/widget/ate_menu_card_list.dart';
import 'package:foodandbody/theme.dart';

void main() {
  //widget
  const ateMenuCardListKey = Key("ate_menu_card_list");
  group("Ate Menu Card", () {
    testWidgets("can render", (tester) async {
      final ateMenuCardListWidget = AteMenuCardList();
      final String menu = "ข้าวผัดกระเทียม";
      final double calories = 643.8;
      final String time = "12.30";
      ateMenuCardListWidget.ateMenu = [AteMenuList(menu: menu, calories: calories, time: time)];
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
