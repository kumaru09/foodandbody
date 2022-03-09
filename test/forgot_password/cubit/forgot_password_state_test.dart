import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/screens/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:formz/formz.dart';

void main() {
  const email = Email.dirty('email');

  group('ForgotPasswordState', () {
    test('supports value comparisons', () {
      expect(ForgotPasswordState(), ForgotPasswordState());
    });

    test('returns same object when no properties are passed', () {
      expect(ForgotPasswordState().copyWith(), ForgotPasswordState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        ForgotPasswordState().copyWith(status: FormzStatus.pure),
        ForgotPasswordState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        ForgotPasswordState().copyWith(email: email),
        ForgotPasswordState(email: email),
      );
    });
  });
}