import 'package:formz/formz.dart';

enum BodyFigureValidationError {
  /// Generic invalid error.
  invalid
}

class BodyFigure extends FormzInput<String, BodyFigureValidationError> {
  const BodyFigure.pure() : super.pure('');
  const BodyFigure.dirty([String value = '']) : super.dirty(value);

  static final RegExp _bodyFigureRegExp = RegExp(
    r'^[1-9]\d{1,2}$',
  );

  @override
  BodyFigureValidationError? validator(String? value) {
    return _bodyFigureRegExp.hasMatch(value ?? '')
        ? null
        : BodyFigureValidationError.invalid;
  }
}
