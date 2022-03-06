import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';

void main() {
  final List<ExerciseRepo> mockExerciseList = [ExerciseRepo(id: 'id', name: 'name', min: 30, calory: 300, timestamp: Timestamp.fromDate(DateTime.now()))];
  final int mockWater = 5;
  group('HomeState', () {

    HomeState createSubject({
      HomeStatus status = HomeStatus.initial,
      int? water,
      List<ExerciseRepo>? exerciseList,
    }) {
      return HomeState(
        status: status,
        water: water ?? mockWater,
        exerciseList: exerciseList ?? mockExerciseList,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(HomeState(), HomeState());
      expect(
        HomeState().toString(),
        HomeState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: HomeStatus.initial,
          water: mockWater,
          exerciseList: mockExerciseList,
        ).props,
        equals(<Object?>[
          HomeStatus.initial,
          mockWater, 
          mockExerciseList, 
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
            exerciseList: null,
            water: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: HomeStatus.success,
            exerciseList: mockExerciseList,
            water: mockWater,
          ),
          equals(
            createSubject(
              status: HomeStatus.success,
              exerciseList: mockExerciseList,
              water: mockWater,
            ),
          ),
        );
      });
    });
  });
}