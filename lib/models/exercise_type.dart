import 'package:formz/formz.dart';

enum ExerciseTypeValidationError {
  /// Generic invalid error.
  invalid
}

class ExerciseType extends FormzInput<String, ExerciseTypeValidationError> {
  const ExerciseType.pure() : super.pure('');
  const ExerciseType.dirty([String value = '']) : super.dirty(value);

  @override
  ExerciseTypeValidationError? validator(String? value) {
    return value!.isNotEmpty == true ? null : ExerciseTypeValidationError.invalid;
  }
}
