import 'package:formz/formz.dart';

enum FoodCaloryValidationError {
  /// Generic invalid error.
  invalid
}

class FoodCalory extends FormzInput<String, FoodCaloryValidationError> {
  const FoodCalory.pure() : super.pure('');
  const FoodCalory.dirty([String value = '']) : super.dirty(value);

  static final RegExp _caloryRegExp = RegExp(
    r'^[1-9]\d{1,3}$',
  );

  @override
  FoodCaloryValidationError? validator(String? value) {
    return _caloryRegExp.hasMatch(value ?? '')
        ? null
        : FoodCaloryValidationError.invalid;
  }
}
