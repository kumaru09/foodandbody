// ignore_for_file: prefer_const_constructors
import 'package:foodandbody/models/confirm_password.dart';
import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/register/cubit/register_cubit.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 't0pS3cret1234';
  const validPassword = Password.dirty(validPasswordString);

  const invalidConfirmedPasswordString = 'invalid';
  const invalidConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: invalidConfirmedPasswordString,
  );

  const validConfirmedPasswordString = 't0pS3cret1234';
  const validConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: validConfirmedPasswordString,
  );

  group('RegisterCubit', () {
    late AuthenRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async {});
      when(() => authenticationRepository.sendVerifyEmail())
          .thenAnswer((_) async {});
    });

    test('initial state is RegisterState', () {
      expect(RegisterCubit(authenticationRepository).state, RegisterState());
    });

    group('emailChanged', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => RegisterCubit(authenticationRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => const <RegisterState>[
          RegisterState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => RegisterCubit(authenticationRepository),
        seed: () => RegisterState(
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => const <RegisterState>[
          RegisterState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => RegisterCubit(authenticationRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <RegisterState>[
          RegisterState(
            confirmedPassword: ConfirmedPassword.dirty(
              password: invalidPasswordString,
            ),
            password: invalidPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => RegisterCubit(authenticationRepository),
        seed: () => RegisterState(
          email: validEmail,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.passwordChanged(validPasswordString),
        expect: () => const <RegisterState>[
          RegisterState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [valid] when confirmedPasswordChanged is called first and then '
        'passwordChanged is called',
        build: () => RegisterCubit(authenticationRepository),
        seed: () => RegisterState(
          email: validEmail,
        ),
        act: (cubit) => cubit
          ..confirmedPasswordChanged(validConfirmedPasswordString)
          ..passwordChanged(validPasswordString),
        expect: () => const <RegisterState>[
          RegisterState(
            email: validEmail,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.invalid,
          ),
          RegisterState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('confirmedPasswordChanged', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => RegisterCubit(authenticationRepository),
        act: (cubit) =>
            cubit.confirmedPasswordChanged(invalidConfirmedPasswordString),
        expect: () => const <RegisterState>[
          RegisterState(
            confirmedPassword: invalidConfirmedPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => RegisterCubit(authenticationRepository),
        seed: () => RegisterState(email: validEmail, password: validPassword),
        act: (cubit) => cubit.confirmedPasswordChanged(
          validConfirmedPasswordString,
        ),
        expect: () => const <RegisterState>[
          RegisterState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [valid] when passwordChanged is called first and then '
        'confirmedPasswordChanged is called',
        build: () => RegisterCubit(authenticationRepository),
        seed: () => RegisterState(
          email: validEmail,
        ),
        act: (cubit) => cubit
          ..passwordChanged(validPasswordString)
          ..confirmedPasswordChanged(validConfirmedPasswordString),
        expect: () => const <RegisterState>[
          RegisterState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: ConfirmedPassword.dirty(
              password: validPasswordString,
            ),
            status: FormzStatus.invalid,
          ),
          RegisterState(
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('registerFormSubmitted', () {
      blocTest<RegisterCubit, RegisterState>(
        'does nothing when status is not validated',
        build: () => RegisterCubit(authenticationRepository),
        act: (cubit) => cubit.registerFormSubmitted(),
        expect: () => const <RegisterState>[],
      );

      blocTest<RegisterCubit, RegisterState>(
        'calls register with correct email/password/confirmedPassword',
        build: () => RegisterCubit(authenticationRepository),
        seed: () => RegisterState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.registerFormSubmitted(),
        verify: (_) {
          verify(
            () => authenticationRepository.signUp(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when register succeeds',
        build: () => RegisterCubit(authenticationRepository),
        seed: () => RegisterState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.registerFormSubmitted(),
        expect: () => const <RegisterState>[
          RegisterState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          ),
          RegisterState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          )
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [submissionInProgress, submissionFailure] '
        'when signUp() throw Exception',
        build: () {
          when(() => authenticationRepository.signUp(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenThrow(Exception());
          return RegisterCubit(authenticationRepository);
        },
        seed: () => RegisterState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.registerFormSubmitted(),
        expect: () => const <RegisterState>[
          RegisterState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          ),
          RegisterState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          )
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits [submissionInProgress, submissionFailure] '
        'when sendVerifyEmail() throw Exception',
        build: () {
          when(() => authenticationRepository.sendVerifyEmail())
              .thenThrow(Exception());
          return RegisterCubit(authenticationRepository);
        },
        seed: () => RegisterState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ),
        act: (cubit) => cubit.registerFormSubmitted(),
        expect: () => const <RegisterState>[
          RegisterState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          ),
          RegisterState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
            confirmedPassword: validConfirmedPassword,
          )
        ],
      );
    });
  });
}
