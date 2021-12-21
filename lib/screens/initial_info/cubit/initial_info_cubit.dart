import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/models/age.dart';
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
      status: Formz.validate(
          [username, state.weight, state.height, state.age, state.gender, state.exercise]),
    ));
  }

  void weightChanged(String value) {
    final weight = Weight.dirty(value);
    emit(state.copyWith(
      weight: weight,
      status: Formz.validate(
          [state.username, weight, state.height, state.age, state.gender, state.exercise]),
    ));
  }

  void heightChanged(String value) {
    final height = Height.dirty(value);
    emit(state.copyWith(
      height: height,
      status: Formz.validate(
          [state.username, state.weight, height, state.age, state.gender, state.exercise]),
    ));
  }

  void ageChanged(String value) {
    final age = Age.dirty(value);
    emit(state.copyWith(
      age: age,
      status: Formz.validate(
          [state.username, state.weight, state.height, age, state.gender, state.exercise]),
    ));
  }

  void genderChanged(String value) {
    final gender = Gender.dirty(value);
    emit(state.copyWith(
      gender: gender,
      status: Formz.validate(
          [state.username, state.weight, state.height, state.age, gender, state.exercise]),
    ));
  }

  void exerciseChanged(String value) {
    final exercise = Exercise.dirty(value);
    emit(state.copyWith(
      exercise: exercise,
      status: Formz.validate(
          [state.username, state.weight, state.height, state.age, state.gender, exercise]),
    ));
  }

  Future<void> initialInfoFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _userRepository.addUserInfo(Info(
        name: state.username.value,
        weight: int.parse(state.weight.value),
        height: int.parse(state.height.value),
        // age: int.parse(state.age.value),
        gender: state.gender.value,
        // exercise: state.gender.value,
        photoUrl: '',
      ));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
