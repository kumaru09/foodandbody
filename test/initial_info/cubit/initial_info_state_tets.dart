import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:foodandbody/screens/initial_info/cubit/initial_info_cubit.dart';
import 'package:formz/formz.dart';

void main() {
  const username = Username.dirty('username');
  const weight = Weight.dirty('weight');
  const height = Height.dirty('height');
  const gender = Gender.dirty('gender');
  const calory = Calory.dirty('calory');

  group('InitialInfoState', () {
    
    test('supports value comparisons', () {
      expect(InitialInfoState(), InitialInfoState());
    });

    test('returns same object when no properties are passed', () {
      expect(InitialInfoState().copyWith(), InitialInfoState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        InitialInfoState().copyWith(status: FormzStatus.pure),
        InitialInfoState(),
      );
    });

    test('returns object with updated username when username is passed', () {
      expect(
        InitialInfoState().copyWith(username: username),
        InitialInfoState(username: username),
      );
    });

    test('returns object with updated weight when weight is passed', () {
      expect(
        InitialInfoState().copyWith(weight: weight),
        InitialInfoState(weight: weight),
      );
    });

    test('returns object with updated height when height is passed', () {
      expect(
        InitialInfoState().copyWith(height: height),
        InitialInfoState(height: height),
      );
    });

    test('returns object with updated gender when gender is passed', () {
      expect(
        InitialInfoState().copyWith(gender: gender),
        InitialInfoState(gender: gender),
      );
    });

    test('returns object with updated calory when calory is passed', () {
      expect(
        InitialInfoState().copyWith(calory: calory),
        InitialInfoState(calory: calory),
      );
    });

  });
}