import 'package:foodandbody/models/confirm_password.dart';
import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/register/cubit/register_cubit.dart';
import 'package:foodandbody/screens/register/register_form.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenRepository {}

class MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

class FakeRegisterState extends Fake implements RegisterState {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements Password {}

class MockConfirmedPassword extends Mock implements ConfirmedPassword {}

void main() {
  const registerButtonKey = Key('registerForm_continue_raisedButton');
  const emailInputKey = Key('registerForm_emailInput_textField');
  const passwordInputKey = Key('registerForm_passwordInput_textField');
  const confirmedPasswordInputKey =
      Key('registerForm_confirmedPasswordInput_textField');
  const passwordVisibilityIconKey = Key('registerForm_password_visibilityIcon');
  const confirmPasswordVisibilityIconKey =
      Key('registerForm_confirmPassword_visibilityIcon');

  const testEmail = 'test@gmail.com';
  const testPassword = 'testP@ssw0rd1';
  const testConfirmedPassword = 'testP@ssw0rd1';
  const iconVisibility = 'Icon(IconData(U+0E6BD))';
  const iconVisibilityOff = 'Icon(IconData(U+0E6BE))';

  group('RegisterForm', () {
    late RegisterCubit registerCubit;

    setUpAll(() {
      registerFallbackValue<RegisterState>(FakeRegisterState());
    });

    setUp(() {
      registerCubit = MockRegisterCubit();
      when(() => registerCubit.state).thenReturn(const RegisterState());
      when(() => registerCubit.registerFormSubmitted())
          .thenAnswer((_) async {});
    });

    group('calls', () {
      testWidgets('emailChanged when email changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => registerCubit.emailChanged(testEmail)).called(1);
      });

      testWidgets('passwordChanged when password changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(() => registerCubit.passwordChanged(testPassword)).called(1);
      });

      testWidgets('confirmedPasswordChanged when confirmedPassword changes',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        await tester.enterText(
            find.byKey(confirmedPasswordInputKey), testConfirmedPassword);
        verify(() =>
                registerCubit.confirmedPasswordChanged(testConfirmedPassword))
            .called(1);
      });

      testWidgets('registerFormSubmitted when sign up button is pressed',
          (tester) async {
        when(() => registerCubit.state).thenReturn(
          const RegisterState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(registerButtonKey));
        verify(() => registerCubit.registerFormSubmitted()).called(1);
      });
    });

    group('renders', () {
      testWidgets('failure SnackBar when submission status is fails',
          (tester) async {
        whenListen(
          registerCubit,
          Stream.fromIterable(const <RegisterState>[
            RegisterState(status: FormzStatus.submissionInProgress),
            RegisterState(status: FormzStatus.submissionFailure),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('Register Failure'), findsOneWidget);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.invalid).thenReturn(true);
        when(() => registerCubit.state).thenReturn(RegisterState(email: email));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        expect(find.text('invalid email'), findsOneWidget);
      });

      testWidgets('invalid password error text when password is invalid',
          (tester) async {
        final password = MockPassword();
        when(() => password.invalid).thenReturn(true);
        when(() => registerCubit.state)
            .thenReturn(RegisterState(password: password));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        expect(find.text('invalid password'), findsOneWidget);
      });

      testWidgets(
          'invalid confirmedPassword error text'
          ' when confirmedPassword is invalid', (tester) async {
        final confirmedPassword = MockConfirmedPassword();
        when(() => confirmedPassword.invalid).thenReturn(true);
        when(() => registerCubit.state)
            .thenReturn(RegisterState(confirmedPassword: confirmedPassword));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        expect(find.text('passwords do not match'), findsOneWidget);
      });

      testWidgets('disabled sign up button when status is not validated',
          (tester) async {
        when(() => registerCubit.state).thenReturn(
          const RegisterState(status: FormzStatus.invalid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        final registerButton = tester.widget<ElevatedButton>(
          find.byKey(registerButtonKey),
        );
        expect(registerButton.enabled, isFalse);
      });

      testWidgets('enabled sign up button when status is validated',
          (tester) async {
        when(() => registerCubit.state).thenReturn(
          const RegisterState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        final registerButton = tester.widget<ElevatedButton>(
          find.byKey(registerButtonKey),
        );
        expect(registerButton.enabled, isTrue);
      });

      testWidgets('password visible when password visibility icon is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        var input1 = tester.widget<TextField>(find.byKey(passwordInputKey));
        var icon1 =
            tester.widget<InkWell>(find.byKey(passwordVisibilityIconKey));
        expect(input1.obscureText, true);
        expect(icon1.child.toString(), iconVisibility);

        await tester.tap(find.byKey(passwordVisibilityIconKey));
        await tester.pump();

        var input2 = tester.widget<TextField>(find.byKey(passwordInputKey));
        var icon2 =
            tester.widget<InkWell>(find.byKey(passwordVisibilityIconKey));
        expect(icon2.child.toString(), iconVisibilityOff);
        expect(input2.obscureText, false);
      });

      testWidgets(
          'confirmPassword visible when confirmPassword visibility icon is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: registerCubit,
                child: const RegisterForm(),
              ),
            ),
          ),
        );
        var input1 = tester
            .firstWidget<TextField>(find.byKey(confirmedPasswordInputKey));
        var icon1 = tester
            .widget<InkWell>(find.byKey(confirmPasswordVisibilityIconKey));
        expect(input1.obscureText, true);
        expect(icon1.child.toString(), iconVisibility);

        await tester.tap(find.byKey(confirmPasswordVisibilityIconKey));
        await tester.pump();

        var input2 = tester
            .firstWidget<TextField>(find.byKey(confirmedPasswordInputKey));
        var icon2 = tester
            .widget<InkWell>(find.byKey(confirmPasswordVisibilityIconKey));
        expect(input2.obscureText, false);
        expect(icon2.child.toString(), iconVisibilityOff);
      });
    });

    testWidgets('navigates pop when submission status is success',
        (tester) async {
      whenListen(
        registerCubit,
        Stream.fromIterable(const <RegisterState>[
          RegisterState(status: FormzStatus.submissionInProgress),
          RegisterState(status: FormzStatus.submissionSuccess),
        ]),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: registerCubit,
              child: const RegisterForm(),
            ),
          ),
        ),
      );
      expect(find.byType(RegisterForm), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(RegisterForm), findsNothing);
    });
  });
}
