import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/plan/widget/linear_nutrient_two_progress.dart';
import 'package:foodandbody/theme.dart';
import 'package:mocktail/mocktail.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MockUser extends Mock implements User {}

class MockPlan extends Mock implements History {}

void main() {
  //widget
  const proteinLinearKey = Key("plan_protein_linear");
  const carbLinearKey = Key("plan_carb_linear");
  const fatLinearKey = Key("plan_fat_linear");

  late User user;
  late History plan;
  setUp(() {
    user = MockUser();
    plan = MockPlan();
    when(() => plan.totalNutrientList)
        .thenReturn(Nutrient().copyWith(protein: 120, carb: 80, fat: 30));
    when(() => user.info).thenReturn(Info(
        goalNutrient: Nutrient().copyWith(protein: 180, carb: 145, fat: 75)));
    when(() => plan.planNutrientList)
        .thenReturn(Nutrient().copyWith(protein: 130, carb: 95, fat: 40));
  });

  group("Nutrient Progress", () {
    group("can render", () {
      testWidgets("protein linear", (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: LinearNutrientTwoProgress(user, plan),
          ),
        ));
        expect(find.byKey(proteinLinearKey), findsOneWidget);
        expect(find.text("โปรตีน"), findsOneWidget);
      }); //test "protein linear"

      testWidgets("carb linear", (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: LinearNutrientTwoProgress(user, plan),
          ),
        ));
        expect(find.byKey(carbLinearKey), findsOneWidget);
        expect(find.text("คาร์บ"), findsOneWidget);
      }); //test "carb linear"

      testWidgets("fat linear", (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: LinearNutrientTwoProgress(user, plan),
          ),
        ));
        expect(find.byKey(fatLinearKey), findsOneWidget);
        expect(find.text("ไขมัน"), findsOneWidget);
      }); //test "carb linear"
    }); //group "can render"

    group("when total less than goal", () {
      testWidgets(": protein linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double proteinPlan = 80.0;
        final double proteinTotal = 50.5;
        final double proteinGoal = 100.2;

        linearProgress.proteinPlan = proteinPlan;
        linearProgress.proteinTotal = proteinTotal;
        linearProgress.proteinGoal = proteinGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having(
                (t) => t.percent, "percent", proteinPlan / proteinGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffffbb91)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having(
                (t) => t.percent, "percent", proteinTotal / proteinGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having((t) => t.progressColor,
                "progress color", AppTheme.themeData.primaryColor));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8).withOpacity(0)));
      }); //test ": protein linear"

      testWidgets(": carb linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double carbPlan = 180.0;
        final double carbTotal = 160.3;
        final double carbGoal = 220.5;

        linearProgress.carbPlan = carbPlan;
        linearProgress.carbTotal = carbTotal;
        linearProgress.carbGoal = carbGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", carbPlan / carbGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffffbb91)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", carbTotal / carbGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>().having((t) => t.progressColor,
                "progress color", AppTheme.themeData.primaryColor));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8).withOpacity(0)));
      }); //test ": carb linear"

      testWidgets(": fat linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double fatPlan = 50.0;
        final double fatTotal = 25.9;
        final double fatGoal = 60.8;

        linearProgress.fatPlan = fatPlan;
        linearProgress.fatTotal = fatTotal;
        linearProgress.fatGoal = fatGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", fatPlan / fatGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffffbb91)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", fatTotal / fatGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>().having((t) => t.progressColor,
                "progress color", AppTheme.themeData.primaryColor));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8).withOpacity(0)));
      }); //test ": fat linear"
    }); //group "when total less than goal"

    group("when plan greater than goal but total less than goal", () {
      testWidgets(": protein linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double proteinPlan = 110.0;
        final double proteinTotal = 50.5;
        final double proteinGoal = 100.2;

        linearProgress.proteinPlan = proteinPlan;
        linearProgress.proteinTotal = proteinTotal;
        linearProgress.proteinGoal = proteinGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffffbb91)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having(
                (t) => t.percent, "percent", proteinTotal / proteinGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having((t) => t.progressColor,
                "progress color", AppTheme.themeData.primaryColor));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8).withOpacity(0)));
      }); //test ": protein linear"

      testWidgets(": carb linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double carbPlan = 225.3;
        final double carbTotal = 160.3;
        final double carbGoal = 220.5;

        linearProgress.carbPlan = carbPlan;
        linearProgress.carbTotal = carbTotal;
        linearProgress.carbGoal = carbGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffffbb91)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", carbTotal / carbGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>().having((t) => t.progressColor,
                "progress color", AppTheme.themeData.primaryColor));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8).withOpacity(0)));
      }); //test ": carb linear"

      testWidgets(": fat linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double fatPlan = 70.2;
        final double fatTotal = 25.9;
        final double fatGoal = 60.8;
        linearProgress.fatPlan = fatPlan;
        linearProgress.fatTotal = fatTotal;
        linearProgress.fatGoal = fatGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffffbb91)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", fatTotal / fatGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>().having((t) => t.progressColor,
                "progress color", AppTheme.themeData.primaryColor));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xffd8d8d8).withOpacity(0)));
      }); //test ": fat linear"
    }); //group "when plan greater than goal but total less than goal"

    group("when total greater than goal", () {
      testWidgets(": protein linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double proteinPlan = 80.2;
        final double proteinTotal = 120.3;
        final double proteinGoal = 100.2;
        linearProgress.proteinPlan = proteinPlan;
        linearProgress.proteinTotal = proteinTotal;
        linearProgress.proteinGoal = proteinGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having(
                (t) => t.percent, "percent", proteinPlan / proteinGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(0)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0.8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(1)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0)));
        expect(
            tester.widget(
                find.text("${proteinTotal.round()}/${proteinGoal.round()} g")),
            isA<Text>().having(
                (t) => t.style!.color, "text color", Color(0xffff4040)));
      }); //test ": protein linear"

      testWidgets(": carb linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double carbPlan = 180.0;
        final double carbTotal = 225.0;
        final double carbGoal = 220.5;
        linearProgress.carbPlan = carbPlan;
        linearProgress.carbTotal = carbTotal;
        linearProgress.carbGoal = carbGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", carbPlan / carbGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(2)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0.8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(3)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0)));
        expect(
            tester.widget(
                find.text("${carbTotal.round()}/${carbGoal.round()} g")),
            isA<Text>().having(
                (t) => t.style!.color, "text color", Color(0xffff4040)));
      }); //test ": carb linear"

      testWidgets(": fat linear", (tester) async {
        final linearProgress = LinearNutrientTwoProgress(user, plan);
        final double fatPlan = 45.3;
        final double fatTotal = 75.0;
        final double fatGoal = 60.8;
        linearProgress.fatPlan = fatPlan;
        linearProgress.fatTotal = fatTotal;
        linearProgress.fatGoal = fatGoal;

        await tester.pumpWidget(MaterialApp(
            theme: AppTheme.themeData, home: Scaffold(body: linearProgress)));
        //plan
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", fatPlan / fatGoal));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(4)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0.8)));

        //total
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>()
                .having((t) => t.percent, "percent", 1));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>().having(
                (t) => t.progressColor, "progress color", Color(0xffff4040)));
        expect(
            tester.widget(find.byType(LinearPercentIndicator).at(5)),
            isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Colors.white.withOpacity(0)));
        expect(
            tester
                .widget(find.text("${fatTotal.round()}/${fatGoal.round()} g")),
            isA<Text>().having(
                (t) => t.style!.color, "text color", Color(0xffff4040)));
      }); //test ": protein linear"
    }); //group "when total greater than goal"
  }); //group "Nutrient Progress"
}
