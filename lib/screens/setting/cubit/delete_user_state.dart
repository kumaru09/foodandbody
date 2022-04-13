part of 'delete_user_cubit.dart';

enum DeleteUserStatus { initial, success, failure }
enum SettingStatus { initial, success, failure }

class DeleteUserState extends Equatable {
  const DeleteUserState({
    this.status = SettingStatus.initial,
    this.accountType = '',
    this.deleteStatus = DeleteUserStatus.initial,
    this.errorMessage = '',
  });

  final SettingStatus status;
  final String accountType;
  final DeleteUserStatus deleteStatus;
  final String errorMessage;

  DeleteUserState copyWith({
    SettingStatus? status,
    String? accountType,
    DeleteUserStatus? deleteStatus,
    String? errorMessage,
  }) {
    return DeleteUserState(
      status: status ?? this.status,
      accountType: accountType ?? this.accountType,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, accountType, deleteStatus, errorMessage];
}
