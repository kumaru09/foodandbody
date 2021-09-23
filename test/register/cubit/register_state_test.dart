// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/confirm_password.dart';
import 'package:foodandbody/models/email.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/screens/register/cubit/register_cubit.dart';
import 'package:formz/formz.dart';

void main() {
  const email = Email.dirty('email');
  const passwordString = 'password';
  const password = Password.dirty(passwordString);
  const confirmedPassword = ConfirmedPassword.dirty(
    password: passwordString,
    value: passwordString,
  );

  group('RegisterState', () {
    test('supports value comparisons', () {
      expect(RegisterState(), RegisterState());
    });

    test('returns same object when no properties are passed', () {
      expect(RegisterState().copyWith(), RegisterState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        RegisterState().copyWith(status: FormzStatus.pure),
        RegisterState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        RegisterState().copyWith(email: email),
        RegisterState(email: email),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        RegisterState().copyWith(password: password),
        RegisterState(password: password),
      );
    });

    test(
        'returns object with updated confirmedPassword'
        ' when confirmedPassword is passed', () {
      expect(
        RegisterState().copyWith(confirmedPassword: confirmedPassword),
        RegisterState(confirmedPassword: confirmedPassword),
      );
    });
  });
}