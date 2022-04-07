import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:foodandbody/screens/forgot_password/forgot_password.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenRepository extends Mock implements AuthenRepository {}

class MockForgotPasswordCubit extends MockCubit<ForgotPasswordState>
    implements ForgotPasswordCubit {}

class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}

class MockEmail extends Mock implements Email {}

void main() {
  const getEmailWidget = Key('forgot_password_getEmailPage_widget');
  const sendEmailWidget = Key('forgot_password_sendEmailPage_widget');
  const emailInput = Key('forgot_password_emailInput_textField');
  const forgotPasswordButton = Key('forgot_password_continue_raisedButton');

  const testEmail = 'test@gmail.com';

  group('ForgotPassword', () {
    late ForgotPasswordCubit forgotPasswordCubit;
    late AuthenRepository authenRepository;

    setUpAll(() {
      registerFallbackValue<ForgotPasswordState>(FakeForgotPasswordState());
    });

    setUp(() {
      forgotPasswordCubit = MockForgotPasswordCubit();
      authenRepository = MockAuthenRepository();
      when(() => forgotPasswordCubit.state).thenReturn(ForgotPasswordState());
      when(() => forgotPasswordCubit.forgotPasswordSubmitted())
          .thenAnswer((_) async {});
    });

    group('calls', () {
      testWidgets('emailChanged when email changes', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: forgotPasswordCubit,
                child: ForgotPassword(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(emailInput), testEmail);
        await tester.pumpAndSettle();
        expect(find.text(testEmail), findsOneWidget);
        verify(() => forgotPasswordCubit.emailChanged(testEmail)).called(1);
      });

      testWidgets(
          'forgotPasswordSubmitted when forgotPasswordButton button is pressed',
          (tester) async {
        when(() => forgotPasswordCubit.state).thenReturn(
          ForgotPasswordState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: forgotPasswordCubit,
                child: ForgotPassword(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(forgotPasswordButton));
        verify(() => forgotPasswordCubit.forgotPasswordSubmitted()).called(1);
      });
    });

    group('renders', () {
      testWidgets('GetEmail widget when initial status', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: forgotPasswordCubit,
                child: ForgotPassword(),
              ),
            ),
          ),
        );
        expect(find.byKey(getEmailWidget), findsOneWidget);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.invalid).thenReturn(true);
        when(() => forgotPasswordCubit.state)
            .thenReturn(ForgotPasswordState(email: email));
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: forgotPasswordCubit,
                child: ForgotPassword(),
              ),
            ),
          ),
        );
        expect(find.text('invalid email'), findsOneWidget);
      });

      testWidgets(
          'disabled forgotPasswordButton button when status is not validated',
          (tester) async {
        when(() => forgotPasswordCubit.state).thenReturn(
          ForgotPasswordState(status: FormzStatus.invalid),
        );
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: forgotPasswordCubit,
                child: ForgotPassword(),
              ),
            ),
          ),
        );
        final button = tester.widget<ElevatedButton>(
          find.byKey(forgotPasswordButton),
        );
        expect(button.enabled, isFalse);
      });

      testWidgets(
          'enabled forgotPasswordButton button when status is validated',
          (tester) async {
        when(() => forgotPasswordCubit.state).thenReturn(
          ForgotPasswordState(status: FormzStatus.valid),
        );
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: forgotPasswordCubit,
                child: ForgotPassword(),
              ),
            ),
          ),
        );
        final button = tester.widget<ElevatedButton>(
          find.byKey(forgotPasswordButton),
        );
        expect(button.enabled, isTrue);
      });

      testWidgets(
          'SendMessageToEmail widget when isSubmissionSuccess status',
          (tester) async {
        when(() => forgotPasswordCubit.state).thenReturn(
            ForgotPasswordState(status: FormzStatus.submissionSuccess));
        await tester.pumpWidget(
          RepositoryProvider<AuthenRepository>(
            create: (_) => MockAuthenRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: forgotPasswordCubit,
                child: ForgotPassword(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(sendEmailWidget), findsOneWidget);
      });
    });

    // group('navigates', () {
    //   testWidgets('back to previous page when submission status is success',
    //       (tester) async {
    //     whenListen(
    //       forgotPasswordCubit,
    //       Stream.fromIterable(const <ForgotPasswordState>[
    //         ForgotPasswordState(status: FormzStatus.submissionInProgress),
    //         ForgotPasswordState(status: FormzStatus.submissionSuccess),
    //       ]),
    //     );
    //     await tester.pumpWidget(
    //       MaterialApp(
    //         home: Scaffold(
    //           body: BlocProvider.value(
    //             value: forgotPasswordCubit,
    //             child: const ForgotPassword(),
    //           ),
    //         ),
    //       ),
    //     );
    //     expect(find.byType(ForgotPassword), findsOneWidget);
    //     await tester.pumpAndSettle();
    //     expect(find.byType(ForgotPassword), findsNothing);
    //   });
    // });
  });
}
