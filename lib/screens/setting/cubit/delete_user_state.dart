part of 'delete_user_cubit.dart';

enum DeleteUserStatus { initial, success, failure }

class DeleteUserState extends Equatable {
  const DeleteUserState(
      {this.status = DeleteUserStatus.initial, this.errorMessage = ''});

  final DeleteUserStatus status;
  final String errorMessage;

  DeleteUserState copyWith({DeleteUserStatus? status, String? errorMessage}) {
    return DeleteUserState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status, errorMessage];
}
