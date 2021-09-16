import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/theme.dart';
import 'package:foodandbody/screens/home/linear_nutrient_indicator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

abstract class MockWithExpandedToString extends Mock {
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug});
}

class MockFunction extends MockWithExpandedToString
    implements LinearNutrientIndicator {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}

void main() {
  const linearRowKey = Key('linear_indicator_row');
  const proteinColKey = Key('protein_linear_indicator');
  const carbColKey = Key('carb_linear_indicator');
  const fatColKey = Key('fat_linear_indicator');

  const proteinLineKey = Key('protein_line');
  const carbLineKey = Key('carb_line');
  const fatLineKey = Key('fat_line');

  group("Nutrient Linear Indicator", () {
    late LinearNutrientIndicator nutrient;

    setUp(() {
      nutrient = MockFunction();
    });
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
      when(() => nutrient.getTotalNutrient())
          .thenAnswer((invocation) => [25, 100, 20]);
      when(() => nutrient.getGoalNutrient())
          .thenAnswer((invocation) => [100, 250, 60]);
      linearProgressRender.totalProtein = nutrient.getTotalNutrient()[0];
      linearProgressRender.totalCarb = nutrient.getTotalNutrient()[1];
      linearProgressRender.totalFat = nutrient.getTotalNutrient()[2];
      linearProgressRender.goalProtein = nutrient.getGoalNutrient()[0];
      linearProgressRender.goalCarb = nutrient.getGoalNutrient()[1];
      linearProgressRender.goalFat = nutrient.getGoalNutrient()[2];
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
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent",
              nutrient.getTotalNutrient()[0] / nutrient.getGoalNutrient()[0]));
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
              "${nutrient.getTotalNutrient()[0]}/${nutrient.getGoalNutrient()[0]} g"));

      //carb
      lineProgressFinder = find.byKey(carbLineKey);
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent",
              nutrient.getTotalNutrient()[1] / nutrient.getGoalNutrient()[1]));
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
              "${nutrient.getTotalNutrient()[1]}/${nutrient.getGoalNutrient()[1]} g"));

      //fat
      lineProgressFinder = find.byKey(fatLineKey);
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent",
              nutrient.getTotalNutrient()[2] / nutrient.getGoalNutrient()[2]));
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
              "${nutrient.getTotalNutrient()[2]}/${nutrient.getGoalNutrient()[2]} g"));
    }); //"when total less than goal"

    testWidgets("when total greater than goal", (tester) async {
      final linearProgressRender = LinearNutrientIndicator();
      when(() => nutrient.getTotalNutrient())
          .thenAnswer((invocation) => [130, 300, 75]);
      when(() => nutrient.getGoalNutrient())
          .thenAnswer((invocation) => [100, 250, 60]);
      linearProgressRender.totalProtein = nutrient.getTotalNutrient()[0];
      linearProgressRender.totalCarb = nutrient.getTotalNutrient()[1];
      linearProgressRender.totalFat = nutrient.getTotalNutrient()[2];
      linearProgressRender.goalProtein = nutrient.getGoalNutrient()[0];
      linearProgressRender.goalCarb = nutrient.getGoalNutrient()[1];
      linearProgressRender.goalFat = nutrient.getGoalNutrient()[2];
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
              "${nutrient.getTotalNutrient()[0]}/${nutrient.getGoalNutrient()[0]} g"));

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
              "${nutrient.getTotalNutrient()[1]}/${nutrient.getGoalNutrient()[1]} g"));

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
              "${nutrient.getTotalNutrient()[2]}/${nutrient.getGoalNutrient()[2]} g"));
    }); //"when total greater than goal"

    testWidgets("when total equals goal",
        (tester) async {
      final linearProgressRender = LinearNutrientIndicator();
      when(() => nutrient.getTotalNutrient())
          .thenAnswer((invocation) => [100, 250, 60]);
      when(() => nutrient.getGoalNutrient())
          .thenAnswer((invocation) => [100, 250, 60]);
      linearProgressRender.totalProtein = nutrient.getTotalNutrient()[0];
      linearProgressRender.totalCarb = nutrient.getTotalNutrient()[1];
      linearProgressRender.totalFat = nutrient.getTotalNutrient()[2];
      linearProgressRender.goalProtein = nutrient.getGoalNutrient()[0];
      linearProgressRender.goalCarb = nutrient.getGoalNutrient()[1];
      linearProgressRender.goalFat = nutrient.getGoalNutrient()[2];
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
              (t) => t.progressColor, "progress bar color", AppTheme.themeData.indicatorColor));
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
              "${nutrient.getTotalNutrient()[0]}/${nutrient.getGoalNutrient()[0]} g"));

      //carb
      lineProgressFinder = find.byKey(carbLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having(
              (t) => t.progressColor, "progress bar color", AppTheme.themeData.indicatorColor));
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
              "${nutrient.getTotalNutrient()[1]}/${nutrient.getGoalNutrient()[1]} g"));

      //fat
      lineProgressFinder = find.byKey(fatLineKey);
      expect(tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having((t) => t.percent, "percent", 1));
      expect(
          tester.widget(lineProgressFinder),
          isA<LinearPercentIndicator>().having(
              (t) => t.progressColor, "progress bar color", AppTheme.themeData.indicatorColor));
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
              "${nutrient.getTotalNutrient()[2]}/${nutrient.getGoalNutrient()[2]} g"));
    }); //"when total equals goal"
  }); //group "Nutrient Linear Indicator"
}
