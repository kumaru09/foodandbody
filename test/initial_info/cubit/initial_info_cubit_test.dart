import 'package:foodandbody/models/calory.dart';
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

  const invalidGenderString = '';
  const invalidGender = Gender.dirty(invalidGenderString);

  const validGenderString = 'ชาย';
  const validGender = Gender.dirty(validGenderString);

  const invalidCaloryString = 'invalid';
  const invalidCalory = Calory.dirty(invalidCaloryString);

  const validCaloryString = '1500';
  const validCalory = Calory.dirty(validCaloryString);

  const uid = 's1uskWSx4NeSECk8gs2R9bofrG23';

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
          gender: validGender,
          calory: validCalory,
        ),
        act: (cubit) => cubit.usernameChanged(validUsernameString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
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
          gender: validGender,
          calory: validCalory,
        ),
        act: (cubit) => cubit.weightChanged(validWeightString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
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
          gender: validGender,
          calory: validCalory,
        ),
        act: (cubit) => cubit.heightChanged(validHeightString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
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
          calory: validCalory,
        ),
        act: (cubit) => cubit.genderChanged(validGenderString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('caloryChanged', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [invalid] when calory are invalid',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.caloryChanged(invalidCaloryString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            calory: invalidCalory,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [valid] calory are valid',
        build: () => InitialInfoCubit(userRepository),
        seed: () => InitialInfoState(
          username: validUsername,
          weight: validWeight,
          height: validHeight,
          gender: validGender,
        ),
        act: (cubit) => cubit.caloryChanged(validCaloryString),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('initialInfoFormSubmitted', () {
      blocTest<InitialInfoCubit, InitialInfoState>(
        'does nothing when status is not validated',
        build: () => InitialInfoCubit(userRepository),
        act: (cubit) => cubit.initialInfoFormSubmitted(uid),
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
          gender: validGender,
          calory: validCalory,
        ),
        act: (cubit) => cubit.initialInfoFormSubmitted(uid),
        verify: (_) {
          verify(
            () => userRepository.addUserInfo(
                uid,
                Info(
                  name: validUsernameString,
                  weight: int.parse(validWeightString),
                  height: int.parse(validHeightString),
                  gender: validGenderString,
                  goal: int.parse(validCaloryString),
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
            () => userRepository.addUserInfo(
                uid,
                Info(
                  name: validUsernameString,
                  weight: int.parse(validWeightString),
                  height: int.parse(validHeightString),
                  gender: validGenderString,
                  goal: int.parse(validCaloryString),
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
          gender: validGender,
          calory: validCalory,
        ),
        act: (cubit) => cubit.initialInfoFormSubmitted(uid),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            status: FormzStatus.submissionInProgress,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
          ),
          InitialInfoState(
            status: FormzStatus.submissionSuccess,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
          )
        ],
      );

      blocTest<InitialInfoCubit, InitialInfoState>(
        'emits [submissionInProgress, submissionFailure] '
        'when initialInfo fails',
        build: () {
          when(
            () => userRepository.addUserInfo(
                uid,
                Info(
                  name: validUsernameString,
                  weight: int.parse(validWeightString),
                  height: int.parse(validHeightString),
                  gender: validGenderString,
                  goal: int.parse(validCaloryString),
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
          gender: validGender,
          calory: validCalory,
        ),
        act: (cubit) => cubit.initialInfoFormSubmitted(uid),
        expect: () => const <InitialInfoState>[
          InitialInfoState(
            status: FormzStatus.submissionInProgress,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
          ),
          InitialInfoState(
            status: FormzStatus.submissionFailure,
            username: validUsername,
            weight: validWeight,
            height: validHeight,
            gender: validGender,
            calory: validCalory,
          )
        ],
      );
    });
  });
}
