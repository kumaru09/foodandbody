import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/plan/widget/circular_cal_and_info.dart';
import 'package:foodandbody/theme.dart';
import 'package:mocktail/mocktail.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MockUser extends Mock implements User {}

class MockPlan extends Mock implements History {}

void main() {
  //widget
  const circularCalAndInfoKey = Key("circular_cal_and_info");
  const circularPlanCalKey = Key("circular_plan_cal");
  const circularTotalCalKey = Key("circular_total_cal");
  const circularDataColumnKey = Key("circular_data_col");
  const calInfoKey = Key("cal_info");
  const editGoalButtonKey = Key("edit_goal_button");
  const editGoalDialogKey = Key("edit_goal_dialog");
  const editButtonKey = Key("edit_button_in_edit_goal_dialog");
  const cancelButtonKey = Key("cancel_button_in_edit_goal_dialog");

  late User user;
  late History plan;
  setUp(() {
    user = MockUser();
    plan = MockPlan();
    when(() => plan.totalCal).thenReturn(1000);
    when(() => plan.menuList).thenReturn(<Menu>[]);
    when(() => user.info).thenReturn(Info(goal: 2200));
  });
  group("Circular Cal and Info", () {
    testWidgets("has widget", (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: CircularCalAndInfo(user, plan),
        ),
      ));
      expect(find.byKey(circularCalAndInfoKey), findsOneWidget);
    }); //test "has widget"
    group("can render", () {
      testWidgets("circular plan cal", (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: CircularCalAndInfo(user, plan),
          ),
        ));
        expect(find.byKey(circularPlanCalKey), findsOneWidget);
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xFFD8D8D8)));
      }); //test "circular plan cal"

      testWidgets("circular total cal", (tester) async {
        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData,
            home: Scaffold(body: CircularCalAndInfo(user, plan))));
        expect(find.byKey(circularTotalCalKey), findsOneWidget);
        expect(find.byKey(circularDataColumnKey), findsOneWidget);
      }); //test "circular total cal"

      testWidgets(":cal info", (tester) async {
        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData,
            home: Scaffold(body: CircularCalAndInfo(user, plan))));
        expect(find.byKey(calInfoKey), findsOneWidget);
        expect(find.text("เป้าหมาย"), findsOneWidget);
        expect(find.byKey(editGoalButtonKey), findsOneWidget);
        expect(find.text("ที่จะกิน"), findsOneWidget);
        expect(find.text("ที่กินแล้ว"), findsOneWidget);
      }); //test "cal info"
    }); //group "can render"

    group("when plan and total less than goal", () {
      testWidgets(": circular plan cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>()
                .having((t) => t.percent, "percent", planCal / goalCal));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xfffffbb91)));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));
      }); //test ": circular plan cal"

      testWidgets(": circular total cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        expect(
            tester.widget(find.byKey(circularTotalCalKey)),
            isA<CircularPercentIndicator>()
                .having((t) => t.percent, "percent", totalCal / goalCal));
        expect(
            tester.widget(find.byKey(circularTotalCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.progressColor,
                "progress color", AppTheme.themeData.primaryColor));
        expect(
            tester.widget(find.byKey(circularTotalCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8).withOpacity(0)));
      }); //test ": circular total cal"

      testWidgets(": circular data info", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        Column circularDataColumnFinder =
            tester.firstWidget(find.byKey(circularDataColumnKey));
        expect(circularDataColumnFinder.children[0].toString(),
            contains("เพิ่มได้อีก"));
        expect(circularDataColumnFinder.children[1].toString(),
            contains("${(goalCal - planCal).round()}".toString()));
      }); //test ": circular data info"

      testWidgets(": cal info", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        expect(find.text("${goalCal.round()}"), findsOneWidget);
        expect(find.text("${planCal.round()}"), findsOneWidget);
        expect(find.text("${totalCal.round()}"), findsOneWidget);
      }); //test ": cal info"
    }); //group "when total less than goal"

    group("when plan greater than goal but total less than goal", () {
      testWidgets(": circular plan cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 2100.6;
        final double totalCal = 1250.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffffbb91)));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));
      }); //test ": circular plan cal"

      testWidgets(": circular data info", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 2100.6;
        final double totalCal = 1250.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        Column circularDataColumnFinder =
            tester.firstWidget(find.byKey(circularDataColumnKey));
        expect(circularDataColumnFinder.children[0].toString(),
            contains("เพิ่มได้อีก"));
        expect(circularDataColumnFinder.children[1].toString(), contains("0"));
      }); //test ": circular data info"
    }); //group "when plan greater than goal but total less than goal"

    group("when total greater than goal", () {
      testWidgets(": circular plan cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 1500.8;
        final double totalCal = 2100.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0.8)));
      }); //test ": circular plan cal"

      testWidgets(": circular total cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 1500.8;
        final double totalCal = 2100.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        expect(
            tester.widget(find.byKey(circularTotalCalKey)),
            isA<CircularPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byKey(circularTotalCalKey)),
            isA<CircularPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byKey(circularTotalCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0)));
      }); //test ": circular total cal"

      testWidgets(": circular data info", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(user, plan);
        final double planCal = 1500.8;
        final double totalCal = 2100.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: circularCalAndInfo,
          ),
        ));
        Column circularDataColumnFinder =
            tester.firstWidget(find.byKey(circularDataColumnKey));
        expect(circularDataColumnFinder.children[0].toString(),
            contains("กินเกินแล้ว"));
        expect(circularDataColumnFinder.children[1].toString(),
            contains("${(totalCal - goalCal).round()}".toString()));
        expect(circularDataColumnFinder.children[1].toString(),
            contains("Color(0xffff4040)"));
      }); //test ": circular data info"
    }); //group "when total greater than goal"

    group("when pressed", () {
      testWidgets("edit goal button", (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: CircularCalAndInfo(user, plan),
          ),
        ));
        await tester.tap(find.byKey(editGoalButtonKey));
        await tester.pump();
        expect(find.byKey(editGoalDialogKey), findsOneWidget);
      }); //test "edit goal button"

      testWidgets("แก้ไข button", (tester) async {
        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData,
            home: Scaffold(body: CircularCalAndInfo(user, plan))));
        await tester.tap(find.byKey(editGoalButtonKey));
        await tester.pump();
        await tester.tap(find.byKey(editButtonKey));
        await tester.pump();
        expect(find.byKey(editGoalDialogKey), findsNothing);
      }); //test "แก้ไข button"

      testWidgets("ยกเลิก button", (tester) async {
        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData,
            home: Scaffold(body: CircularCalAndInfo(user, plan))));
        await tester.tap(find.byKey(editGoalButtonKey));
        await tester.pump();
        await tester.tap(find.byKey(cancelButtonKey));
        await tester.pump();
        expect(find.byKey(editGoalDialogKey), findsNothing);
      }); //test "แก้ไข button"
    }); //group "when pressed"
  }); //group "Circular Cal and Info"
}
