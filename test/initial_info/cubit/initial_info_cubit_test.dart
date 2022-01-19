import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodandbody/models/birth_date.dart';
import 'package:foodandbody/models/exercise.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/initial_info/cubit/initial_info_cubit.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidUsernameString = '';
  const invalidUsername = Username.dirty(invalidUsernameString);

  const validUsernameString = 'valid';
  const validUsername = Username.dirty(validUsernameString);

  const invalidWeightString = 'invalid';
  const invalidWeight = Weight.dirty(invalidWeightString);

  const validWeightString = '50';
  const validWeight = Weight.dirty(validWeightString);

  const invalidHeightString = 'invalid';
  const invalidHeight = Height.dirty(invalidHeightString);

  const validHeightString = '150';
  const validHeight = Height.dirty(validHeightString);

  const invalidBDateString = 'invalid';
  const invalidBDate = BDate.dirty(invalidBDateString);

  const validBDateString = '2000-08-15 00:00:00.000';
  const validBDate = BDate.dirty(validBDateString);

  const invalidGenderString = '';
  const invalidGender = Gender.dirty(invalidGenderString);

  const validGenderString = 'หญิง';
  const validGender = Gender.dirty(validGenderString);

  const invalidExerciseString = 'invalid';
  const invalidExercise = Exercise.dirty(invalidExerciseString);

  const validExerciseString = '1.55';
  const validExercise = Exercise.dirty(validExerciseString);

  int _mockCalculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int cMonth = currentDate.month;
    int bMonth = birthDate.month;
    if (bMonth > cMonth ||
        (cMonth == bMonth && birthDate.day > currentDate.day)) age--;
    return age;
  }

  int age = _mockCalculateAge(DateTime.parse(validBDateString));
  double bmr = 665 + (9.6 * 50) + (1.8 * 150) - (4.7 * age);
  double tdee = bmr.round() * 1.55;
  int validGoal = tdee.round();

  // const uid = 's1uskWSx4NeSECk8gs2R9bofrG23';

  group('InitialInfoCubit', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
    });

    test('initial state is InitialInfoState', () {
      expect(InitialInfoCubit(userRepository).state, InitialInfoState());
    });

    group('usernameChanged', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [invalid] when username are invalid',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.usernameChanged(invalidUsernameString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
              username: invalidUsername, status: FormzStatus.invalid),
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [valid] when username are valid',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          weight: validWeight,
          height: validHeight,
          bDate: validBDate,
          gender: validGender,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.usernameChanged(validUsernameString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('weightChanged', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [invalid] when weight are invalid',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.weightChanged(invalidWeightString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            weight: invalidWeight,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [valid] when weight are valid',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          username: validUsername,
          height: validHeight,
          bDate: validBDate,
          gender: validGender,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.weightChanged(validWeightString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('heightChanged', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [invalid] when height are invalid',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.heightChanged(invalidHeightString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            height: invalidHeight,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [valid] when height are valid',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          username: validUsername,
          weight: validWeight,
          bDate: validBDate,
          gender: validGender,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.heightChanged(validHeightString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('bDateChanged', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [invalid] when bDate are invalid',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.bDateChanged(invalidBDateString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            bDate: invalidBDate,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [valid] when bDate are valid',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          username: validUsername,
          weight: validWeight,
          height: validHeight,
          gender: validGender,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.bDateChanged(validBDateString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('GenderChanged', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [invalid] when gender are invalid',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.genderChanged(invalidGenderString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            gender: invalidGender,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [valid] when gender are valid',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          username: validUsername,
          weight: validWeight,
          height: validHeight,
          bDate: validBDate,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.genderChanged(validGenderString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('ExerciseChanged', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [invalid] when exercise are invalid',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.exerciseChanged(invalidExerciseString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            exercise: invalidExercise,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [valid] when exercise are valid',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          username: validUsername,
          weight: validWeight,
          height: validHeight,
          bDate: validBDate,
          gender: validGender,
        ),
        act: (cubit) => cubit.exerciseChanged(validExerciseString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('initialInfoFormSubmitted', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'does nothing when status is not validated',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.initialInfoFormSubmitted(),
        expect: () => const <InitialInfoState>[],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'calls initialInfo with correct username/weight/height/gender/calory ',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          status: FormzStatus.valid,
          username: validUsername,
          weight: validWeight,
          height: validHeight,
          bDate: validBDate,
          gender: validGender,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.initialInfoFormSubmitted(),
        verify: (_) {
          verify(
            () => userRepository.addUserInfo(Info(
              name: validUsernameString,
              weight: int.parse(validWeightString),
              height: int.parse(validHeightString),
              birthDate: Timestamp.fromDate(DateTime.parse(validBDateString)),
              gender: validGenderString,
              goal: validGoal,
              photoUrl: '',
            )),
          ).called(1);
        },
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when initialInfo succeeds',
        build: () {
          when(
            () => userRepository.addUserInfo(Info(
              name: validUsernameString,
              weight: int.parse(validWeightString),
              height: int.parse(validHeightString),
              birthDate: Timestamp.fromDate(DateTime.parse(validBDateString)),
              gender: validGenderString,
              goal: validGoal,
              photoUrl: '',
            )),
          ).thenAnswer((_) async {});
          return InitialInfoCubit(userRepository);
        },
        seed: () => InitialInfoState(
          status: FormzStatus.valid,
          username: validUsername,
          weight: validWeight,
          height: validHeight,
          bDate: validBDate,
          gender: validGender,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.initialInfoFormSubmitted(),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            status: FormzStatus.submissionInProgress,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
          ),
          InitialInfoState(
            status: FormzStatus.submissionSuccess,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
          )
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [submissionInProgress, submissionFailure] '
        'when initialInfo fails',
        build: () {
          when(
            () => userRepository.addUserInfo(Info(
              name: validUsernameString,
              weight: int.parse(validWeightString),
              height: int.parse(validHeightString),
              birthDate: Timestamp.fromDate(DateTime.parse(validBDateString)),
              gender: validGenderString,
              goal: validGoal,
              photoUrl: '',
            )),
          ).thenThrow(Exception('oops'));
          return InitialInfoCubit(userRepository);
        },
        seed: () => InitialInfoState(
          status: FormzStatus.valid,
          username: validUsername,
          weight: validWeight,
          height: validHeight,
          bDate: validBDate,
          gender: validGender,
          exercise: validExercise,
        ),
        act: (cubit) => cubit.initialInfoFormSubmitted(),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            status: FormzStatus.submissionInProgress,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
          ),
          InitialInfoState(
            status: FormzStatus.submissionFailure,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            bDate: validBDate,
            gender: validGender,
            exercise: validExercise,
          )
        ],
      );
    });
  });
}
