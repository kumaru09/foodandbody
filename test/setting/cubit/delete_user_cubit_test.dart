import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/setting/cubit/delete_user_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenRepository extends Mock implements AuthenRepository {}

void main() {
  late AuthenRepository authenRepository;

  setUp(() {
    authenRepository = MockAuthenRepository();
  });

  group('DeleteUserCubit', () {
    test('initial state is DeleteUserState', () {
      expect(DeleteUserCubit(authenRepository).state, DeleteUserState());
    });

    blocTest<DeleteUserCubit, DeleteUserState>(
      'deleteUser emit status success when call authenRepository deleteUser pass',
      setUp: () =>
          when(() => authenRepository.deleteUser()).thenAnswer((_) async {}),
      build: () => DeleteUserCubit(authenRepository),
      act: (cubit) => cubit.deleteUser(),
      expect: () => const <DeleteUserState>[
        DeleteUserState(status: DeleteUserStatus.initial),
        DeleteUserState(status: DeleteUserStatus.success)
      ],
      verify: (_) => verify(() => authenRepository.deleteUser()).called(1),
    );

    blocTest<DeleteUserCubit, DeleteUserState>(
      'deleteUser emit status failure when authenRepository deleteUser throw Exception',
      setUp: () => when(() => authenRepository.deleteUser())
          .thenAnswer((_) => throw Exception()),
      build: () => DeleteUserCubit(authenRepository),
      act: (cubit) => cubit.deleteUser(),
      expect: () => const <DeleteUserState>[
        DeleteUserState(status: DeleteUserStatus.initial),
        DeleteUserState(
          status: DeleteUserStatus.failure,
          errorMessage: 'ดำเนินการไม่สำเร็จ กรุณาลองใหม่',
        )
      ],
      verify: (_) => verify(() => authenRepository.deleteUser()).called(1),
    );

    blocTest<DeleteUserCubit, DeleteUserState>(
      'deleteUser emit status failure when authenRepository deleteUser throw DeleteUserFailure',
      setUp: () => when(() => authenRepository.deleteUser())
          .thenAnswer((_) => throw DeleteUserFailure()),
      build: () => DeleteUserCubit(authenRepository),
      act: (cubit) => cubit.deleteUser(),
      expect: () => const <DeleteUserState>[
        DeleteUserState(status: DeleteUserStatus.initial),
        DeleteUserState(
          status: DeleteUserStatus.failure,
          errorMessage: 'ไม่สามารถลบบัญชีผู้ใช้ได้ กรุณาลองใหม่อีกครั้ง',
        )
      ],
      verify: (_) => verify(() => authenRepository.deleteUser()).called(1),
    );
  });
}
