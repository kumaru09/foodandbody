import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/setting/cubit/delete_user_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenRepository extends Mock implements AuthenRepository {}

void main() {
  final Map<String, String> mockUserInfo = {
    'displayName': 'user',
    'email': 'user@email.com',
    'photoURL': 'mockImgUrl',
    'providerId': 'email.com',
    'uid': 'mockUid'
  };
  final List<UserInfo> mockAccount = [UserInfo(mockUserInfo)];

  late AuthenRepository authenRepository;

  setUp(() {
    authenRepository = MockAuthenRepository();
    when(() => authenRepository.providerData).thenReturn(mockAccount);
  });

  group('DeleteUserCubit', () {
    test('initial state is DeleteUserState', () {
      expect(DeleteUserCubit(authenRepository).state, DeleteUserState());
    });

    group('initialSetting', () {
      blocTest<DeleteUserCubit, DeleteUserState>(
        'emit status success when call authenRepository providerData passed',
        build: () => DeleteUserCubit(authenRepository),
        act: (cubit) => cubit.initialSetting(),
        expect: () => const <DeleteUserState>[
          DeleteUserState(status: SettingStatus.initial),
          DeleteUserState(
              status: SettingStatus.success, accountType: 'email.com')
        ],
        verify: (_) => verify(() => authenRepository.providerData).called(1),
      );

      blocTest<DeleteUserCubit, DeleteUserState>(
        'emit status failure when authenRepository providerData throw Exception',
        setUp: () => when(() => authenRepository.providerData)
            .thenAnswer((_) => throw Exception()),
        build: () => DeleteUserCubit(authenRepository),
        act: (cubit) => cubit.initialSetting(),
        expect: () => const <DeleteUserState>[
          DeleteUserState(status: SettingStatus.initial),
          DeleteUserState(status: SettingStatus.failure)
        ],
        verify: (_) => verify(() => authenRepository.providerData).called(1),
      );
    });

    group('deleteUser', () {
      blocTest<DeleteUserCubit, DeleteUserState>(
        'emit deleteStatus success when call authenRepository deleteUser passed',
        setUp: () =>
            when(() => authenRepository.deleteUser()).thenAnswer((_) async {}),
        build: () => DeleteUserCubit(authenRepository),
        act: (cubit) => cubit.deleteUser(),
        expect: () => const <DeleteUserState>[
          DeleteUserState(deleteStatus: DeleteUserStatus.initial),
          DeleteUserState(deleteStatus: DeleteUserStatus.success)
        ],
        verify: (_) => verify(() => authenRepository.deleteUser()).called(1),
      );

      blocTest<DeleteUserCubit, DeleteUserState>(
        'emit deleteStatus failure when authenRepository deleteUser throw Exception',
        setUp: () => when(() => authenRepository.deleteUser())
            .thenAnswer((_) => throw Exception()),
        build: () => DeleteUserCubit(authenRepository),
        act: (cubit) => cubit.deleteUser(),
        expect: () => const <DeleteUserState>[
          DeleteUserState(deleteStatus: DeleteUserStatus.initial),
          DeleteUserState(
            deleteStatus: DeleteUserStatus.failure,
            errorMessage: 'ดำเนินการไม่สำเร็จ กรุณาลองใหม่',
          )
        ],
        verify: (_) => verify(() => authenRepository.deleteUser()).called(1),
      );

      blocTest<DeleteUserCubit, DeleteUserState>(
        'emit deleteStatus failure when authenRepository deleteUser throw DeleteUserFailure',
        setUp: () => when(() => authenRepository.deleteUser())
            .thenAnswer((_) => throw DeleteUserFailure()),
        build: () => DeleteUserCubit(authenRepository),
        act: (cubit) => cubit.deleteUser(),
        expect: () => const <DeleteUserState>[
          DeleteUserState(deleteStatus: DeleteUserStatus.initial),
          DeleteUserState(
            deleteStatus: DeleteUserStatus.failure,
            errorMessage: 'ไม่สามารถลบบัญชีผู้ใช้ได้ กรุณาลองใหม่อีกครั้ง',
          )
        ],
        verify: (_) => verify(() => authenRepository.deleteUser()).called(1),
      );
    });
  });
}
