import 'package:formz/formz.dart';

enum CaloryValidationError {
  /// Generic invalid error.
  invalid
}

class Calory extends FormzInput<String, CaloryValidationError> {
  const Calory.pure() : super.pure('');
  const Calory.dirty([String value = '']) : super.dirty(value);

  static final RegExp _caloryRegExp = RegExp(
    r'^[1-9]\d{2,3}$',
  );

  @override
  CaloryValidationError? validator(String? value) {
    return _caloryRegExp.hasMatch(value ?? '')
        ? null
        : CaloryValidationError.invalid;
  }
}
