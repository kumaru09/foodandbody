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
    // on<UpdateGoal>(updateGoal);
    // on<UpdateHeight>(updateHeight);
    // on<UpdateWeight>(updateWeight);
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

  // Future<void> updateGoal(UpdateGoal event, Emitter<InfoState> emit) async {
  //   try {
  //     emit(state.copyWith(status: InfoStatus.loading));
  //     await _userRepository.updateGoalInfo(event.goal);
  //     final info = await _userRepository.getInfo();
  //     emit(state.copyWith(status: InfoStatus.success, info: info));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> updateHeight(UpdateHeight event, Emitter<InfoState> emit) async {
  //   try {
  //     emit(state.copyWith(status: InfoStatus.loading));
  //     await _userRepository.updateHeightInfo(event.height);
  //     final info = await _userRepository.getInfo();
  //     emit(state.copyWith(status: InfoStatus.success, info: info));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> updateWeight(UpdateWeight event, Emitter<InfoState> emit) async {
  //   try {
  //     emit(state.copyWith(status: InfoStatus.loading));
  //     await _userRepository.updateWeightInfo(event.weight);
  //     final info = await _userRepository.getInfo();
  //     emit(state.copyWith(status: InfoStatus.success, info: info));
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
