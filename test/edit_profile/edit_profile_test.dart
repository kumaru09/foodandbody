import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:foodandbody/screens/edit_profile/edit_profile.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockEditProfileCubit extends MockCubit<EditProfileState>
    implements EditProfileCubit {}

class FakeEditProfileState extends Fake implements EditProfileState {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockUsername extends Mock implements Username {}

class MockGender extends Mock implements Gender {}

class MockUserRepository extends Mock implements UserRepository {}

class MockInfoCache extends Mock implements InfoCache {}

void main() {
  const usernameInputKey = Key('editProfile_username');
  const genderInputKey = Key('editProfile_gender');
  const image = Key('editProfile_image');
  // const editImageButton = Key('editProfile_editImageButton');
  const saveButton = Key('editProfile_saveButton');
  const backButton = Key('editProfile_backButton');

  const testUsername = 'test_name123';
  const testGender = 'หญิง';

  const mockUid = 's1uskWSx4NeSECk8gs2R9bofrG23';

  const invalidUsernameString = '';
  const invalidUsername = Username.dirty(invalidUsernameString);

  const validUsernameString = 'user';
  const validUsername = Username.dirty(validUsernameString);

  const validGenderString = 'M';
  const validGender = Gender.dirty(validGenderString);

  const mockImgUrl = 'imgurl';
  const mockErrorMessage = 'แก้ไขข้อมูลไม่สำเร็จ กรุณาลองใหม่';

  final Info mockInfo = Info(
      name: validUsernameString,
      gender: validGenderString,
      photoUrl: mockImgUrl);
  final User mockUser = User(uid: mockUid, name: validUsernameString);

  group('EditProfile', () {
    late EditProfileCubit editProfileCubit;
    late AppBloc appBloc;
    late UserRepository userRepository;
    late InfoCache infoCache;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<EditProfileState>(FakeEditProfileState());
    });

    setUp(() {
      appBloc = MockAppBloc();
      editProfileCubit = MockEditProfileCubit();
      userRepository = MockUserRepository();
      infoCache = MockInfoCache();
      when(() => editProfileCubit.state).thenReturn(const EditProfileState(
          name: validUsername, gender: validGender, photoUrl: mockImgUrl));
      when(() => editProfileCubit.editProfileSubmitted())
          .thenAnswer((_) async {});
      when(() => appBloc.state).thenReturn(AppState.authenticated(mockUser));
      when(() => userRepository.getInfo()).thenAnswer((_) async {});
      when(() => userRepository.cache).thenReturn(infoCache);
      when(() => infoCache.get()).thenReturn(mockInfo);
    });

    testWidgets('renders all widget right at initial', (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          RepositoryProvider.value(
            value: userRepository,
            child: MaterialApp(
              home: Scaffold(
                body: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: appBloc),
                    BlocProvider.value(value: editProfileCubit),
                  ],
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
    });

    group('calls', () {
      testWidgets('usernameChanged when username changes', (tester) async {
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
                    child: EditProfile(),
                  ),
                ),
              ),
            ),
          );
          await tester.enterText(find.byKey(usernameInputKey), testUsername);
          verify(() => editProfileCubit.usernameChanged(testUsername))
              .called(1);
        });
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
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
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
      });

      testWidgets('editProfileSubmitted when save button is pressed',
          (tester) async {
        when(() => editProfileCubit.state).thenReturn(const EditProfileState(
            name: validUsername,
            gender: validGender,
            photoUrl: mockImgUrl,
            statusProfile: FormzStatus.valid));
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
                    child: EditProfile(),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(saveButton));
          verify(() => editProfileCubit.editProfileSubmitted()).called(1);
        });
      });
    });

    group('renders', () {
      testWidgets('failure SnackBar when submission fails', (tester) async {
        whenListen(
          editProfileCubit,
          Stream.fromIterable(const <EditProfileState>[
            EditProfileState(statusProfile: FormzStatus.submissionInProgress),
            EditProfileState(
                statusProfile: FormzStatus.submissionFailure,
                errorMessage: mockErrorMessage),
          ]),
        );
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
                    child: EditProfile(),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          expect(
              find.text('แก้ไขข้อมูลไม่สำเร็จ กรุณาลองใหม่'), findsOneWidget);
        });
      });

      testWidgets('success SnackBar when submission success', (tester) async {
        whenListen(
          editProfileCubit,
          Stream.fromIterable(const <EditProfileState>[
            EditProfileState(statusProfile: FormzStatus.submissionInProgress),
            EditProfileState(statusProfile: FormzStatus.submissionSuccess),
          ]),
        );
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
                    child: EditProfile(),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          expect(find.text('แก้ไขข้อมูลเรียบร้อยแล้ว'), findsOneWidget);
        });
      });

      testWidgets('invalid username error text when username is invalid',
          (tester) async {
        final username = MockUsername();
        when(() => username.invalid).thenReturn(true);
        when(() => editProfileCubit.state).thenReturn(EditProfileState(
            name: invalidUsername, gender: validGender, photoUrl: mockImgUrl));
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
                    child: EditProfile(),
                  ),
                ),
              ),
            ),
          );
          expect(find.text('กรุณาระบุชื่อผู้ใช้งาน'), findsOneWidget);
        });
      });

      testWidgets("disabled save button when status is not validated",
          (tester) async {
        when(() => editProfileCubit.state).thenReturn(EditProfileState(
            statusProfile: FormzStatus.invalid,
            name: validUsername,
            gender: validGender,
            photoUrl: mockImgUrl));
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
                    child: EditProfile(),
                  ),
                ),
              ),
            ),
          );
          final TextButton button = tester.widget(find.byKey(saveButton));
          expect(button.enabled, isFalse);
        });
      });

      testWidgets("enabled save button when status is validated",
          (tester) async {
        when(() => editProfileCubit.state).thenReturn(EditProfileState(
            statusProfile: FormzStatus.valid,
            name: validUsername,
            gender: validGender,
            photoUrl: mockImgUrl));
        mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            RepositoryProvider.value(
              value: userRepository,
              child: MaterialApp(
                home: Scaffold(
                  body: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: appBloc),
                      BlocProvider.value(value: editProfileCubit),
                    ],
                    child: EditProfile(),
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
  });
}
