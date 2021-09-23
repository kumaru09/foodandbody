import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/models/calory.dart';
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
          [username, state.weight, state.height, state.gender, state.calory]),
    ));
  }

  void weightChanged(String value) {
    final weight = Weight.dirty(value);
    emit(state.copyWith(
      weight: weight,
      status: Formz.validate(
          [state.username, weight, state.height, state.gender, state.calory]),
    ));
  }

  void heightChanged(String value) {
    final height = Height.dirty(value);
    emit(state.copyWith(
      height: height,
      status: Formz.validate(
          [state.username, state.weight, height, state.gender, state.calory]),
    ));
  }

  void genderChanged(String value) {
    final gender = Gender.dirty(value);
    emit(state.copyWith(
      gender: gender,
      status: Formz.validate(
          [state.username, state.weight, state.height, gender, state.calory]),
    ));
  }

  void caloryChanged(String value) {
    final calory = Calory.dirty(value);
    emit(state.copyWith(
      calory: calory,
      status: Formz.validate(
          [state.username, state.weight, state.height, state.gender, calory]),
    ));
  }

  Future<void> initialInfoFormSubmitted(String? uid) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _userRepository.addUserInfo(
        uid!,
        Info(
          name: state.username.value,
          weight: int.parse(state.weight.value),
          height: int.parse(state.height.value),
          gender: state.gender.value,
          goal: int.parse(state.calory.value),
          photoUrl: '',
        )
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
