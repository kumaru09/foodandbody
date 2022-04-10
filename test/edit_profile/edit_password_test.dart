import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/confirm_password.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:foodandbody/screens/edit_profile/edit_password.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockEditProfileCubit extends MockCubit<EditProfileState>
    implements EditProfileCubit {}

class FakeEditProfileState extends Fake implements EditProfileState {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  const oldPasswordInputKey = Key('editPassword_oldPassword_textFormField');
  const passwordInputKey = Key('editPassword_password_textFormField');
  const confirmPasswordInputKey =
      Key('editPassword_confirmedPassword_textFormField');
  const saveButton = Key('editPassword_saveButton');
  const backButton = Key('editPassword_backButton');

  const mockUid = 's1uskWSx4NeSECk8gs2R9bofrG23';
  const mockName = 'user';

  const invalidPasswordString = '';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 'test1234';
  const validPassword = Password.dirty(validPasswordString);

  const invalidConfirmedPasswordString = 'wrong';
  const invalidConfirmedPassword = ConfirmedPassword.dirty(
      password: validPasswordString, value: invalidConfirmedPasswordString);

  const validConfirmedPasswordString = 'test1234';
  const validConfirmedPassword = ConfirmedPassword.dirty(
      password: validPasswordString, value: validConfirmedPasswordString);

  const invalidOldPasswordString = '';
  const invalidOldPassword = Password.dirty(invalidOldPasswordString);

  const validOldPasswordString = 'test9876';
  const validOldPassword = Password.dirty(validOldPasswordString);

  const mockErrorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่';

  final User mockUser = User(uid: mockUid, name: mockName);

  group('EditPassword', () {
    late EditProfileCubit editProfileCubit;
    late AppBloc appBloc;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<EditProfileState>(FakeEditProfileState());
    });

    setUp(() {
      appBloc = MockAppBloc();
      editProfileCubit = MockEditProfileCubit();
      when(() => editProfileCubit.state).thenReturn(const EditProfileState());
      when(() => editProfileCubit.editPasswordSubmitted())
          .thenAnswer((_) async {});
      when(() => appBloc.state).thenReturn(AppState.authenticated(mockUser));
    });

    testWidgets('renders all widget right at initial', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: appBloc,
              child: BlocProvider.value(
                value: editProfileCubit,
                child: EditPassword(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('แก้ไขรหัสผ่าน'), findsOneWidget);
      expect(find.byKey(saveButton), findsOneWidget);
      expect(find.byKey(backButton), findsOneWidget);
      expect(find.byKey(oldPasswordInputKey), findsOneWidget);
      expect(find.byKey(passwordInputKey), findsOneWidget);
      expect(find.byKey(confirmPasswordInputKey), findsOneWidget);
    });

    group('calls', () {
      testWidgets('oldPasswordChanged when oldPassword changes',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
            find.byKey(oldPasswordInputKey), validOldPasswordString);
        verify(() =>
                editProfileCubit.oldPasswordChanged(validOldPasswordString))
            .called(1);
      });

      testWidgets('passwordChanged when password changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
            find.byKey(passwordInputKey), validPasswordString);
        verify(() => editProfileCubit.passwordChanged(validPasswordString))
            .called(1);
      });

      testWidgets('confirmPasswordChanged when confirmPassword changes',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
            find.byKey(confirmPasswordInputKey), validConfirmedPasswordString);
        verify(() => editProfileCubit
            .confirmedPasswordChanged(validConfirmedPasswordString)).called(1);
      });

      testWidgets('editPasswordSubmitted when save button is pressed',
          (tester) async {
        when(() => editProfileCubit.state).thenReturn(const EditProfileState(
          statusPassword: FormzStatus.valid,
          oldPassword: validOldPassword,
          password: validPassword,
          confirmedPassword: validConfirmedPassword,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(saveButton));
        verify(() => editProfileCubit.editPasswordSubmitted()).called(1);
      });
    });

    group('renders', () {
      testWidgets('Failure SnackBar when submission fails', (tester) async {
        whenListen(
          editProfileCubit,
          Stream.fromIterable(const <EditProfileState>[
            EditProfileState(statusPassword: FormzStatus.submissionInProgress),
            EditProfileState(
                statusPassword: FormzStatus.submissionFailure,
                errorMessage: mockErrorMessage),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('เกิดข้อผิดพลาด กรุณาลองใหม่'), findsOneWidget);
      });

      testWidgets('success SnackBar when submission success', (tester) async {
        whenListen(
          editProfileCubit,
          Stream.fromIterable(const <EditProfileState>[
            EditProfileState(statusPassword: FormzStatus.submissionInProgress),
            EditProfileState(statusPassword: FormzStatus.submissionSuccess),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('เปลี่ยนรหัสผ่านเรียบร้อยแล้ว'), findsOneWidget);
      });

      testWidgets('invalid oldPassword error text when oldPassword is invalid',
          (tester) async {
        when(() => editProfileCubit.state)
            .thenReturn(EditProfileState(oldPassword: invalidOldPassword));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        expect(
            find.text(
                'รหัสผ่านอย่างน้อย 8 ตัว มีตัวอักษรตัวเล็ก ตัวใหญ๋ และตัวเลข'),
            findsOneWidget);
      });

      testWidgets('invalid password error text when password is invalid',
          (tester) async {
        when(() => editProfileCubit.state)
            .thenReturn(EditProfileState(password: invalidPassword));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        expect(
            find.text(
                'รหัสผ่านอย่างน้อย 8 ตัว มีตัวอักษรตัวเล็ก ตัวใหญ๋ และตัวเลข'),
            findsOneWidget);
      });

      testWidgets(
          'invalid password error text when password and oldPassword are same',
          (tester) async {
        when(() => editProfileCubit.state).thenReturn(EditProfileState(
            oldPassword: validPassword, password: validPassword));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('รหัสผ่านใหม่ซ้ำกับรหัสผ่านเดิม'), findsOneWidget);
      });

      testWidgets(
          'invalid confirmedPassword error text when confirmedPassword is invalid',
          (tester) async {
        when(() => editProfileCubit.state).thenReturn(EditProfileState(
            password: validPassword,
            confirmedPassword: invalidConfirmedPassword));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('รหัสผ่านไม่ตรงกัน'), findsOneWidget);
      });

      testWidgets("disabled save button when status is not validated",
          (tester) async {
        when(() => editProfileCubit.state)
            .thenReturn(EditProfileState(statusPassword: FormzStatus.invalid));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        final TextButton button = tester.widget(find.byKey(saveButton));
        expect(button.enabled, isFalse);
      });

      testWidgets("enabled save button when status is validated",
          (tester) async {
        when(() => editProfileCubit.state)
            .thenReturn(EditProfileState(statusPassword: FormzStatus.valid));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditPassword(),
                ),
              ),
            ),
          ),
        );
        final TextButton button = tester.widget(find.byKey(saveButton));
        expect(button.enabled, isTrue);
      });
    });
  });
}
