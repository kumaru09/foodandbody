import 'package:formz/formz.dart';

enum GenderValidationError {
  /// Generic invalid error.
  invalid
}

class Gender extends FormzInput<String, GenderValidationError> {
  const Gender.pure() : super.pure('');
  const Gender.dirty([String value = '']) : super.dirty(value);

  @override
  GenderValidationError? validator(String? value) {
    return value!.isNotEmpty == true ? null : GenderValidationError.invalid;
  }
}
