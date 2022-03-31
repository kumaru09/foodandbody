import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/repositories/user_repository.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc({required UserRepository userRepository})
      : this._userRepository = userRepository,
        super(InfoState()) {
    on<LoadInfo>(getInfo);
  }

  final UserRepository _userRepository;

  Future<void> getInfo(LoadInfo event, Emitter<InfoState> emit) async {
    try {
      emit(state.copyWith(status: InfoStatus.loading));
      final info = await _userRepository.getInfo();
      emit(state.copyWith(status: InfoStatus.success, info: info));
    } catch (e) {
      emit(state.copyWith(status: InfoStatus.failure));
      print(e);
    }
  }
}
