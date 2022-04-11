import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/exercise_time.dart';
import 'package:foodandbody/models/exercise_type.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/home/add_exercise.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockExerciseTime extends Mock implements ExerciseTime {}

class MockExerciseType extends Mock implements ExerciseType {}

void main() {
  const homeAddExerciseButtonKey = Key('home_add_exercise_button');
  const homeAddExerciseDialogKey = Key("home_add_exercise_dialog");
  const activityDropdownKey = Key("activity_select_dropdown");
  const timeTextFiledKey = Key("exercise_time_text_field");
  const addExerciseDialogOkButtonKey = Key("add_exercise_dialog_ok_button");
  const addExerciseDialogCancelButtonKey =
      Key("add_exercise_dialog_cancel_button");

  const invalidExerciseTimeString = '';
  const invalidExerciseTime = ExerciseTime.dirty(invalidExerciseTimeString);

  const validExerciseTimeString = '30';
  const validExerciseTime = ExerciseTime.dirty(validExerciseTimeString);

  const invalidExerciseTypeString = '';
  const invalidExerciseType = ExerciseType.dirty(invalidExerciseTypeString);

  const validExerciseTypeString = '1';
  const validExerciseType = ExerciseType.dirty(validExerciseTypeString);

  final DateTime mockDate = DateTime.now();
  final List<ExerciseRepo> mockExerciseList = [
    ExerciseRepo(
      id: 'id',
      name: 'exerciseName',
      min: 30,
      calory: 300,
      timestamp: Timestamp.fromDate(mockDate),
    )
  ];
  final Nutrient mockNutrientList = Nutrient(protein: 20, carb: 20, fat: 20);
  final History mockHistory = History(Timestamp.fromDate(mockDate),
      totalCal: 100,
      totalBurn: 100,
      totalWater: 1,
      totalNutrientList: mockNutrientList,
      exerciseList: mockExerciseList);

  const testType = 'แอโรบิค';
  const testTime = '30';

  late PlanBloc planBloc;

  setUpAll(() {
    registerFallbackValue<PlanEvent>(FakePlanEvent());
    registerFallbackValue<PlanState>(FakePlanState());
  });

  setUp(() async {
    planBloc = MockPlanBloc();
    when(() => planBloc.state).thenReturn(PlanState(plan: mockHistory));
  });

  group('AddExerciseButton', () {
    group('render', () {
      testWidgets("add exercise button", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: AddExerciseButton(),
        ));
        expect(find.byKey(homeAddExerciseButtonKey), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text("เพิ่มการออกกำลังกาย"), findsOneWidget);
      }); //"can render"

      testWidgets("add exercise dialog when press เพิ่มการออกกำลังกาย button",
          (tester) async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<PlanRepository>(
                  create: (_) => MockPlanRepository()),
              RepositoryProvider<UserRepository>(
                  create: (_) => MockUserRepository()),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: planBloc,
                child: AddExerciseButton(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(homeAddExerciseButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(homeAddExerciseDialogKey), findsOneWidget);
      }); //"when press เพิ่มการออกกำลังกาย button"

      testWidgets("close add exercise dialog when press ยกเลิก button",
          (tester) async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<PlanRepository>(
                  create: (_) => MockPlanRepository()),
              RepositoryProvider<UserRepository>(
                  create: (_) => MockUserRepository()),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: planBloc,
                child: AddExerciseButton(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(homeAddExerciseButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(homeAddExerciseDialogKey), findsOneWidget);
        await tester.tap(find.byKey(addExerciseDialogCancelButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(homeAddExerciseDialogKey), findsNothing);
      });
    });

    group('AddExerciseDialog widget', () {
      group('render', () {
        testWidgets("add exercise dialog element", (tester) async {
          await tester.pumpWidget(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: BlocProvider.value(
                  value: planBloc,
                  child: AddExerciseDialog(),
                ),
              ),
            ),
          );
          expect(find.byKey(activityDropdownKey), findsOneWidget);
          expect(find.byKey(timeTextFiledKey), findsOneWidget);
          expect(find.byKey(addExerciseDialogOkButtonKey), findsOneWidget);
          expect(find.byKey(addExerciseDialogCancelButtonKey), findsOneWidget);
        });

        testWidgets(
            'invalid exerciseType error text when exerciseType is invalid',
            (tester) async {
          when(() => planBloc.state).thenReturn(
              PlanState(plan: mockHistory, exerciseType: invalidExerciseType));
          await tester.pumpWidget(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: BlocProvider.value(
                  value: planBloc,
                  child: AddExerciseDialog(),
                ),
              ),
            ),
          );
          expect(find.text('กรุณาเลือกกิจกกรม'), findsOneWidget);
        });

        testWidgets(
            'invalid exerciseTime error text when exerciseTime is invalid',
            (tester) async {
          when(() => planBloc.state).thenReturn(
              PlanState(plan: mockHistory, exerciseTime: invalidExerciseTime));
          await tester.pumpWidget(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: BlocProvider.value(
                  value: planBloc,
                  child: AddExerciseDialog(),
                ),
              ),
            ),
          );
          expect(find.text('กรุณากรอกเวลาให้ถูกต้อง'), findsOneWidget);
        });

        testWidgets(
            'disable add exercise dialog ok button when exerciseTime or exerciseType are invalid',
            (tester) async {
          when(() => planBloc.state).thenReturn(PlanState(
              plan: mockHistory,
              exerciseTime: invalidExerciseTime,
              exerciseType: invalidExerciseType));
          await tester.pumpWidget(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: BlocProvider.value(
                  value: planBloc,
                  child: AddExerciseDialog(),
                ),
              ),
            ),
          );
          final button = tester.widget<TextButton>(
            find.byKey(addExerciseDialogOkButtonKey),
          );
          expect(button.enabled, isFalse);
        });

        testWidgets(
            'enable add exercise dialog ok button when exerciseTime and exerciseType are valid',
            (tester) async {
          when(() => planBloc.state).thenReturn(PlanState(
              plan: mockHistory,
              exerciseTime: validExerciseTime,
              exerciseType: validExerciseType));
          await tester.pumpWidget(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: BlocProvider.value(
                  value: planBloc,
                  child: AddExerciseDialog(),
                ),
              ),
            ),
          );
          final button = tester.widget<TextButton>(
            find.byKey(addExerciseDialogOkButtonKey),
          );
          expect(button.enabled, isTrue);
        });
      });

      group('calls', () {
        testWidgets('exerciseTypeChanged when exercise type changed',
            (tester) async {
          await tester.pumpWidget(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: BlocProvider.value(
                  value: planBloc,
                  child: AddExerciseDialog(),
                ),
              ),
            ),
          );
          var input1 = tester.widget<DropdownButtonFormField<String>>(
              find.byKey(activityDropdownKey));
          expect(input1.initialValue, null);

          await tester.tap(find.byKey(activityDropdownKey));
          await tester.pumpAndSettle();
          await tester.tap(find.text(testType).last);
          await tester.pump();

          var input2 = tester.widget<DropdownButtonFormField<String>>(
              find.byKey(activityDropdownKey));
          expect(input2.initialValue, '0');
          verify(() => planBloc.add(ExerciseTypeChange(value: '0'))).called(1);
        });

        testWidgets('exerciseTimeChanged when exercise time changed',
            (tester) async {
          await tester.pumpWidget(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: BlocProvider.value(
                  value: planBloc,
                  child: AddExerciseDialog(),
                ),
              ),
            ),
          );
          await tester.enterText(find.byKey(timeTextFiledKey), testTime);
          verify(() => planBloc.add(ExerciseTimeChange(value: testTime)))
              .called(1);
        });
      });
    });
  });
}
