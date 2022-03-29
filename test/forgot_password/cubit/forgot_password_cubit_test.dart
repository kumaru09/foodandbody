import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenRepository extends Mock implements AuthenRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  group('ForgotPasswordCubit', () {
    late AuthenRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenRepository();
      when(() => authenticationRepository.sendForgetPasswordEmail(any()))
          .thenAnswer((_) async {});
    });

    test('initial state is ForgotPasswordState', () {
      expect(ForgotPasswordCubit(authenticationRepository).state,
          ForgotPasswordState());
    });

    group('emailChanged', () {
      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'emits [invalid] when email are invalid',
        build: () => ForgotPasswordCubit(authenticationRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'emits [valid] when email are valid',
        build: () => ForgotPasswordCubit(authenticationRepository),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            email: validEmail,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('forgotPasswordSubmitted', () {
      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'does nothing when status is not validated',
        build: () => ForgotPasswordCubit(authenticationRepository),
        act: (cubit) => cubit.forgotPasswordSubmitted(),
        expect: () => <ForgotPasswordState>[],
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'calls sendForgetPasswordEmail with correct email',
        build: () => ForgotPasswordCubit(authenticationRepository),
        seed: () => ForgotPasswordState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (cubit) => cubit.forgotPasswordSubmitted(),
        verify: (_) {
          verify(
            () => authenticationRepository
                .sendForgetPasswordEmail(validEmailString),
          ).called(1);
        },
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when process succeeds',
        build: () => ForgotPasswordCubit(authenticationRepository),
        seed: () => ForgotPasswordState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (cubit) => cubit.forgotPasswordSubmitted(),
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          ForgotPasswordState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
          )
        ],
      );

      blocTest<ForgotPasswordCubit, ForgotPasswordState>(
        'emits [submissionInProgress, submissionFailure] '
        'when process fails',
        build: () {
          when(
            () => authenticationRepository.sendForgetPasswordEmail(any()),
          ).thenThrow(Exception('oops'));
          return ForgotPasswordCubit(authenticationRepository);
        },
        seed: () => ForgotPasswordState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (cubit) => cubit.forgotPasswordSubmitted(),
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          ForgotPasswordState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
          )
        ],
      );
    });
  });
}
