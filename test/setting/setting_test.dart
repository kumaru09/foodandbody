import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as item;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:foodandbody/screens/edit_profile/edit_password.dart';
import 'package:foodandbody/screens/edit_profile/edit_profile.dart';
import 'package:foodandbody/screens/setting/cubit/delete_user_cubit.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppState extends Fake implements AppState {}

class FakeAppEvent extends Fake implements AppEvent {}

class MockEditProfileCubit extends MockCubit<EditProfileState>
    implements EditProfileCubit {}

class FakeEditProfileState extends Fake implements EditProfileState {}

class MockDeleteUserCubit extends MockCubit<DeleteUserState>
    implements DeleteUserCubit {}

class FakeDeleteUserState extends Fake implements DeleteUserState {}

class MockUserRepository extends Mock implements UserRepository {}

class MockInfoCache extends Mock implements InfoCache {}

class MockAuthenRepository extends Mock implements AuthenRepository {}

void main() {
  const mockUid = 's1uskWSx4NeSECk8gs2R9bofrG23';
  const mockUsername = 'user';
  const mockImgUrl = 'imgurl';
  const mockEmail = 'user@email.com';

  const validUsernameString = 'user';
  const validUsername = Username.dirty(validUsernameString);

  const validGenderString = 'M';
  const validGender = Gender.dirty(validGenderString);

  final Info? mockInfo =
      Info(name: mockUsername, gender: validGenderString, photoUrl: mockImgUrl);
  final User mockUser = User(
      uid: mockUid, email: mockEmail, name: mockUsername, photoUrl: mockImgUrl);
  final Map<String, String> mockUserInfo = {
    'displayName': mockUsername,
    'email': mockEmail,
    'photoURL': mockImgUrl,
    'providerId': 'email.com',
    'uid': mockUid
  };
  final List<item.UserInfo> mockAccountType = [item.UserInfo(mockUserInfo)];

  group('Setting', () {
    late AppBloc appBloc;
    late EditProfileCubit editProfileCubit;
    late DeleteUserCubit deleteUserCubit;
    late AuthenRepository authenRepository;
    late UserRepository userRepository;
    late InfoCache infoCache;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<EditProfileState>(FakeEditProfileState());
      registerFallbackValue<DeleteUserState>(FakeDeleteUserState());
    });

    setUp(() {
      appBloc = MockAppBloc();
      when(() => appBloc.state).thenReturn(AppState.authenticated(mockUser));
      deleteUserCubit = MockDeleteUserCubit();
      when(() => deleteUserCubit.state).thenReturn(DeleteUserState());
      editProfileCubit = MockEditProfileCubit();
      when(() => editProfileCubit.state).thenReturn(const EditProfileState(
          name: validUsername, gender: validGender, photoUrl: mockImgUrl));
      authenRepository = MockAuthenRepository();
      when(() => authenRepository.providerData).thenReturn(mockAccountType);
      userRepository = MockUserRepository();
      infoCache = MockInfoCache();
      when(() => userRepository.cache).thenReturn(infoCache);
      when(() => infoCache.get()).thenReturn(mockInfo);
    });

    testWidgets('render all widget correct', (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: deleteUserCubit,
                  child: SettingPage(),
                ),
              ),
            ),
          ),
        );
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('ตั้งค่า'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.text(mockUsername), findsOneWidget);
        expect(find.text(mockEmail), findsOneWidget);
        expect(find.text('โปรไฟล์'), findsOneWidget);
        expect(find.text('แก้ไขโปรไฟล์'), findsOneWidget);
        expect(find.text('แก้ไขรหัสผ่าน'), findsOneWidget);
        expect(find.text('ออกจากระบบ'), findsOneWidget);
        expect(find.text('บัญชี'), findsOneWidget);
        expect(find.text('ลบบัญชี'), findsOneWidget);
      });
    });

    testWidgets('not render editPasswordButton when providerId is google.com',
        (tester) async {
      mockNetworkImagesFor(() async {
        final Map<String, String> mockUserInfo = {
          'displayName': mockUsername,
          'email': mockEmail,
          'photoURL': mockImgUrl,
          'providerId': 'google.com',
          'uid': mockUid
        };
        final List<item.UserInfo> mockAccountType = [
          item.UserInfo(mockUserInfo)
        ];
        when(() => authenRepository.providerData).thenReturn(mockAccountType);
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: deleteUserCubit,
                  child: SettingPage(),
                ),
              ),
            ),
          ),
        );
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('ตั้งค่า'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.text(mockUsername), findsOneWidget);
        expect(find.text(mockEmail), findsOneWidget);
        expect(find.text('โปรไฟล์'), findsOneWidget);
        expect(find.text('แก้ไขโปรไฟล์'), findsOneWidget);
        expect(find.text('แก้ไขรหัสผ่าน'), findsNothing);
        expect(find.text('ออกจากระบบ'), findsOneWidget);
        expect(find.text('บัญชี'), findsOneWidget);
        expect(find.text('ลบบัญชี'), findsOneWidget);
      });
    });

    testWidgets('not render editPasswordButton when providerId is facebook.com',
        (tester) async {
      mockNetworkImagesFor(() async {
        final Map<String, String> mockUserInfo = {
          'displayName': mockUsername,
          'email': mockEmail,
          'photoURL': mockImgUrl,
          'providerId': 'facebook.com',
          'uid': mockUid
        };
        final List<item.UserInfo> mockAccountType = [
          item.UserInfo(mockUserInfo)
        ];
        when(() => authenRepository.providerData).thenReturn(mockAccountType);
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: deleteUserCubit,
                  child: SettingPage(),
                ),
              ),
            ),
          ),
        );
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('ตั้งค่า'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(find.text(mockUsername), findsOneWidget);
        expect(find.text(mockEmail), findsOneWidget);
        expect(find.text('โปรไฟล์'), findsOneWidget);
        expect(find.text('แก้ไขโปรไฟล์'), findsOneWidget);
        expect(find.text('แก้ไขรหัสผ่าน'), findsNothing);
        expect(find.text('ออกจากระบบ'), findsOneWidget);
        expect(find.text('บัญชี'), findsOneWidget);
        expect(find.text('ลบบัญชี'), findsOneWidget);
      });
    });

    testWidgets('render deleteAccount dialog when pressed deleteAccount button',
        (tester) async {
      mockNetworkImagesFor(() async {
        when(() => deleteUserCubit.deleteUser()).thenAnswer((_) async {});
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: deleteUserCubit,
                  child: SettingPage(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('ลบบัญชี'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('ลบบัญชีและข้อมูลทั้งหมดในบัญชี'), findsOneWidget);
        expect(find.text('ตกลง'), findsOneWidget);
        expect(find.text('ยกเลิก'), findsOneWidget);
      });
    });

    testWidgets(
        'close deleteAccount dialog and do nothing when pressed deleteAccount dialog cancel button',
        (tester) async {
      mockNetworkImagesFor(() async {
        when(() => deleteUserCubit.deleteUser()).thenAnswer((_) async {});
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: deleteUserCubit,
                  child: SettingPage(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('ลบบัญชี'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);
        await tester.tap(find.text('ยกเลิก'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        verifyNever(() => deleteUserCubit.deleteUser());
      });
    });

    // testWidgets('navigate to EditProfile when pressed editProfile button',
    //     (tester) async {
    //   mockNetworkImagesFor(() async {
    //     await tester.pumpWidget(
    //       RepositoryProvider<UserRepository>(
    //         create: (_) => MockUserRepository(),
    //         child: BlocProvider.value(
    //           value: appBloc,
    //           child: MaterialApp(
    //             home: BlocProvider.value(
    //               value: deleteUserCubit,
    //               child: SettingPage(),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //     await tester.tap(find.text('แก้ไขโปรไฟล์'));
    //     await tester.pump();
    //     expect(find.byType(EditProfile), findsOneWidget);
    //   });
    // });

    // testWidgets('navigate to EditPassword when pressed editPassword button',
    //     (tester) async {
    //   mockNetworkImagesFor(() async {
    //     await tester.pumpWidget(
    //       RepositoryProvider<UserRepository>(
    //         create: (_) => MockUserRepository(),
    //         child: BlocProvider.value(
    //           value: appBloc,
    //           child: MaterialApp(
    //             home: BlocProvider.value(
    //               value: deleteUserCubit,
    //               child: SettingPage(),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //     await tester.tap(find.text('แก้ไขรหัสผ่าน'));
    //     await tester.pump();
    //     expect(find.byType(EditPassword), findsOneWidget);
    //   });
    // });

    testWidgets('call appBloc AppLogoutRequested when pressed logout button',
        (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: deleteUserCubit,
                  child: SettingPage(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('ออกจากระบบ'));
        await tester.pumpAndSettle();
        verify(() => appBloc.add(AppLogoutRequested())).called(1);
      });
    });

    testWidgets(
        'call deleteUserCubit deleteUser when pressed deleteAccount dialog ok button',
        (tester) async {
      mockNetworkImagesFor(() async {
        when(() => deleteUserCubit.deleteUser()).thenAnswer((_) async {});
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: deleteUserCubit,
                  child: SettingPage(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('ลบบัญชี'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('ตกลง'));
        await tester.pumpAndSettle();
        verify(() => deleteUserCubit.deleteUser()).called(1);
      });
    });
  });
}
