import 'package:formz/formz.dart';

enum HeightValidationError {
  /// Generic invalid error.
  invalid
}

class Height extends FormzInput<String, HeightValidationError> {
  const Height.pure() : super.pure('');
  const Height.dirty([String value = '']) : super.dirty(value);

  static final RegExp _heightRegExp = RegExp(
    r'^[1-9]\d{1,2}$',
  );

  @override
  HeightValidationError? validator(String? value) {
    return _heightRegExp.hasMatch(value ?? '')
        ? null
        : HeightValidationError.invalid;
  }
}
