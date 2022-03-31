part of 'delete_user_cubit.dart';

class DeleteUserState extends Equatable {
  const DeleteUserState(
      {this.password = const Password.pure(),
      this.status = FormzStatus.pure,
      this.errorMessage = ''});

  final FormzStatus status;
  final Password password;
  final String errorMessage;

  DeleteUserState copyWith(
      {FormzStatus? status, Password? password, String? errorMessage}) {
    return DeleteUserState(
        password: password ?? this.password,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status, password, errorMessage];
}
