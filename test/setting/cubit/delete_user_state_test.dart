import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/setting/cubit/delete_user_cubit.dart';

void main() {
  group('DeleteUserState', () {
    final mockErrorMessage = 'ดำเนินการไม่สำเร็จ กรุณาลองใหม่';

    DeleteUserState createSubject({
      DeleteUserStatus status = DeleteUserStatus.initial,
      String errorMessage = '',
    }) {
      return DeleteUserState(
        status: status,
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
          status: DeleteUserStatus.initial,
          errorMessage: mockErrorMessage,
        ).props,
        equals(<Object?>[
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
            errorMessage: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: DeleteUserStatus.success,
            errorMessage: mockErrorMessage,
          ),
          equals(
            createSubject(
              status: DeleteUserStatus.success,
              errorMessage: mockErrorMessage,
            ),
          ),
        );
      });
    });
  });
}
