import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/widget/nutrient_detail.dart';

void main() {
  group("NutrientDetail Class", () {
    testWidgets("show data correctly", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: NutrientDetail(
              label: 'โปรตีน',
              value: '34 กรัม',
            ),
          ),
        ),
      ));
      expect(find.text('โปรตีน'), findsOneWidget);
      expect(find.text('34 กรัม'), findsOneWidget);
    });
  });
}
