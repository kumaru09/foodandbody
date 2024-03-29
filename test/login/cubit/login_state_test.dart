import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/screens/login/cubit/login_cubit.dart';
import 'package:formz/formz.dart';

void main() {
  const email = Email.dirty('email');
  const password = Password.dirty('password');
  const errorMessage = 'errorMessage';

  group('LoginState', () {
    test('supports value comparisons', () {
      expect(LoginState(), LoginState());
    });

    test('returns same object when no properties are passed', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        LoginState().copyWith(status: FormzStatus.pure),
        LoginState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        LoginState().copyWith(email: email),
        LoginState(email: email),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        LoginState().copyWith(password: password),
        LoginState(password: password),
      );
    });

    test('returns object with updated errorMessage when errorMessage is passed', () {
      expect(
        LoginState().copyWith(errorMessage: errorMessage),
        LoginState(errorMessage: errorMessage),
      );
    });
  });
}