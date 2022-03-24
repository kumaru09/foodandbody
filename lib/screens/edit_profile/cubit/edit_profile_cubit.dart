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
      statusProfile: Formz.validate(
          [username, state.gender]),
    ));
  }

  void genderChanged(String value) {
    final gender = Gender.dirty(value);
    emit(state.copyWith(
      gender: gender,
      statusProfile: Formz.validate(
          [state.password, gender]),
    ));
  }

  void photoUrlChanged(String value) {
    emit(state.copyWith(photoUrl: value));
  }

  void oldPasswordChanged(String value) {
    final oldPassword = Password.dirty(value);
    emit(state.copyWith(
      oldPassword: oldPassword,
      statusPassword: Formz.validate(
          [oldPassword, state.password, state.confirmedPassword]),
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
      statusPassword: Formz.validate(
          [state.oldPassword, password, confirmedPassword]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      statusPassword: Formz.validate(
          [state.oldPassword, state.password, confirmedPassword]),
    ));
  }

  Future<void> editProfileSubmitted() async {
    try {
      if (state.name.value.isNotEmpty && state.gender.value.isNotEmpty) {
        // print('update Info');
        await _userRepository.updateInfo(Info(
            name: state.name.value,
            photoUrl: state.photoUrl,
            gender: state.gender.value));
        emit(state.copyWith(statusProfile: FormzStatus.submissionSuccess));
      }
    } on UpdateInfoFailure catch (e) {
      emit(state.copyWith(
          statusProfile: FormzStatus.submissionFailure, errorMessage: e.message));
    }  catch (_) {
      emit(state.copyWith(statusProfile: FormzStatus.submissionFailure));
    }
  }

    Future<void> editPasswordSubmitted() async {
    try {
      if (state.oldPassword.value.isNotEmpty &&
          state.password.value.isNotEmpty &&
          state.confirmedPassword.valid) {
        // print('update Info&pass');
        await _userRepository.updatePassword(
            state.password.value, state.oldPassword.value);
        emit(state.copyWith(statusPassword: FormzStatus.submissionSuccess));
      }
    } on UpdatePasswordFaliure catch (e) {
      emit(state.copyWith(
          statusPassword: FormzStatus.submissionFailure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(statusPassword: FormzStatus.submissionFailure));
    }
  }
}
