import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/screens/home/circular_cal_indicator.dart';
import 'package:foodandbody/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  const homeCaloriesCircularKey = Key('home_calories_circular');
  const homeCaloriesDataColumnKey = Key('home_calories_data_column');
  const homeUserCaloriesInfoKey = Key('home_user_calories_info');

  final Timestamp mockDate = Timestamp.fromDate(DateTime.now());
  final History mockPlan = History(mockDate, totalCal: 1000);
  final History mockPlanEqual = History(mockDate, totalCal: 2000);
  final History mockPlanGrater = History(mockDate, totalCal: 3000);
  // final Info mockUser = Info(name: 'user', goal: 2000);
  final String mockGoal = "2000";

  group("Calories Circular Progress", () {
    testWidgets("can render", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CircularCalIndicator(mockPlan, mockGoal),
        ),
      ));
      expect(find.byKey(homeCaloriesCircularKey), findsOneWidget);
    }); //"can render"

    testWidgets("when total calories less than goal calories", (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(body: CircularCalIndicator(mockPlan, mockGoal)),
      ));
      var circularProgressFinder = find.byKey(homeCaloriesCircularKey);
      Column circularDataColumnFinder =
          tester.firstWidget(find.byKey(homeCaloriesDataColumnKey));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having(
              (t) => t.backgroundColor, "background color", Color(0xFFFFBB91)));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having(
              (t) => t.percent, "percent", mockPlan.totalCal / (int.parse(mockGoal).toDouble() + mockPlan.totalBurn)));
      expect(
          circularDataColumnFinder.children[0].toString(), contains("เหลือ"));
      expect(circularDataColumnFinder.children[1].toString(),
          contains("Color(0xffffffff)"));
    }); //"when total calories less than goal calories"

    testWidgets("when total calories equals goal calories", (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(body: CircularCalIndicator(mockPlanEqual, mockGoal)),
      ));
      var circularProgressFinder = find.byKey(homeCaloriesCircularKey);
      Column circularDataColumnFinder =
          tester.firstWidget(find.byKey(homeCaloriesDataColumnKey));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having(
              (t) => t.backgroundColor, "background color", Color(0xFFFFBB91)));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having(
              (t) => t.percent, "percent", mockPlanEqual.totalCal / (int.parse(mockGoal).toDouble() + mockPlanEqual.totalBurn)));
      expect(
          circularDataColumnFinder.children[0].toString(), contains("เหลือ"));
      expect(circularDataColumnFinder.children[1].toString(),
          contains("Color(0xffffffff)"));
    }); //"when total calories equals goal calories"

    testWidgets("when total calories greater than goal calories",
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: CircularCalIndicator(mockPlanGrater, mockGoal)
        ),
      ));
      var circularProgressFinder = find.byKey(homeCaloriesCircularKey);
      Column circularDataColumnFinder =
          tester.firstWidget(find.byKey(homeCaloriesDataColumnKey));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having(
              (t) => t.progressColor, "progress bar color", Color(0xFFFF4040)));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>().having(
              (t) => t.backgroundColor,
              "background color",
              AppTheme.themeData.indicatorColor.withOpacity(0.8)));
      expect(
          tester.widget(circularProgressFinder),
          isA<CircularPercentIndicator>()
              .having((t) => t.percent, "percent", 1));
      expect(circularDataColumnFinder.children[0].toString(),
          contains("กินเกินแล้ว"));
      expect(circularDataColumnFinder.children[1].toString(),
          contains("Color(0xffff4040)"));
    }); //"when total calories greater than goal calories"
  }); //group "Calories Circular Progress"

  group("User Calories Info", () {
    testWidgets("can render", (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: CircularCalIndicator(mockPlan, mockGoal),
        ),
      ));
      expect(find.byKey(homeUserCaloriesInfoKey), findsOneWidget);
      expect(find.text("เป้าหมาย"), findsOneWidget);
      expect(find.text("กินแล้ว"), findsOneWidget);
      expect(find.text("เผาผลาญ"), findsOneWidget);
    });
  });
}
