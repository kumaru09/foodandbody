import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/exercise_time.dart';
import 'package:foodandbody/models/exercise_type.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockPlan extends Mock implements History {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class FakeExerciseRepo extends Fake implements ExerciseRepo {}

void main() {
  const String name = 'อาหาร';
  const double volume = 5.5;
  const String id = '2';
  const int min = 30;
  const int weight = 50;
  const String type = '2';
  const String time = '30';
  const String goal = '1600';
  const Calory validGoal = Calory.dirty(goal);
  const Calory invalidGoal = Calory.dirty('');
  final ExerciseRepo exercise = ExerciseRepo(
      id: id,
      name: 'วิ่ง',
      min: min,
      calory: 157.5,
      timestamp: Timestamp.now());
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
  const ExerciseType validExerciseType = ExerciseType.dirty(type);
  const ExerciseType invalidExerciseType = ExerciseType.dirty('');
  const ExerciseTime validExerciseTime = ExerciseTime.dirty(time);
  const ExerciseTime invalidExerciseTime = ExerciseTime.dirty('');

  group('PlanBloc', () {
    late PlanRepository planRepository;
    late UserRepository userRepository;
    late PlanBloc planBloc;

    setUpAll(() {
      registerFallbackValue<ExerciseRepo>(FakeExerciseRepo());
    });

    setUp(() {
      planRepository = MockPlanRepository();
      userRepository = MockUserRepository();
      planBloc = PlanBloc(
          planRepository: planRepository, userRepository: userRepository);
    });

    group('LoadPlan', () {
      blocTest<PlanBloc, PlanState>(
        'emits successful status when fetched initial plan',
        setUp: () {
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
          when(() => userRepository.getInfo(true))
              .thenAnswer((_) async => mockInfo);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(LoadPlan()),
        expect: () => <PlanState>[
          PlanState(status: PlanStatus.loading),
          PlanState(
            status: PlanStatus.success,
            plan: mockPlan,
            info: mockInfo,
            goal: validGoal,
            exerciseStatus: FormzStatus.submissionSuccess,
          )
        ],
        verify: (_) {
          verify(() => planRepository.getPlanById()).called(1);
          verify(() => userRepository.getInfo(true)).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits loading status during process',
        setUp: () {
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
          when(() => userRepository.getInfo(true))
              .thenAnswer((_) async => mockInfo);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(LoadPlan()),
        expect: () => <PlanState>[
          PlanState(status: PlanStatus.loading),
          PlanState(
            status: PlanStatus.success,
            plan: mockPlan,
            info: mockInfo,
            goal: validGoal,
            exerciseStatus: FormzStatus.submissionSuccess,
          )
        ],
        verify: (_) {
          verify(() => planRepository.getPlanById()).called(1);
          verify(() => userRepository.getInfo(true)).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure status when planRepository getPlanById throw exception',
        setUp: () {
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => throw Exception());
          when(() => userRepository.getInfo(true))
              .thenAnswer((_) async => mockInfo);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(LoadPlan()),
        expect: () => <PlanState>[
          PlanState(status: PlanStatus.loading),
          PlanState(
              status: PlanStatus.failure,
              exerciseStatus: FormzStatus.submissionFailure),
        ],
        verify: (_) {
          verify(() => planRepository.getPlanById()).called(1);
          verifyNever(() => userRepository.getInfo(true));
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure status when userRepository getInfo throw exception',
        setUp: () {
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
          when(() => userRepository.getInfo(true))
              .thenAnswer((_) async => throw Exception());
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(LoadPlan()),
        expect: () => <PlanState>[
          PlanState(status: PlanStatus.loading),
          PlanState(
              status: PlanStatus.failure,
              exerciseStatus: FormzStatus.submissionFailure),
        ],
        verify: (_) {
          verify(() => planRepository.getPlanById()).called(1);
          verify(() => userRepository.getInfo(true)).called(1);
        },
      );
    });

    group('DeleteMenu', () {
      blocTest<PlanBloc, PlanState>(
        'emits successful deleteMenuStatus when delete menu plan success',
        setUp: () {
          when(() => planRepository.deletePlan(name, volume))
              .thenAnswer((_) async {});
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(DeleteMenu(name: name, volume: volume)),
        expect: () => <PlanState>[
          PlanState(
              deleteMenuStatus: DeleteMenuStatus.loading, isDeleteMenu: true),
          PlanState(deleteMenuStatus: DeleteMenuStatus.success)
        ],
        verify: (_) {
          verify(() => planRepository.deletePlan(name, volume)).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits loading deleteMenuStatus during process',
        setUp: () {
          when(() => planRepository.deletePlan(name, volume))
              .thenAnswer((_) async {});
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(DeleteMenu(name: name, volume: volume)),
        expect: () => <PlanState>[
          PlanState(
              deleteMenuStatus: DeleteMenuStatus.loading, isDeleteMenu: true),
          PlanState(
            deleteMenuStatus: DeleteMenuStatus.success,
          )
        ],
        verify: (_) {
          verify(() => planRepository.deletePlan(name, volume)).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure deleteMenuStatus when planRepository deletePlan throw exception',
        setUp: () {
          when(() => planRepository.deletePlan(name, volume))
              .thenAnswer((_) async => throw Exception());
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(DeleteMenu(name: name, volume: volume)),
        expect: () => <PlanState>[
          PlanState(
              deleteMenuStatus: DeleteMenuStatus.loading, isDeleteMenu: true),
          PlanState(deleteMenuStatus: DeleteMenuStatus.failure)
        ],
        verify: (_) {
          verify(() => planRepository.deletePlan(name, volume)).called(1);
        },
      );
    });

    group('AddExercise', () {
      blocTest<PlanBloc, PlanState>(
        'emits successful exerciseStatus when add exercise success',
        setUp: () {
          when(() => planRepository.addExercise(any()))
              .thenAnswer((_) async {});
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(AddExercise(id: id, min: min, weight: weight)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(
              exerciseStatus: FormzStatus.submissionSuccess, plan: mockPlan),
        ],
        verify: (_) {
          verify(() => planRepository.addExercise(any())).called(1);
          verify(() => planRepository.getPlanById()).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits loading exerciseStatus during process',
        setUp: () {
          when(() => planRepository.addExercise(any()))
              .thenAnswer((_) async {});
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(AddExercise(id: id, min: min, weight: weight)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(
              exerciseStatus: FormzStatus.submissionSuccess, plan: mockPlan),
        ],
        verify: (_) {
          verify(() => planRepository.addExercise(any())).called(1);
          verify(() => planRepository.getPlanById()).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure exerciseStatus when planRepository addExercise throw exception',
        setUp: () {
          when(() => planRepository.addExercise(any()))
              .thenAnswer((_) async => throw Exception());
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(AddExercise(id: id, min: min, weight: weight)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(exerciseStatus: FormzStatus.submissionFailure),
        ],
        verify: (_) {
          verify(() => planRepository.addExercise(any())).called(1);
          verifyNever(() => planRepository.getPlanById());
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure exerciseStatus when planRepository getPlanById throw exception',
        setUp: () {
          when(() => planRepository.addExercise(any()))
              .thenAnswer((_) async => {});
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(AddExercise(id: id, min: min, weight: weight)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(exerciseStatus: FormzStatus.submissionFailure),
        ],
        verify: (_) {
          verify(() => planRepository.addExercise(any())).called(1);
          verify(() => planRepository.getPlanById()).called(1);
        },
      );
    });

    group('ExerciseTypeChange', () {
      blocTest<PlanBloc, PlanState>(
        'emits valid exerciseStatus when exerciseType is valid',
        build: () => planBloc,
        seed: () => PlanState(exerciseTime: validExerciseTime),
        act: (bloc) => bloc.add(ExerciseTypeChange(value: type)),
        expect: () => <PlanState>[
          PlanState(
            exerciseStatus: FormzStatus.valid,
            exerciseType: validExerciseType,
            exerciseTime: validExerciseTime,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'emits invalid exerciseStatus when exerciseType is invalid',
        build: () => planBloc,
        seed: () => PlanState(exerciseTime: validExerciseTime),
        act: (bloc) => bloc.add(ExerciseTypeChange(value: '')),
        expect: () => <PlanState>[
          PlanState(
            exerciseStatus: FormzStatus.invalid,
            exerciseType: invalidExerciseType,
            exerciseTime: validExerciseTime,
          ),
        ],
      );
    });

    group('ExerciseTimeChange', () {
      blocTest<PlanBloc, PlanState>(
        'emits valid exerciseStatus when exerciseTime is valid',
        build: () => planBloc,
        seed: () => PlanState(exerciseType: validExerciseType),
        act: (bloc) => bloc.add(ExerciseTimeChange(value: time)),
        expect: () => <PlanState>[
          PlanState(
            exerciseStatus: FormzStatus.valid,
            exerciseTime: validExerciseTime,
            exerciseType: validExerciseType,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'emits invalid exerciseStatus when exerciseTime is invalid',
        build: () => planBloc,
        seed: () => PlanState(exerciseType: validExerciseType),
        act: (bloc) => bloc.add(ExerciseTimeChange(value: '')),
        expect: () => <PlanState>[
          PlanState(
            exerciseStatus: FormzStatus.invalid,
            exerciseTime: invalidExerciseTime,
            exerciseType: validExerciseType,
          ),
        ],
      );
    });

    group('DeleteExercise', () {
      blocTest<PlanBloc, PlanState>(
        'emits successful exerciseStatus when delete exercise success',
        setUp: () {
          when(() => planRepository.deleteExercise(any()))
              .thenAnswer((_) async {});
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(DeleteExercise(exerciseRepo: exercise)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(
              exerciseStatus: FormzStatus.submissionSuccess, plan: mockPlan),
        ],
        verify: (_) {
          verify(() => planRepository.deleteExercise(any())).called(1);
          verify(() => planRepository.getPlanById()).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits loading exerciseStatus during process',
        setUp: () {
          when(() => planRepository.deleteExercise(any()))
              .thenAnswer((_) async {});
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(DeleteExercise(exerciseRepo: exercise)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(
              exerciseStatus: FormzStatus.submissionSuccess, plan: mockPlan),
        ],
        verify: (_) {
          verify(() => planRepository.deleteExercise(any())).called(1);
          verify(() => planRepository.getPlanById()).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure exerciseStatus when planRepository deleteExercise throw exception',
        setUp: () {
          when(() => planRepository.deleteExercise(any()))
              .thenAnswer((_) async => throw Exception());
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => mockPlan);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(DeleteExercise(exerciseRepo: exercise)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(exerciseStatus: FormzStatus.submissionFailure),
        ],
        verify: (_) {
          verify(() => planRepository.deleteExercise(any())).called(1);
          verifyNever(() => planRepository.getPlanById());
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure exerciseStatus when planRepository getPlanById throw exception',
        setUp: () {
          when(() => planRepository.deleteExercise(any()))
              .thenAnswer((_) async {});
          when(() => planRepository.getPlanById())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(DeleteExercise(exerciseRepo: exercise)),
        expect: () => <PlanState>[
          PlanState(exerciseStatus: FormzStatus.submissionInProgress),
          PlanState(exerciseStatus: FormzStatus.submissionFailure),
        ],
        verify: (_) {
          verify(() => planRepository.deleteExercise(any())).called(1);
          verify(() => planRepository.getPlanById()).called(1);
        },
      );
    });

    group('UpdateGoal', () {
      blocTest<PlanBloc, PlanState>(
        'emits successful goalStatus when update goal success',
        setUp: () {
          when(() => userRepository.updateGoalInfo(int.parse(goal)))
              .thenAnswer((_) async {});
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(UpdateGoal(goal: goal)),
        expect: () => <PlanState>[
          PlanState(
            goalStatus: FormzStatus.submissionInProgress,
            isDeleteMenu: false,
          ),
          PlanState(
            goalStatus: FormzStatus.submissionSuccess,
            goal: validGoal,
            isDeleteMenu: false,
          )
        ],
        verify: (_) {
          verify(() => userRepository.updateGoalInfo(int.parse(goal)))
              .called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits loading goalStatus during process',
         setUp: () {
          when(() => userRepository.updateGoalInfo(int.parse(goal)))
              .thenAnswer((_) async {});
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(UpdateGoal(goal: goal)),
        expect: () => <PlanState>[
          PlanState(
            goalStatus: FormzStatus.submissionInProgress,
            isDeleteMenu: false,
          ),
          PlanState(
            goalStatus: FormzStatus.submissionSuccess,
            goal: validGoal,
            isDeleteMenu: false,
          )
        ],
        verify: (_) {
          verify(() => userRepository.updateGoalInfo(int.parse(goal)))
              .called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure goalStatus when userRepository updateGoalInfo throw exception',
        setUp: () {
          when(() => userRepository.updateGoalInfo(int.parse(goal)))
              .thenAnswer((_) async => throw Exception());
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(UpdateGoal(goal: goal)),
        expect: () => <PlanState>[
          PlanState(
            goalStatus: FormzStatus.submissionInProgress,
            isDeleteMenu: false,
          ),
          PlanState(
            goalStatus: FormzStatus.submissionFailure,
            isDeleteMenu: false,
          )
        ],
        verify: (_) {
          verify(() => userRepository.updateGoalInfo(int.parse(goal)))
              .called(1);
          verifyNever(() => userRepository.getInfo());
        },
      );

      blocTest<PlanBloc, PlanState>(
        'emits failure goalStatus when userRepository getInfo throw exception',
        setUp: () {
          when(() => userRepository.updateGoalInfo(int.parse(goal)))
              .thenAnswer((_) async {});
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => planBloc,
        act: (bloc) => bloc.add(UpdateGoal(goal: goal)),
        expect: () => <PlanState>[
          PlanState(
            goalStatus: FormzStatus.submissionInProgress,
            isDeleteMenu: false,
          ),
          PlanState(
            goalStatus: FormzStatus.submissionFailure,
            isDeleteMenu: false,
          )
        ],
        verify: (_) {
          verify(() => userRepository.updateGoalInfo(int.parse(goal)))
              .called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );
    });

    group('GoalChange', () {
      blocTest<PlanBloc, PlanState>(
        'emits valid goalStatus when exerciseTime is valid',
        build: () => planBloc,
        act: (bloc) => bloc.add(GoalChange(value: goal)),
        expect: () => <PlanState>[
          PlanState(
            goalStatus: FormzStatus.valid,
            goal: validGoal,
          ),
        ],
      );

      blocTest<PlanBloc, PlanState>(
        'emits invalid goalStatus when exerciseTime is invalid',
        build: () => planBloc,
        act: (bloc) => bloc.add(GoalChange(value: '')),
        expect: () => <PlanState>[
          PlanState(
            goalStatus: FormzStatus.invalid,
            goal: invalidGoal,
          ),
        ],
      );
    });

  });
}
