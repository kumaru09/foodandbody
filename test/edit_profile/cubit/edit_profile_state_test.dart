import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/confirm_password.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:formz/formz.dart';

void main() {
  const Username mockName = Username.dirty('user');
  const Gender mockGender = Gender.dirty('F');
  const Password mockOldPassword = Password.dirty('user0123');
  const Password mockPassword = Password.dirty('user1234');
  final ConfirmedPassword mockConfirmedPassword =
      ConfirmedPassword.dirty(password: 'user1234', value: 'user1234');
  const String mockPhotoUrl = 'imgUrl';
  const String mockErrorMessage = 'เกิดข้อผิดพลาด กรุณาลองใหม่';

  group('EditProfileState', () {

    test('supports value comparisons', () {
      expect(EditProfileState(), EditProfileState());
    });

    test('returns same object when no properties are passed', () {
      expect(EditProfileState().copyWith(), EditProfileState());
    });

    test('returns object with updated statusProfile when status is passed', () {
      expect(
        EditProfileState().copyWith(statusProfile: FormzStatus.pure),
        EditProfileState(),
      );
    });

    test('returns object with updated username when username is passed', () {
      expect(
        EditProfileState().copyWith(name: mockName),
        EditProfileState(name: mockName),
      );
    });

    test('returns object with updated gender when gender is passed', () {
      expect(
        EditProfileState().copyWith(gender: mockGender),
        EditProfileState(gender: mockGender),
      );
    });

    test('returns object with updated photoUrl when photoUrl is passed', () {
      expect(
        EditProfileState().copyWith(photoUrl: mockPhotoUrl),
        EditProfileState(photoUrl: mockPhotoUrl),
      );
    });

    test('returns object with updated statusPassword when status is passed', () {
      expect(
        EditProfileState().copyWith(statusPassword: FormzStatus.pure),
        EditProfileState(),
      );
    });

    test('returns object with updated oldPassword when oldPassword is passed', () {
      expect(
        EditProfileState().copyWith(password: mockOldPassword),
        EditProfileState(password: mockOldPassword),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        EditProfileState().copyWith(password: mockPassword),
        EditProfileState(password: mockPassword),
      );
    });

    test(
        'returns object with updated confirmPassword when confirmPassword is passed',
        () {
      expect(
        EditProfileState().copyWith(confirmedPassword: mockConfirmedPassword),
        EditProfileState(confirmedPassword: mockConfirmedPassword),
      );
    });

    test(
        'returns object with updated errorMessage when errorMessage is passed',
        () {
      expect(
        EditProfileState().copyWith(errorMessage: mockErrorMessage),
        EditProfileState(errorMessage: mockErrorMessage),
      );
    });
  });
}
