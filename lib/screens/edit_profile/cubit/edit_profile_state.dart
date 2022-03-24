part of 'edit_profile_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class EditProfileState extends Equatable {
  const EditProfileState(
      {
      this.statusProfile = FormzStatus.pure,
        this.name = const Username.pure(),
      this.gender = const Gender.pure(),
      this.photoUrl = '',
      this.statusPassword = FormzStatus.pure,
      this.oldPassword = const Password.pure(),
      this.password = const Password.pure(),
      this.confirmedPassword = const ConfirmedPassword.pure(),
      this.errorMessage,});

  final FormzStatus statusProfile;
  final Username name;
  final Gender gender;
  final String photoUrl;
  final FormzStatus statusPassword;
  final Password oldPassword;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final String? errorMessage;

  EditProfileState copyWith(
      {
      FormzStatus? statusProfile,
        Username? name,
      Gender? gender,
      String? photoUrl,
      FormzStatus? statusPassword,
      Password? oldPassword,
      Password? password,
      ConfirmedPassword? confirmedPassword,
      String? errorMessage,
      }) {
    return EditProfileState(
        statusProfile: statusProfile ?? this.statusProfile,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        photoUrl: photoUrl ?? this.photoUrl,
        statusPassword: statusPassword ?? this.statusPassword,
        oldPassword: oldPassword ?? this.oldPassword,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        errorMessage: errorMessage ?? this.errorMessage,
        );
  }

  @override
  List<Object> get props => [
        statusProfile,
        name,
        gender,
        photoUrl,
        statusPassword,
        oldPassword,
        password,
        confirmedPassword,
      ];
}
