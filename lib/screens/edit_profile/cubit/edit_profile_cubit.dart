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
  late String _name;
  late String _gender;
  late String _photoUrl;

  void initProfile({
    required String name,
    required String gender,
    required String photoUrl,
  }) {
    _name = name;
    _gender = gender;
    _photoUrl = photoUrl;
    emit(state.copyWith(
      name: Username.dirty(name),
      gender: Gender.dirty(gender),
      photoUrl: photoUrl,
    ));
  }

  FormzStatus _editProfileFormValidate(
      Username username, Gender gender, String photoUrl) {
    return Formz.validate([username, gender]) == FormzStatus.valid &&
            (username.value != _name ||
                gender.value != _gender ||
                photoUrl != _photoUrl)
        ? FormzStatus.valid
        : FormzStatus.invalid;
  }

  void usernameChanged(String value) {
    final username = Username.dirty(value);
    emit(state.copyWith(
      name: username,
      statusProfile:
          _editProfileFormValidate(username, state.gender, state.photoUrl),
    ));
  }

  void genderChanged(String value) {
    final gender = Gender.dirty(value);
    emit(state.copyWith(
      gender: gender,
      statusProfile:
          _editProfileFormValidate(state.name, gender, state.photoUrl),
    ));
  }

  void photoUrlChanged(String value) {
    emit(state.copyWith(
      photoUrl: value,
      statusProfile: _editProfileFormValidate(state.name, state.gender, value),
    ));
  }

  void oldPasswordChanged(String value) {
    final oldPassword = Password.dirty(value);
    emit(state.copyWith(
      oldPassword: oldPassword,
      statusPassword: Formz.validate(
                      [oldPassword, state.password, state.confirmedPassword]) ==
                  FormzStatus.valid &&
              state.password.value != oldPassword.value
          ? FormzStatus.valid
          : FormzStatus.invalid,
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
      statusPassword:
          Formz.validate([state.oldPassword, password, confirmedPassword]) ==
                      FormzStatus.valid &&
                  password.value != state.oldPassword.value
              ? FormzStatus.valid
              : FormzStatus.invalid,
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
                      [state.oldPassword, state.password, confirmedPassword]) ==
                  FormzStatus.valid &&
              state.password.value != state.oldPassword.value
          ? FormzStatus.valid
          : FormzStatus.invalid,
    ));
  }

  Future<void> editProfileSubmitted() async {
    try {
      await _userRepository.updateInfo(Info(
          name: state.name.value,
          photoUrl: state.photoUrl,
          gender: state.gender.value));
      emit(state.copyWith(statusProfile: FormzStatus.submissionSuccess));
    } on UpdateInfoFailure catch (e) {
      emit(state.copyWith(
        statusProfile: FormzStatus.submissionFailure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(statusProfile: FormzStatus.submissionFailure));
    }
  }

  Future<void> editPasswordSubmitted() async {
    try {
      await _userRepository.updatePassword(
          state.password.value, state.oldPassword.value);
      emit(state.copyWith(statusPassword: FormzStatus.submissionSuccess));
    } on UpdatePasswordFaliure catch (e) {
      emit(state.copyWith(
        statusPassword: FormzStatus.submissionFailure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(statusPassword: FormzStatus.submissionFailure));
    }
  }
}
