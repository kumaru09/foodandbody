import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:foodandbody/screens/edit_profile/edit_profile.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockEditProfileCubit extends MockCubit<EditProfileState>
    implements EditProfileCubit {}

class FakeEditProfileState extends Fake implements EditProfileState {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockUsername extends Mock implements Username {}

class MockGender extends Mock implements Gender {}

void main() {
  const usernameInputKey = Key('editProfile_username');
  const genderInputKey = Key('editProfile_gender');
  const image = Key('editProfile_image');
  const editImageButton = Key('editProfile_editImageButton');
  const saveButton = Key('editProfile_saveButton');
  const backButton = Key('editProfile_backButton');

  const testUsername = 'test_name123';
  const testGender = 'หญิง';

  const mockUid = 's1uskWSx4NeSECk8gs2R9bofrG23';
  const mockName = 'user';
  const mockGender = 'M';
  // const mockPictureUrl ;
  final Info mockInfo = Info(name: mockName, gender: mockGender, photoUrl: '');
  final User mockUser = User(uid: mockUid, name: mockName, info: mockInfo);

  group('EditProfile', () {
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
      when(() => editProfileCubit.editFormSubmitted()).thenAnswer((_) async {});
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
                child: EditProfile(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('แก้ไขโปรไฟล์'), findsOneWidget);
      expect(find.byKey(saveButton), findsOneWidget);
      expect(find.byKey(backButton), findsOneWidget);
      expect(find.byKey(usernameInputKey), findsOneWidget);
      expect(find.byKey(genderInputKey), findsOneWidget);
      expect(find.byKey(image), findsOneWidget);
    });

    group('calls', () {
      testWidgets('usernameChanged when username changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditProfile(),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(usernameInputKey), testUsername);
        verify(() => editProfileCubit.usernameChanged(testUsername)).called(1);
      });

      // testWidgets('photoUrlChanged when photoUrl changes', (tester) async {
      //   await tester.pumpWidget(
      //     MaterialApp(
      //       home: Scaffold(
      //         body: BlocProvider.value(
      //           value: appBloc,
      //           child: BlocProvider.value(
      //             value: editProfileCubit,
      //             child: EditProfile(),
      //           ),
      //         ),
      //       ),
      //     ),
      //   );
      //   await tester.tap(find.byKey(editImageButton));
      //   await tester.pump();
      //   await tester.tap(find.text('แกลลอรี'));
      //   //choose picture
      //   verify(() => editProfileCubit.photoUrlChanged(testUsername)).called(1);
      // });

      testWidgets('genderChanged when gender changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditProfile(),
                ),
              ),
            ),
          ),
        );
        var input1 = tester.widget<DropdownButtonFormField<String>>(
            find.byKey(genderInputKey));
        expect(input1.initialValue, 'M');

        await tester.tap(find.byKey(genderInputKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text(testGender).last);
        await tester.pumpAndSettle();

        verify(() => editProfileCubit.genderChanged('F')).called(1);
      });

      testWidgets('editFormSubmitted when save button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditProfile(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(saveButton));
        verify(() => editProfileCubit.editFormSubmitted()).called(1);
      });
    });

    group('after edit renders', () {
      testWidgets('EditProfile Failure SnackBar when submission fails',
          (tester) async {
        whenListen(
          editProfileCubit,
          Stream.fromIterable(const <EditProfileState>[
            EditProfileState(status: FormzStatus.submissionInProgress),
            EditProfileState(status: FormzStatus.submissionFailure),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditProfile(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
            find.text('แก้ไขข้อมูลไม่สำเร็จ กรุณาลองอีกครั้ง'), findsOneWidget);
      });

      testWidgets('EditProfile success SnackBar when submission success',
          (tester) async {
        whenListen(
          editProfileCubit,
          Stream.fromIterable(const <EditProfileState>[
            EditProfileState(status: FormzStatus.submissionInProgress),
            EditProfileState(status: FormzStatus.submissionSuccess),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditProfile(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
            find.text('แก้ไขข้อมูลเรียบร้อยแล้ว'), findsOneWidget);
      });

      testWidgets('invalid username error text when username is invalid',
          (tester) async {
        final username = MockUsername();
        when(() => username.invalid).thenReturn(true);
        when(() => editProfileCubit.state)
            .thenReturn(EditProfileState(name: username));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: appBloc,
                child: BlocProvider.value(
                  value: editProfileCubit,
                  child: EditProfile(),
                ),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุชื่อผู้ใช้งาน'), findsOneWidget);
      });
    });
  });
}
