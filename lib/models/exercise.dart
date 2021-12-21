import 'package:formz/formz.dart';

enum ExerciseValidationError {
  /// Generic invalid error.
  invalid
}

class Exercise extends FormzInput<String, ExerciseValidationError> {
  const Exercise.pure() : super.pure('');
  const Exercise.dirty([String value = '']) : super.dirty(value);

  @override
  ExerciseValidationError? validator(String? value) {
    return value!.isNotEmpty == true ? null : ExerciseValidationError.invalid;
  }
}
