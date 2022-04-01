import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/password.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:formz/formz.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit(this._authenRepository) : super(const DeleteUserState());

  final AuthenRepository _authenRepository;

  Future<void> deleteUser() async {
    try {
      await _authenRepository.deleteUser(state.password.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on DeleteUserFailure catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'เกิดข้อผิดพลาดบางอย่าง'));
    }
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
        state.copyWith(status: Formz.validate([password]), password: password));
  }
}
