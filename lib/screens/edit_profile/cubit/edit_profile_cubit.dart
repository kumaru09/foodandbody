import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/confirm_password.dart';
import 'package:foodandbody/models/gender.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/models/username.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:formz/formz.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._userRepository) : super(const EditProfileState());

  final UserRepository _userRepository;

  void usernameChanged(String value) {
    final username = Username.dirty(value);
    emit(state.copyWith(
      name: username,
      status: Formz.validate(
          [username, state.gender, state.password, state.confirmedPassword]),
    ));
  }

  void oldPasswordChanged(String value) {
    final oldPassword = Password.dirty(value);
    emit(state.copyWith(
      oldPassword: oldPassword,
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: Formz.validate(
          [state.name, password, confirmedPassword, state.gender]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate(
          [state.name, state.password, confirmedPassword, state.gender]),
    ));
  }

  void genderChanged(String value) {
    final gender = Gender.dirty(value);
    emit(state.copyWith(
      gender: gender,
      status: Formz.validate(
          [state.password, gender, state.confirmedPassword, state.name]),
    ));
  }

  void photoUrlChanged(String value) {
    emit(state.copyWith(photoUrl: value));
  }

  Future<void> editFormSubmitted() async {
    try {
      if (state.oldPassword.value.isNotEmpty &&
          state.password.value.isNotEmpty &&
          state.confirmedPassword.valid) {
        print('update Info&pass');
        await _userRepository.updatePassword(
            state.password.value, state.oldPassword.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else if (state.name.value.isNotEmpty && state.gender.value.isNotEmpty) {
        print('update Info');
        await _userRepository.updateInfo(Info(
            name: state.name.value,
            photoUrl: state.photoUrl,
            gender: state.gender.value));
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }
    } on UpdateInfoFailure catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));
    } on UpdatePasswordFaliure catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
    // emit(state.copyWith(status: FormzStatus.submissionInProgress));
    // try {
    //   await _userRepository.updateInfo(Info(
    //       name: state.name.value,
    //       photoUrl: state.photoUrl,
    //       gender: state.gender.value));
    //   await _userRepository.updatePassword(state.confirmedPassword.value);
    //   emit(state.copyWith(status: FormzStatus.submissionSuccess));
    // } on Exception {
    //   emit(state.copyWith(status: FormzStatus.submissionFailure));
    // }
  }
}
