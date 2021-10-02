import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/theme.dart';
import 'package:foodandbody/screens/home/linear_nutrient_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  const linearRowKey = Key('linear_indicator_row');
  const proteinColKey = Key('protein_linear_indicator');
  const carbColKey = Key('carb_linear_indicator');
  const fatColKey = Key('fat_linear_indicator');

  const proteinLineKey = Key('protein_line');
  const carbLineKey = Key('carb_line');
  const fatLineKey = Key('fat_line');

  group("Nutrient Linear Indicator", () {
    testWidgets("can render", (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: LinearNutrientIndicator(),
        ),
      ));
      expect(find.byKey(linearRowKey), findsOneWidget);
      expect(find.byKey(proteinColKey), findsOneWidget);
      expect(find.byKey(carbColKey), findsOneWidget);
      expect(find.byKey(fatColKey), findsOneWidget);
    }); //"can render"

    testWidgets("when total less than goal", (tester) async {
      final linearProgressRender = LinearNutrientIndicator();
      linearProgressRender.totalProtein = 25.4;
      linearProgressRender.totalCarb = 100.3;
      linearProgressRender.totalFat = 19.8;

      linearProgressRender.goalProtein = 100.5;
      linearProgressRender.goalCarb = 250.2;
      linearProgressRender.goalFat = 60.1;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: linearProgressRender,
        ),
      ));
      //protein
      var lineProgressFinder = find.byKey(proteinLineKey);
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having(
              (t) => t.percent,
              "percent",
              linearProgressRender.totalProtein /
                  linearProgressRender.goalProtein));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xFFFFBB91)));
      Column dataColFinder = tester.firstWidget(find.byKey(proteinColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffffffff)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalProtein.round()}/${linearProgressRender.goalProtein.round()} g"));

      //carb
      lineProgressFinder = find.byKey(carbLineKey);
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent",
              linearProgressRender.totalCarb / linearProgressRender.goalCarb));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xFFFFBB91)));
      dataColFinder = tester.firstWidget(find.byKey(carbColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffffffff)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalCarb.round()}/${linearProgressRender.goalCarb.round()} g"));

      //fat
      lineProgressFinder = find.byKey(fatLineKey);
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent",
              linearProgressRender.totalFat / linearProgressRender.goalFat));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xFFFFBB91)));
      dataColFinder = tester.firstWidget(find.byKey(fatColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffffffff)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalFat.round()}/${linearProgressRender.goalFat.round()} g"));
    }); //"when total less than goal"

    testWidgets("when total greater than goal", (tester) async {
      final linearProgressRender = LinearNutrientIndicator();

      linearProgressRender.totalProtein = 130.4;
      linearProgressRender.totalCarb = 300.2;
      linearProgressRender.totalFat = 74.9;

      linearProgressRender.goalProtein = 100.2;
      linearProgressRender.goalCarb = 250.1;
      linearProgressRender.goalFat = 60.0;

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: linearProgressRender,
        ),
      ));
      //protein
      var lineProgressFinder = find.byKey(proteinLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having(
              (t) => t.progressColor, "progress bar color", Color(0xffff4040)));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xccffffff)));
      Column dataColFinder = tester.firstWidget(find.byKey(proteinColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffff4040)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalProtein.round()}/${linearProgressRender.goalProtein.round()} g"));

      //carb
      lineProgressFinder = find.byKey(carbLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having(
              (t) => t.progressColor, "progress bar color", Color(0xffff4040)));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xccffffff)));
      dataColFinder = tester.firstWidget(find.byKey(carbColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffff4040)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalCarb.round()}/${linearProgressRender.goalCarb.round()} g"));

      //fat
      lineProgressFinder = find.byKey(fatLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having(
              (t) => t.progressColor, "progress bar color", Color(0xffff4040)));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xccffffff)));
      dataColFinder = tester.firstWidget(find.byKey(fatColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffff4040)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalFat.round()}/${linearProgressRender.goalFat.round()} g"));
    }); //"when total greater than goal"

    testWidgets("when total equals goal", (tester) async {
      final linearProgressRender = LinearNutrientIndicator();

      linearProgressRender.totalProtein = 100.0;
      linearProgressRender.totalCarb = 250.3;
      linearProgressRender.totalFat = 60.4;

      linearProgressRender.goalProtein = 100.0;
      linearProgressRender.goalCarb = 250.3;
      linearProgressRender.goalFat = 60.4;

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: linearProgressRender,
        ),
      ));
      //protein
      var lineProgressFinder = find.byKey(proteinLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xFFFFBB91)));
      Column dataColFinder = tester.firstWidget(find.byKey(proteinColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffffffff)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalProtein.round()}/${linearProgressRender.goalProtein.round()} g"));

      //carb
      lineProgressFinder = find.byKey(carbLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xFFFFBB91)));
      dataColFinder = tester.firstWidget(find.byKey(carbColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffffffff)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalCarb.round()}/${linearProgressRender.goalCarb.round()} g"));

      //fat
      lineProgressFinder = find.byKey(fatLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.progressColor,
              "progress bar color", AppTheme.themeData.indicatorColor));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.backgroundColor,
              "background bar color", Color(0xFFFFBB91)));
      dataColFinder = tester.firstWidget(find.byKey(fatColKey));
      expect(
          dataColFinder.children[2].toString(), contains("Color(0xffffffff)"));
      expect(
          dataColFinder.children[2].toString(),
          contains(
              "${linearProgressRender.totalFat.round()}/${linearProgressRender.goalFat.round()} g"));
    }); //"when total equals goal"
  }); //group "Nutrient Linear Indicator"
}
