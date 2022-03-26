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
import 'package:foodandbody/screens/edit_profile/edit_password.dart';
import 'package:foodandbody/screens/edit_profile/edit_profile.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockInfoBloc extends MockBloc<InfoEvent, InfoState> implements InfoBloc {}

class FakeInfoState extends Fake implements InfoState {}

class FakeInfoEvent extends Fake implements InfoEvent {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppState extends Fake implements AppState {}

class FakeAppEvent extends Fake implements AppEvent {}

class MockEditProfileCubit extends MockCubit<EditProfileState>
    implements EditProfileCubit {}

class FakeEditProfileState extends Fake implements EditProfileState {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const mockUid = 's1uskWSx4NeSECk8gs2R9bofrG23';
  const mockUsername = 'user';
  const mockGender = 'M';
  const mockImgUrl = 'imgurl';
  const mockEmail = 'user@email.com';

  const validUsernameString = 'user';
  const validUsername = Username.dirty(validUsernameString);

  const validGenderString = 'M';
  const validGender = Gender.dirty(validGenderString);

  final Info mockInfo =
      Info(name: mockUsername, gender: mockGender, photoUrl: mockImgUrl);
  final User mockUser =
      User(uid: mockUid, email: mockEmail, name: mockUsername, info: mockInfo);

  group('Setting', () {
    late InfoBloc infoBloc;
    late AppBloc appBloc;
    late EditProfileCubit editProfileCubit;

    setUpAll(() {
      registerFallbackValue<InfoState>(FakeInfoState());
      registerFallbackValue<InfoEvent>(FakeInfoEvent());
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<EditProfileState>(FakeEditProfileState());
    });

    setUp(() {
      infoBloc = MockInfoBloc();
      when(() => infoBloc.state)
          .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
      appBloc = MockAppBloc();
      when(() => appBloc.state).thenReturn(AppState.authenticated(mockUser));
      editProfileCubit = MockEditProfileCubit();
      when(() => editProfileCubit.state).thenReturn(const EditProfileState(
          name: validUsername, gender: validGender, photoUrl: mockImgUrl));
    });

    testWidgets('render all widget correct', (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          RepositoryProvider<UserRepository>(
            create: (_) => MockUserRepository(),
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: infoBloc,
                  child: Setting(),
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
    //               value: infoBloc,
    //               child: Setting(),
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
    //               value: infoBloc,
    //               child: Setting(),
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
          RepositoryProvider<UserRepository>(
            create: (_) => MockUserRepository(),
            child: BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: BlocProvider.value(
                  value: infoBloc,
                  child: Setting(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('ออกจากระบบ'));
        await tester.pumpAndSettle();
        verify(()=> appBloc.add(AppLogoutRequested())).called(1);
      });
    });

    // testWidgets('call ... when pressed deleteAccount button',
    //     (tester) async {
    //   mockNetworkImagesFor(() async {
    //     await tester.pumpWidget(
    //       RepositoryProvider<UserRepository>(
    //         create: (_) => MockUserRepository(),
    //         child: BlocProvider.value(
    //           value: appBloc,
    //           child: MaterialApp(
    //             home: BlocProvider.value(
    //               value: infoBloc,
    //               child: Setting(),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //     await tester.tap(find.text('ลบบัญชี'));
    //     await tester.pumpAndSettle();
    //     verify(()=> appBloc.add(AppLogoutRequested())).called(1);
    //   });
    // });

  });
}
