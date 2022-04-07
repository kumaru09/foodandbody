import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';

void main() {
  const String name = 'อาหาร';
  const double volume = 5.5;
  const String id = 'test';
  const int min = 30;
  const int weight = 50;
  const String type = '2';
  const String time = '30';
  const String goal = '1600';
  ExerciseRepo exercise = ExerciseRepo(
      id: id, name: name, min: min, calory: 300, timestamp: Timestamp.now());
  group('PlanEvent', () {
    group('LoadPlan', () {
      group('isRefresh false', () {
        test('supports value equality', () {
          expect(
            LoadPlan(),
            equals(LoadPlan()),
          );
        });

        test('props are correct', () {
          expect(
            LoadPlan().props,
            equals(<Object?>[]),
          );
        });
      });

      group('isRefresh true', () {
        test('supports value equality', () {
          expect(
            LoadPlan(isRefresh: true),
            equals(LoadPlan(isRefresh: true)),
          );
        });

        test('props are correct', () {
          expect(
            LoadPlan(isRefresh: true).props,
            equals(<Object?>[]),
          );
        });
      });
    });

    group('DeleteMenu', () {
      test('supports value equality', () {
        expect(
          DeleteMenu(name: name, volume: volume),
          equals(DeleteMenu(name: name, volume: volume)),
        );
      });

      test('props are correct', () {
        expect(
          DeleteMenu(name: name, volume: volume).props,
          equals(<Object?>[name, volume]),
        );
      });
    });

    group('AddExercise', () {
      test('supports value equality', () {
        expect(
          AddExercise(id: id, min: min, weight: weight),
          equals(AddExercise(id: id, min: min, weight: weight)),
        );
      });

      test('props are correct', () {
        expect(
          AddExercise(id: id, min: min, weight: weight).props,
          equals(<Object?>[id, min, weight]),
        );
      });
    });

    group('ExerciseTypeChange', () {
      test('supports value equality', () {
        expect(
          ExerciseTypeChange(value: type),
          equals(ExerciseTypeChange(value: type)),
        );
      });

      test('props are correct', () {
        expect(
          ExerciseTypeChange(value: type).props,
          equals(<Object?>[type]),
        );
      });
    });

    group('ExerciseTimeChange', () {
      test('supports value equality', () {
        expect(
          ExerciseTimeChange(value: time),
          equals(ExerciseTimeChange(value: time)),
        );
      });

      test('props are correct', () {
        expect(
          ExerciseTimeChange(value: time).props,
          equals(<Object?>[time]),
        );
      });
    });

    group('DeleteExercise', () {
      test('supports value equality', () {
        expect(
          DeleteExercise(exerciseRepo: exercise),
          equals(DeleteExercise(exerciseRepo: exercise)),
        );
      });

      test('props are correct', () {
        expect(
          DeleteExercise(exerciseRepo: exercise).props,
          equals(<Object?>[exercise]),
        );
      });
    });

    group('UpdateGoal', () {
      test('supports value equality', () {
        expect(
          UpdateGoal(goal: goal),
          equals(UpdateGoal(goal: goal)),
        );
      });

      test('props are correct', () {
        expect(
          UpdateGoal(goal: goal).props,
          equals(<Object?>[goal]),
        );
      });
    });

    group('GoalChange', () {
      test('supports value equality', () {
        expect(
          GoalChange(value: goal),
          equals(GoalChange(value: goal)),
        );
      });

      test('props are correct', () {
        expect(
          GoalChange(value: goal).props,
          equals(<Object?>[goal]),
        );
      });
    });
  });
}
