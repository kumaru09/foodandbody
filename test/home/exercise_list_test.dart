import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';
import 'package:foodandbody/screens/home/exercise_list.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

class MockHistoryBloc extends MockBloc<HistoryEvent, HistoryState> implements HistoryBloc {}

class FakeHistoryEvent extends Fake implements HistoryEvent {}

class FakeHistoryState extends Fake implements HistoryState {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  final Timestamp mockDate = Timestamp.fromDate(DateTime.now());
  final List<ExerciseRepo> mockExercise = [
    ExerciseRepo(
        id: 'id1', name: 'name1', min: 30, calory: 300, timestamp: mockDate),
    ExerciseRepo(
        id: 'id2', name: 'name2', min: 30, calory: 300, timestamp: mockDate),
    ExerciseRepo(
        id: 'id3', name: 'name3', min: 30, calory: 300, timestamp: mockDate),
  ];

  late PlanBloc planBloc;
  late HistoryBloc historyBloc;
  late PlanRepository planRepository;
  late UserRepository userRepository;

  setUpAll(() {
    registerFallbackValue<PlanEvent>(FakePlanEvent());
    registerFallbackValue<PlanState>(FakePlanState());
    registerFallbackValue<HistoryEvent>(FakeHistoryEvent());
    registerFallbackValue<HistoryState>(FakeHistoryState());
  });

  setUp(() async {
    planBloc = MockPlanBloc();
    historyBloc = MockHistoryBloc();
    planRepository = MockPlanRepository();
    userRepository = MockUserRepository();
    planBloc = PlanBloc(
        planRepository: planRepository, userRepository: userRepository);
  });

  group('Exercise List', () {
    testWidgets('render 3 exercise list card when have 3 exercise data',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider.value(
          value: planBloc,
          child: ExerciseList(mockExercise),
        ),
      ));
      expect(find.byType(Card), findsNWidgets(3));
      expect(find.text('name1'), findsOneWidget);
      expect(find.text('name2'), findsOneWidget);
      expect(find.text('name3'), findsOneWidget);
      expect(find.text('30 นาที'), findsNWidgets(3));
      expect(find.text('300'), findsNWidgets(3));
      expect(find.text('แคล'), findsNWidgets(3));
    });

    testWidgets('render nothing when have 0 exercise data', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider.value(
          value: planBloc,
          child: ExerciseList([]),
        ),
      ));
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('render delete dialog when slide card', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider.value(
          value: planBloc,
          child: ExerciseList(mockExercise),
        ),
      ));
      await tester.drag(find.byType(Card).first, Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('คุณต้องการลบกิจกรรมนี้หรือไม่'), findsOneWidget);
      expect(find.text('ตกลง'), findsOneWidget);
      expect(find.text('ยกเลิก'), findsOneWidget);
    });

    testWidgets('pop dialog when pressed cancle in delete dialog',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider.value(
          value: planBloc,
          child: ExerciseList(mockExercise),
        ),
      ));
      await tester.drag(find.byType(Card).first, Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('ยกเลิก'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(Card), findsNWidgets(3));
      expect(find.text('name1'), findsOneWidget);
      expect(find.text('name2'), findsOneWidget);
      expect(find.text('name3'), findsOneWidget);
      expect(find.text('30 นาที'), findsNWidgets(3));
      expect(find.text('300'), findsNWidgets(3));
      expect(find.text('แคล'), findsNWidgets(3));
    });

    testWidgets('delete exercise card when pressed ok in delete dialog',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: planBloc),
              BlocProvider.value(value: historyBloc),
            ],
            child: ExerciseList(mockExercise),
          ),
        ),
      );
      await tester.drag(
          find.byKey(ObjectKey(mockExercise[0])), Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('ตกลง'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('name1'), findsNothing);
      expect(find.text('name2'), findsOneWidget);
      expect(find.text('name3'), findsOneWidget);
      expect(find.text('30 นาที'), findsNWidgets(2));
      expect(find.text('300'), findsNWidgets(2));
      expect(find.text('แคล'), findsNWidgets(2));
    });
  });
}
