import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/exercise_time.dart';
import 'package:foodandbody/models/exercise_type.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockPlan extends Mock implements History {}

void main() {
  const PlanStatus mockStatus = PlanStatus.initial;
  History mockPlan = History(Timestamp.now());
  Info mockInfo = Info();
  const FormzStatus mockGoalStatus = FormzStatus.pure;
  const Calory mockGoal = Calory.pure();
  const DeleteMenuStatus mockDeleteMenuStatus = DeleteMenuStatus.initial;
  const bool mockIsDeleteMenu = true;
  const FormzStatus mockExerciseStatus = FormzStatus.pure;
  const ExerciseType mockExerciseType = ExerciseType.pure();
  const ExerciseTime mockExerciseTime = ExerciseTime.pure();
  group('PlanState', () {
    PlanState createSubject({
      PlanStatus? status,
      History? plan,
      Info? info,
      FormzStatus? goalStatus,
      Calory? goal,
      DeleteMenuStatus? deleteMenuStatus,
      bool? isDeleteMenu,
      FormzStatus? exerciseStatus,
      ExerciseType? exerciseType,
      ExerciseTime? exerciseTime,
    }) {
      return PlanState(
        status: status ?? mockStatus,
        plan: plan ?? mockPlan,
        info: info ?? mockInfo,
        goalStatus: goalStatus ?? mockGoalStatus,
        goal: goal ?? mockGoal,
        deleteMenuStatus: deleteMenuStatus ?? mockDeleteMenuStatus,
        isDeleteMenu: isDeleteMenu ?? mockIsDeleteMenu,
        exerciseStatus: exerciseStatus ?? mockExerciseStatus,
        exerciseType: exerciseType ?? mockExerciseType,
        exerciseTime: exerciseTime ?? mockExerciseTime,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(PlanState(plan: mockPlan), PlanState(plan: mockPlan));
      expect(
        PlanState(plan: mockPlan).toString(),
        PlanState(plan: mockPlan).toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: mockStatus,
          plan: mockPlan,
          info: mockInfo,
          goalStatus: mockGoalStatus,
          goal: mockGoal,
          deleteMenuStatus: mockDeleteMenuStatus,
          isDeleteMenu: mockIsDeleteMenu,
          exerciseStatus: mockExerciseStatus,
          exerciseType: mockExerciseType,
          exerciseTime: mockExerciseTime,
        ).props,
        equals(<Object?>[
          mockStatus,
          mockPlan,
          mockInfo,
          mockGoalStatus,
          mockGoal,
          mockDeleteMenuStatus,
          mockIsDeleteMenu,
          mockExerciseStatus,
          mockExerciseType,
          mockExerciseTime,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            plan: null,
            info: null,
            goalStatus: null,
            goal: null,
            deleteMenuStatus: null,
            isDeleteMenu: null,
            exerciseStatus: null,
            exerciseType: null,
            exerciseTime: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: mockStatus,
            plan: mockPlan,
            info: mockInfo,
            goalStatus: mockGoalStatus,
            goal: mockGoal,
            deleteMenuStatus: mockDeleteMenuStatus,
            isDeleteMenu: mockIsDeleteMenu,
            exerciseStatus: mockExerciseStatus,
            exerciseType: mockExerciseType,
            exerciseTime: mockExerciseTime,
          ),
          equals(
            createSubject(
              status: mockStatus,
              plan: mockPlan,
              info: mockInfo,
              goalStatus: mockGoalStatus,
              goal: mockGoal,
              deleteMenuStatus: mockDeleteMenuStatus,
              isDeleteMenu: mockIsDeleteMenu,
              exerciseStatus: mockExerciseStatus,
              exerciseType: mockExerciseType,
              exerciseTime: mockExerciseTime,
            ),
          ),
        );
      });
    });
  });
}
