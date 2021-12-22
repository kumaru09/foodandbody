import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/models/birth_date.dart';
import 'package:foodandbody/models/exercise.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:formz/formz.dart';

part 'initial_info_state.dart';

class InitialInfoCubit extends Cubit<InitialInfoState> {
  InitialInfoCubit(this._userRepository) : super(const InitialInfoState());

  final UserRepository _userRepository;

  void usernameChanged(String value) {
    final username = Username.dirty(value);
    emit(state.copyWith(
      username: username,
      status: Formz.validate([
        username,
        state.weight,
        state.height,
        state.bDate,
        state.gender,
        state.exercise
      ]),
    ));
  }

  void weightChanged(String value) {
    final weight = Weight.dirty(value);
    emit(state.copyWith(
      weight: weight,
      status: Formz.validate([
        state.username,
        weight,
        state.height,
        state.bDate,
        state.gender,
        state.exercise
      ]),
    ));
  }

  void heightChanged(String value) {
    final height = Height.dirty(value);
    emit(state.copyWith(
      height: height,
      status: Formz.validate([
        state.username,
        state.weight,
        height,
        state.bDate,
        state.gender,
        state.exercise
      ]),
    ));
  }

  void bDateChanged(String value) {
    final bDate = BDate.dirty(value);
    emit(state.copyWith(
      bDate: bDate,
      status: Formz.validate([
        state.username,
        state.weight,
        state.height,
        bDate,
        state.gender,
        state.exercise
      ]),
    ));
  }

  void genderChanged(String value) {
    final gender = Gender.dirty(value);
    emit(state.copyWith(
      gender: gender,
      status: Formz.validate([
        state.username,
        state.weight,
        state.height,
        state.bDate,
        gender,
        state.exercise
      ]),
    ));
  }

  void exerciseChanged(String value) {
    final exercise = Exercise.dirty(value);
    emit(state.copyWith(
      exercise: exercise,
      status: Formz.validate([
        state.username,
        state.weight,
        state.height,
        state.bDate,
        state.gender,
        exercise
      ]),
    ));
  }

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int cMonth = currentDate.month;
    int bMonth = birthDate.month;
    if (bMonth > cMonth ||
        (cMonth == bMonth && birthDate.day > currentDate.day)) age--;
    return age;
  }

  Future<void> initialInfoFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      int age = _calculateAge(DateTime.parse(state.bDate.value));
      double bmr = state.gender.value == 'M'
          ? 66 +
              (13.7 * int.parse(state.weight.value)) +
              (5 * int.parse(state.height.value)) -
              (6.8 * age)
          : 665 +
              (9.6 * int.parse(state.weight.value)) +
              (1.8 * int.parse(state.height.value)) -
              (4.7 * age);
      double tdee = bmr.round() * double.parse(state.exercise.value);
      await _userRepository.addUserInfo(Info(
        name: state.username.value,
        weight: int.parse(state.weight.value),
        height: int.parse(state.height.value),
        // bDate: state.bDate.value, //type String
        gender: state.gender.value,
        goal: tdee.round(),
        photoUrl: '',
      ));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
