import 'package:formz/formz.dart';

enum BDateValidationError {
  /// Generic invalid error.
  invalid
}

class BDate extends FormzInput<String, BDateValidationError> {
  const BDate.pure() : super.pure('');
  const BDate.dirty([String value = '']) : super.dirty(value);

  @override
  BDateValidationError? validator(String? value) {
    return value!.isNotEmpty == true ? null : BDateValidationError.invalid;
  }
}
