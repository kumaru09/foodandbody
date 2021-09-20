import 'package:formz/formz.dart';

enum WeightValidationError {
  /// Generic invalid error.
  invalid
}

class Weight extends FormzInput<String, WeightValidationError> {
  const Weight.pure() : super.pure('');
  const Weight.dirty([String value = '']) : super.dirty(value);

  static final RegExp _weightRegExp = RegExp(
    r'^[1-9]\d{1,2}$',
  );

  @override
  WeightValidationError? validator(String? value) {
    return _weightRegExp.hasMatch(value ?? '')
        ? null
        : WeightValidationError.invalid;
  }
}
