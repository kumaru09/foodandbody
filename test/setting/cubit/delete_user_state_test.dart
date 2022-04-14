import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/setting/cubit/delete_user_cubit.dart';

void main() {
  group('DeleteUserState', () {
    final mockErrorMessage = 'ดำเนินการไม่สำเร็จ กรุณาลองใหม่';
    final mockAccountType = 'google.com';

    DeleteUserState createSubject({
      SettingStatus status = SettingStatus.initial,
      String accountType = '',
      DeleteUserStatus deleteStatus = DeleteUserStatus.initial,
      String errorMessage = '',
    }) {
      return DeleteUserState(
        status: status,
        accountType: accountType,
        deleteStatus: deleteStatus,
        errorMessage: errorMessage,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(DeleteUserState(), DeleteUserState());
      expect(
        DeleteUserState().toString(),
        DeleteUserState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: SettingStatus.initial,
          accountType: mockAccountType,
          deleteStatus: DeleteUserStatus.initial,
          errorMessage: mockErrorMessage,
        ).props,
        equals(<Object?>[
          SettingStatus.initial,
          mockAccountType,
          DeleteUserStatus.initial,
          mockErrorMessage,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            accountType: null,
            deleteStatus: null,
            errorMessage: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: SettingStatus.success,
            accountType: mockAccountType,
            deleteStatus: DeleteUserStatus.success,
            errorMessage: mockErrorMessage,
          ),
          equals(
            createSubject(
              status: SettingStatus.success,
              accountType: mockAccountType,
              deleteStatus: DeleteUserStatus.success,
              errorMessage: mockErrorMessage,
            ),
          ),
        );
      });
    });
  });
}
