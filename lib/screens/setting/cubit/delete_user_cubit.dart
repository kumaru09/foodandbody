import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/repositories/authen_repository.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit(this._authenRepository) : super(const DeleteUserState());

  final AuthenRepository _authenRepository;

  Future<void> initialSetting() async {
    try {
      emit(state.copyWith(status: SettingStatus.initial));
      final account = _authenRepository.providerData.first.providerId;
      emit(state.copyWith(status: SettingStatus.success, accountType: account));
    } catch (_) {
      emit(state.copyWith(status: SettingStatus.failure));
    }
  }

  Future<void> deleteUser() async {
    try {
      emit(state.copyWith(deleteStatus: DeleteUserStatus.initial));
      await _authenRepository.deleteUser();
      emit(state.copyWith(deleteStatus: DeleteUserStatus.success));
    } on DeleteUserFailure catch (e) {
      emit(state.copyWith(
          deleteStatus: DeleteUserStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
          deleteStatus: DeleteUserStatus.failure,
          errorMessage: 'ดำเนินการไม่สำเร็จ กรุณาลองใหม่'));
    }
  }
}
