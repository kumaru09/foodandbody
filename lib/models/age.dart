import 'package:formz/formz.dart';

enum AgeValidationError {
  /// Generic invalid error.
  invalid
}

class Age extends FormzInput<String, AgeValidationError> {
  const Age.pure() : super.pure('');
  const Age.dirty([String value = '']) : super.dirty(value);

  static final RegExp _ageRegExp = RegExp(
    r'^[1-9]\d{0,1}$',
  );

  @override
  AgeValidationError? validator(String? value) {
    return _ageRegExp.hasMatch(value ?? '')
        ? null
        : AgeValidationError.invalid;
  }
}
