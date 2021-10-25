import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/home/circular_cal_indicator.dart';
import 'package:foodandbody/theme.dart';
import 'package:mocktail/mocktail.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MockUser extends Mock implements User {}

class MockPlan extends Mock implements History {}

void main() {
  const circularProgressKey = Key('calories_circular_indicator');
  const circularDataColumnKey = Key('calories_circular_indicator_column');
  late User user;
  late History plan;

  setUp(() {
    user = MockUser();
    plan = MockPlan();
    when(() => plan.totalCal).thenReturn(1800);
    when(() => user.info).thenReturn(Info(goal: 2200));
  });
  group("Calories Circular Progress", () {
    testWidgets("can render", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CircularCalIndicator(plan, user),
        ),
      ));
      expect(find.byKey(circularProgressKey), findsOneWidget);
    }); //"can render"

    testWidgets("when total calories less than goal calories", (tester) async {
      final circularProgressRender = CircularCalIndicator(plan, user);
      circularProgressRender.totalCal = 1500.3;
      circularProgressRender.goalCal = 2000.4;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: circularProgressRender,
        ),
      ));
      var circularProgressFinder = find.byKey(circularProgressKey);
      Column circularDataColumnFinder =
          tester.firstWidget(find.byKey(circularDataColumnKey));
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
              (t) => t.percent,
              "percent",
              circularProgressRender.totalCal /
                  circularProgressRender.goalCal));
      expect(circularDataColumnFinder.children[0].toString(),
          contains("กินได้อีก"));
      expect(circularDataColumnFinder.children[1].toString(),
          contains("Color(0xffffffff)"));
    }); //"when total calories less than goal calories"

    testWidgets("when total calories equals goal calories", (tester) async {
      final circularProgressRender = CircularCalIndicator(plan, user);
      circularProgressRender.totalCal = 2000.4;
      circularProgressRender.goalCal = 2000.4;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: circularProgressRender,
        ),
      ));
      var circularProgressFinder = find.byKey(circularProgressKey);
      Column circularDataColumnFinder =
          tester.firstWidget(find.byKey(circularDataColumnKey));
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
              (t) => t.percent,
              "percent",
              circularProgressRender.totalCal /
                  circularProgressRender.goalCal));
      expect(circularDataColumnFinder.children[0].toString(),
          contains("กินได้อีก"));
      expect(circularDataColumnFinder.children[1].toString(),
          contains("Color(0xffffffff)"));
    }); //"when total calories equals goal calories"

    testWidgets("when total calories greater than goal calories",
        (tester) async {
      final circularProgressRender = CircularCalIndicator(plan, user);
      circularProgressRender.totalCal = 2150.7;
      circularProgressRender.goalCal = 2000.4;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.themeData,
        home: Scaffold(
          body: circularProgressRender,
        ),
      ));
      var circularProgressFinder = find.byKey(circularProgressKey);
      Column circularDataColumnFinder =
          tester.firstWidget(find.byKey(circularDataColumnKey));
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
}
