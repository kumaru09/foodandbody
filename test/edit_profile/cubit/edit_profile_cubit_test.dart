import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/confirm_password.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidUsernameString = '';
  const invalidUsername = Username.dirty(invalidUsernameString);

  const validUsernameString = 'valid';
  const validUsername = Username.dirty(validUsernameString);

  const invalidGenderString = '';
  const invalidGender = Gender.dirty(invalidGenderString);

  const validGenderString = 'F';
  const validGender = Gender.dirty(validGenderString);

  const invalidPasswordString = '';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 'test1234';
  const validPassword = Password.dirty(validPasswordString);

  const invalidConfirmedPasswordString = '';
  const invalidConfirmedPassword = ConfirmedPassword.dirty(
      password: validPasswordString, value: invalidConfirmedPasswordString);

  const validConfirmedPasswordString = 'test1234';
  const validConfirmedPassword = ConfirmedPassword.dirty(
      password: validPasswordString, value: validConfirmedPasswordString);

  const invalidOldPasswordString = '';
  const invalidOldPassword = Password.dirty(invalidOldPasswordString);

  const validOldPasswordString = 'test9876';
  const validOldPassword = Password.dirty(validOldPasswordString);

  // const uid = 's1uskWSx4NeSECk8gs2R9bofrG23';
  const mockImgUrl = 'imgurl';

  late UserRepository userRepository;

  setUp(() {
    userRepository = MockUserRepository();
    when(() => userRepository.updatePassword(
        validPasswordString, validOldPasswordString)).thenAnswer((_) async {});
    when(() => userRepository.updateInfo(Info(
        name: validUsernameString,
        gender: validGenderString,
        photoUrl: mockImgUrl))).thenAnswer((_) async {});
  });

  group('EditProfileCubit', () {
    test('initial state is EditProfileState', () {
      expect(EditProfileCubit(userRepository).state, EditProfileState());
    });

    group('usernameChanged', () {
      blocTest<EditProfileCubit, EditProfileState>(
        'emits [invalid] when username are invalid',
        build: () => EditProfileCubit(userRepository)
          ..initProfile(
              name: 'user', gender: validGenderString, photoUrl: mockImgUrl),
        act: (cubit) => cubit.usernameChanged(invalidUsernameString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            name: invalidUsername,
            gender: validGender,
            photoUrl: mockImgUrl,
            statusProfile: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<EditProfileCubit, EditProfileState>(
        'emits [valid] when username are valid',
        build: () => EditProfileCubit(userRepository)
          ..initProfile(
              name: 'user', gender: validGenderString, photoUrl: mockImgUrl),
        act: (cubit) => cubit.usernameChanged(validUsernameString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            name: validUsername,
            gender: validGender,
            photoUrl: mockImgUrl,
            statusProfile: FormzStatus.valid,
          ),
        ],
      );
    });

    group('GenderChanged', () {
      blocTest<EditProfileCubit, EditProfileState>(
        'emits [invalid] when gender are invalid',
        build: () => EditProfileCubit(userRepository)
          ..initProfile(
              name: validUsernameString, gender: 'M', photoUrl: mockImgUrl),
        act: (cubit) => cubit.genderChanged(invalidGenderString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            name: validUsername,
            gender: invalidGender,
            photoUrl: mockImgUrl,
            statusProfile: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<EditProfileCubit, EditProfileState>(
        'emits [valid] when gender are valid',
        build: () => EditProfileCubit(userRepository)
          ..initProfile(
              name: validUsernameString, gender: 'M', photoUrl: mockImgUrl),
        act: (cubit) => cubit.genderChanged(validGenderString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            name: validUsername,
            gender: validGender,
            photoUrl: mockImgUrl,
            statusProfile: FormzStatus.valid,
          ),
        ],
      );
    });

    blocTest<EditProfileCubit, EditProfileState>(
      'photoUrlChanged emits photoUrl',
      build: () => EditProfileCubit(userRepository)
        ..initProfile(
            name: validUsernameString,
            gender: validGenderString,
            photoUrl: 'mockImgUrl'),
      act: (cubit) => cubit.photoUrlChanged(mockImgUrl),
      expect: () => const <EditProfileState>[
        EditProfileState(
          name: validUsername,
          gender: validGender,
          photoUrl: mockImgUrl,
          statusProfile: FormzStatus.valid,
        ),
      ],
    );

    group('oldPasswordChanged', () {
      blocTest<EditProfileCubit, EditProfileState>(
        'emits [invalid] when oldPassword are invalid',
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.oldPasswordChanged(invalidOldPasswordString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            oldPassword: invalidOldPassword,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            statusPassword: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<EditProfileCubit, EditProfileState>(
        'emits [valid] when password are valid',
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.oldPasswordChanged(validOldPasswordString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            oldPassword: validOldPassword,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            statusPassword: FormzStatus.valid,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<EditProfileCubit, EditProfileState>(
        'emits [invalid] when password are invalid',
        build: () => EditProfileCubit(userRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            password: invalidPassword,
            confirmedPassword: ConfirmedPassword.dirty(
              password: invalidPasswordString,
            ),
            statusPassword: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<EditProfileCubit, EditProfileState>(
        'emits [valid] when password are valid',
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          oldPassword: validOldPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            oldPassword: validOldPassword,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            statusPassword: FormzStatus.valid,
          ),
        ],
      );
    });

    group('confirmedPasswordChanged', () {
      blocTest<EditProfileCubit, EditProfileState>(
        'emits [invalid] when confirmedPassword are invalid',
        build: () => EditProfileCubit(userRepository),
        act: (cubit) =>
            cubit.confirmedPasswordChanged(invalidConfirmedPasswordString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            confirmedPassword: invalidConfirmedPassword,
            statusPassword: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<EditProfileCubit, EditProfileState>(
        'emits [valid] when confirmedPassword are valid',
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          oldPassword: validOldPassword,
          password: validPassword,
        ),
        act: (cubit) =>
            cubit.confirmedPasswordChanged(validConfirmedPasswordString),
        expect: () => const <EditProfileState>[
          EditProfileState(
            oldPassword: validOldPassword,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            statusPassword: FormzStatus.valid,
          ),
        ],
      );
    });

    group('editProfileSubmitted', () {
      blocTest<EditProfileCubit, EditProfileState>(
        'emit submissionSuccess when call updateInfo pass',
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          statusProfile: FormzStatus.valid,
          name: validUsername,
          gender: validGender,
          photoUrl: mockImgUrl,
        ),
        act: (cubit) => cubit.editProfileSubmitted(),
        expect: () => const <EditProfileState>[
          EditProfileState(
            statusProfile: FormzStatus.submissionSuccess,
            name: validUsername,
            gender: validGender,
            photoUrl: mockImgUrl,
          )
        ],
        verify: (_) => verify(() => userRepository.updateInfo(Info(
            name: validUsernameString,
            photoUrl: mockImgUrl,
            gender: validGenderString))).called(1),
      );

      blocTest<EditProfileCubit, EditProfileState>(
        'emit submissionSuccess when call updateInfo then throw Exception()',
        setUp: () => when(() => userRepository.updateInfo(Info(
            name: validUsernameString,
            gender: validGenderString,
            photoUrl: mockImgUrl))).thenAnswer((_) => throw Exception()),
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          statusProfile: FormzStatus.valid,
          name: validUsername,
          gender: validGender,
          photoUrl: mockImgUrl,
        ),
        act: (cubit) => cubit.editProfileSubmitted(),
        expect: () => const <EditProfileState>[
          EditProfileState(
            statusProfile: FormzStatus.submissionFailure,
            name: validUsername,
            gender: validGender,
            photoUrl: mockImgUrl,
          )
        ],
        verify: (_) => verify(() => userRepository.updateInfo(Info(
            name: validUsernameString,
            photoUrl: mockImgUrl,
            gender: validGenderString))).called(1),
      );
    });

    group('editPasswordSubmitted', () {
      blocTest<EditProfileCubit, EditProfileState>(
        'emit submissionSuccess when call updatePassword pass',
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
          oldPassword: validOldPassword,
        ),
        act: (cubit) => cubit.editPasswordSubmitted(),
        expect: () => const <EditProfileState>[
          EditProfileState(
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            oldPassword: validOldPassword,
            statusPassword: FormzStatus.submissionSuccess,
          ),
        ],
        verify: (_) {
          verify(
            () => userRepository.updatePassword(
                validPasswordString, validOldPasswordString),
          ).called(1);
        },
      );

      blocTest<EditProfileCubit, EditProfileState>(
        'emit submissionFailure when call updatePassword then throw Exception',
        setUp: () => when(() => userRepository.updatePassword(
                validPasswordString, validOldPasswordString))
            .thenAnswer((_) => throw Exception()),
        build: () => EditProfileCubit(userRepository),
        seed: () => EditProfileState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
          oldPassword: validOldPassword,
        ),
        act: (cubit) => cubit.editPasswordSubmitted(),
        expect: () => const <EditProfileState>[
          EditProfileState(
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            oldPassword: validOldPassword,
            statusPassword: FormzStatus.submissionFailure,
          ),
        ],
        verify: (_) {
          verify(
            () => userRepository.updatePassword(
                validPasswordString, validOldPasswordString),
          ).called(1);
        },
      );
    });
  });
}
