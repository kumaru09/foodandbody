part of 'edit_profile_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class EditProfileState extends Equatable {
  const EditProfileState(
      {this.name = const Username.pure(),
      this.gender = const Gender.pure(),
      this.confirmedPassword = const ConfirmedPassword.pure(),
      this.password = const Password.pure(),
      this.photoUrl = '',
      this.oldPassword = const Password.pure(),
      this.status = FormzStatus.pure,
      this.errorMessage});

  final Username name;
  final Gender gender;
  final String photoUrl;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final String? errorMessage;
  final Password oldPassword;

  EditProfileState copyWith(
      {Username? name,
      Gender? gender,
      String? photoUrl,
      Password? password,
      ConfirmedPassword? confirmedPassword,
      FormzStatus? status,
      String? errorMessage,
      Password? oldPassword}) {
    return EditProfileState(
        name: name ?? this.name,
        gender: gender ?? this.gender,
        photoUrl: photoUrl ?? this.photoUrl,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        oldPassword: oldPassword ?? this.oldPassword);
  }

  @override
  List<Object> get props => [
        name,
        gender,
        photoUrl,
        password,
        confirmedPassword,
        oldPassword,
        status
      ];
}
