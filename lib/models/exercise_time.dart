import 'package:formz/formz.dart';

enum ExerciseTimeValidationError {
  /// Generic invalid error.
  invalid
}

class ExerciseTime extends FormzInput<String, ExerciseTimeValidationError> {
  const ExerciseTime.pure() : super.pure('');
  const ExerciseTime.dirty([String value = '']) : super.dirty(value);

  static final RegExp _caloryRegExp = RegExp(
    r'^[1-9]\d{1,3}$',
  );

  @override
  ExerciseTimeValidationError? validator(String? value) {
    return _caloryRegExp.hasMatch(value ?? '')
        ? null
        : ExerciseTimeValidationError.invalid;
  }
}
