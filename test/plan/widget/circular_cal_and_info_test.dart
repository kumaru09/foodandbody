import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/widget/circular_cal_and_info.dart';
import 'package:foodandbody/theme.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MockPlan extends Mock implements History {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

void main() {
  //widget
  const circularCalAndInfoKey = Key("circular_cal_and_info");
  const circularPlanCalKey = Key("circular_plan_cal");
  const circularTotalCalKey = Key("circular_total_cal");
  const circularDataColumnKey = Key("circular_data_col");
  const calInfoKey = Key("cal_info");
  const editGoalButtonKey = Key("edit_goal_button");
  const editGoalDialogKey = Key("edit_goal_dialog");
  const okButtonKey = Key("edit_button_in_edit_goal_dialog");
  const cancelButtonKey = Key("cancel_button_in_edit_goal_dialog");
  const EditGoalInput = Key("edit_goal_textFormField");

  const String name = 'อาหาร';
  const int weight = 50;
  const String goal = '1600';
  const Calory validGoal = Calory.dirty(goal);
  const Calory invalidGoal = Calory.dirty('');
  final List<Menu> mockMenuList = [
    Menu(
        name: name,
        calories: 300,
        protein: 30,
        carb: 30,
        fat: 10,
        serve: 1,
        volumn: 1)
  ];
  final History mockPlan = History(Timestamp.now(), menuList: mockMenuList);
  const Nutrient mockNutrient = Nutrient(protein: 100, carb: 100, fat: 100);
  final Info mockInfo = Info(
      name: 'user',
      goal: int.parse(goal),
      weight: weight,
      height: 160,
      gender: 'F',
      goalNutrient: mockNutrient);

  late History plan;
  late PlanBloc planBloc;
  late PlanRepository planRepository;
  late UserRepository userRepository;

  setUpAll(() {
    registerFallbackValue<PlanEvent>(FakePlanEvent());
    registerFallbackValue<PlanState>(FakePlanState());
  });

  setUp(() {
    plan = MockPlan();
    planRepository = MockPlanRepository();
    userRepository = MockUserRepository();
    when(() => plan.totalCal).thenReturn(1000);
    when(() => plan.menuList).thenReturn(<Menu>[]);
    planBloc = MockPlanBloc();
    when(() => planBloc.state).thenReturn(PlanState(
        status: PlanStatus.success,
        plan: mockPlan,
        info: mockInfo,
        goal: validGoal,
        exerciseStatus: FormzStatus.submissionSuccess));
  });

  group("Circular Cal and Info", () {
    testWidgets("has widget", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.themeData,
          home: BlocProvider.value(
            value: planBloc,
            child: Scaffold(
              body: CircularCalAndInfo(plan, goal),
            ),
          ),
        ),
      );
      expect(find.byKey(circularCalAndInfoKey), findsOneWidget);
    }); //test "has widget"
    group("can render", () {
      testWidgets("circular plan cal", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: CircularCalAndInfo(plan, goal),
              ),
            ),
          ),
        );
        expect(find.byKey(circularPlanCalKey), findsOneWidget);
        expect(
            tester.widget(find.byKey(circularPlanCalKey)),
            isA<CircularPercentIndicator>().having((t) => t.backgroundColor,
                "background color", Color(0xFFD8D8D8)));
      }); //test "circular plan cal"

      testWidgets("circular total cal", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: CircularCalAndInfo(plan, goal),
              ),
            ),
          ),
        );
        expect(find.byKey(circularTotalCalKey), findsOneWidget);
        expect(find.byKey(circularDataColumnKey), findsOneWidget);
      }); //test "circular total cal"

      testWidgets(":cal info", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: CircularCalAndInfo(plan, goal),
              ),
            ),
          ),
        );
        expect(find.byKey(calInfoKey), findsOneWidget);
        expect(find.text("เป้าหมาย"), findsOneWidget);
        expect(find.byKey(editGoalButtonKey), findsOneWidget);
        expect(find.text("ที่จะกิน"), findsOneWidget);
        expect(find.text("ที่กินแล้ว"), findsOneWidget);
      }); //test "cal info"
    }); //group "can render"

    group("render plan and total less than goal", () {
      testWidgets(": circular plan cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
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
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
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
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
        Column circularDataColumnFinder =
            tester.firstWidget(find.byKey(circularDataColumnKey));
        expect(circularDataColumnFinder.children[0].toString(),
            contains("เพิ่มได้อีก"));
        expect(circularDataColumnFinder.children[1].toString(),
            contains("${(goalCal - planCal).round()}".toString()));
      }); //test ": circular data info"

      testWidgets(": cal info", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 1500.3;
        final double totalCal = 1250.7;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
        expect(find.text("${goalCal.round()}"), findsOneWidget);
        expect(find.text("${planCal.round()}"), findsOneWidget);
        expect(find.text("${totalCal.round()}"), findsOneWidget);
      }); //test ": cal info"
    }); //group "when total less than goal"

    group("when plan greater than goal but total less than goal", () {
      testWidgets(": circular plan cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 2100.6;
        final double totalCal = 1250.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
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
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 2100.6;
        final double totalCal = 1250.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
        Column circularDataColumnFinder =
            tester.firstWidget(find.byKey(circularDataColumnKey));
        expect(circularDataColumnFinder.children[0].toString(),
            contains("เพิ่มได้อีก"));
        expect(circularDataColumnFinder.children[1].toString(), contains("0"));
      }); //test ": circular data info"
    }); //group "when plan greater than goal but total less than goal"

    group("when total greater than goal", () {
      testWidgets(": circular plan cal", (tester) async {
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 1500.8;
        final double totalCal = 2100.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
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
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 1500.8;
        final double totalCal = 2100.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
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
        final circularCalAndInfo = CircularCalAndInfo(plan, goal);
        final double planCal = 1500.8;
        final double totalCal = 2100.3;
        final double goalCal = 2000.0;

        circularCalAndInfo.planCal = planCal;
        circularCalAndInfo.totalCal = totalCal;
        circularCalAndInfo.goalCal = goalCal;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: circularCalAndInfo,
              ),
            ),
          ),
        );
        Column circularDataColumnFinder =
            tester.firstWidget(find.byKey(circularDataColumnKey));
        expect(circularDataColumnFinder.children[0].toString(),
            contains("กินเกินแล้ว"));
        expect(circularDataColumnFinder.children[1].toString(),
            contains("${(totalCal - goalCal).round()}".toString()));
        expect(circularDataColumnFinder.children[1].toString(),
            contains("Color(0xffff4040)"));
      }); //test ": circular data info"
    });

    testWidgets("render edit goal button", (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: userRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: CircularCalAndInfo(plan, goal),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(editGoalButtonKey));
      await tester.pump();
      expect(find.byKey(editGoalDialogKey), findsOneWidget);
    });

    testWidgets("call plan UpdateGoal event when update goal", (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: userRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: CircularCalAndInfo(plan, goal),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(editGoalButtonKey));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(EditGoalInput), goal);
      await tester.pump();
      await tester.tap(find.byKey(okButtonKey));
      await tester.pumpAndSettle();
      verify(() => planBloc.add(UpdateGoal(goal: goal))).called(1);
    });

    group("widget EditGoalDialog", () {
      //test "edit goal button"
      testWidgets("can render initial", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: EditGoalDialog(),
              ),
            ),
          ),
        );
        expect(find.text('แก้ไขเป้าหมายแคลอรี่'), findsOneWidget);
        expect(find.byKey(EditGoalInput), findsOneWidget);
        expect(find.byKey(okButtonKey), findsOneWidget);
        expect(find.byKey(cancelButtonKey), findsOneWidget);
      });

      testWidgets("render invalid text when goal is invalid", (tester) async {
        when(() => planBloc.state).thenReturn(
            PlanState(goalStatus: FormzStatus.invalid, goal: invalidGoal));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: EditGoalDialog(),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุแคลอรีให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets("disable ตกลง button when goal is invalid", (tester) async {
        when(() => planBloc.state).thenReturn(
            PlanState(goalStatus: FormzStatus.invalid, goal: invalidGoal));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: EditGoalDialog(),
              ),
            ),
          ),
        );
        final button = tester.widget<TextButton>(
          find.byKey(okButtonKey),
        );
        expect(button.enabled, isFalse);
      });

      testWidgets("enable ตกลง button when goal is valid", (tester) async {
        when(() => planBloc.state).thenReturn(
            PlanState(goalStatus: FormzStatus.valid, goal: validGoal));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: EditGoalDialog(),
              ),
            ),
          ),
        );
        final button = tester.widget<TextButton>(
          find.byKey(okButtonKey),
        );
        expect(button.enabled, isTrue);
      });

      testWidgets("navigate pop when pressed ตกลง button", (tester) async {
        when(() => planBloc.state).thenReturn(
            PlanState(goalStatus: FormzStatus.valid, goal: validGoal));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: EditGoalDialog(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(okButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(editGoalDialogKey), findsNothing);
      });

      testWidgets("navigate pop when pressed ยกเลิก button", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.themeData,
            home: BlocProvider.value(
              value: planBloc,
              child: Scaffold(
                body: EditGoalDialog(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(cancelButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(editGoalDialogKey), findsNothing);
      }); //test "แก้ไข button"
    }); //group "when pressed"
  }); //group "Circular Cal and Info"
}
