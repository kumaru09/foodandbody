import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/forgot_password/forgot_password.dart';
import 'package:foodandbody/screens/login/cubit/login_cubit.dart';
import 'package:foodandbody/screens/login/login_form.dart';
import 'package:foodandbody/screens/register/register.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock implements AuthenRepository {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class FakeLoginState extends Fake implements LoginState {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements Password {}

void main() {
  const loginButtonKey = Key('loginForm_continue_raisedButton');
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin');
  const signInWithFacebookButtonKey = Key('loginForm_facebookLogin');
  const emailInputKey = Key('loginForm_emailInput_textField');
  const passwordInputKey = Key('loginForm_passwordInput_textField');
  const createAccountButtonKey = Key('loginForm_createAccount');
  const forgotPasswordButtonKey = Key('loginForm_forgotPassword');
  const visibilityIconKey = Key('loginForm_visibilityIcon');

  const testEmail = 'test@gmail.com';
  const testPassword = 'testP@ssw0rd1';
  const testErrorMessage = 'errorMessage';

  group('LoginForm', () {
    late LoginCubit loginCubit;

    setUpAll(() {
      registerFallbackValue<LoginState>(FakeLoginState());
    });

    setUp(() {
      loginCubit = MockLoginCubit();
      when(() => loginCubit.state).thenReturn(const LoginState());
      when(() => loginCubit.logInWithGoogle()).thenAnswer((_) async {});
      when(() => loginCubit.logInWithFacebook()).thenAnswer((_) async {});
      when(() => loginCubit.logInWithCredentials()).thenAnswer((_) async {});
    });

    group('calls', () {
      testWidgets('emailChanged when email changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => loginCubit.emailChanged(testEmail)).called(1);
      });

      testWidgets('passwordChanged when password changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(() => loginCubit.passwordChanged(testPassword)).called(1);
      });

      testWidgets('logInWithCredentials when login button is pressed',
          (tester) async {
        when(() => loginCubit.state).thenReturn(
          const LoginState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(loginButtonKey));
        verify(() => loginCubit.logInWithCredentials()).called(1);
      });

      testWidgets('logInWithGoogle when sign in with google button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginCubit.logInWithGoogle()).called(1);
      });

        testWidgets('logInWithFacebook when sign in with facebook button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(signInWithFacebookButtonKey));
        verify(() => loginCubit.logInWithFacebook()).called(1);
      });
    });

    group('renders', () {
      testWidgets('AuthenticationFailure SnackBar when submission fails',
          (tester) async {
        whenListen(
          loginCubit,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzStatus.submissionInProgress),
            LoginState(status: FormzStatus.submissionFailure), 
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('ดำเนินการไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'), findsOneWidget);
      });

      testWidgets('AuthenticationFailure SnackBar with errormessage when submission fails and have errorMessage',
          (tester) async {
        whenListen(
          loginCubit,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzStatus.submissionInProgress),
            LoginState(status: FormzStatus.submissionFailure, errorMessage: testErrorMessage),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text(testErrorMessage), findsOneWidget);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.invalid).thenReturn(true);
        when(() => loginCubit.state).thenReturn(LoginState(email: email));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
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
        when(() => loginCubit.state).thenReturn(LoginState(password: password));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        expect(find.text('invalid password'), findsOneWidget);
      });

      testWidgets('disabled login button when status is not validated',
          (tester) async {
        when(() => loginCubit.state).thenReturn(
          const LoginState(status: FormzStatus.invalid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        final loginButton = tester.widget<ElevatedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isFalse);
      });

      testWidgets('enabled login button when status is validated',
          (tester) async {
        when(() => loginCubit.state).thenReturn(
          const LoginState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        final loginButton = tester.widget<ElevatedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isTrue);
      });

      testWidgets('Sign in with Google Button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });

       testWidgets('Sign in with Facebook Button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        expect(find.byKey(signInWithFacebookButtonKey), findsOneWidget);
      });

      testWidgets('password visible when visibility icon is press',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginForm(),
              ),
            ),
          ),
        );
        var input1 = tester.firstWidget<TextField>(find.byKey(passwordInputKey));
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(input1.obscureText, true);

        await tester.tap(find.byKey(visibilityIconKey));
        await tester.pump();

        var input2 = tester.firstWidget<TextField>(find.byKey(passwordInputKey));
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(input2.obscureText, false);
      });
    });

    group('navigates', () {
      testWidgets('to Register when ลงทะเบียน is pressed', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenticationRepository(),
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: loginCubit,
                  child: const LoginForm(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(createAccountButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(Register), findsOneWidget);
      });

      testWidgets('to ForgotPassword when ลืมรหัสผ่าน? is pressed',
          (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenticationRepository(),
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: loginCubit,
                  child: const LoginForm(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(forgotPasswordButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(ForgotPassword), findsOneWidget);
      });
    });
  });
}
