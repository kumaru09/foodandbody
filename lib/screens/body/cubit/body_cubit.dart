import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';

part 'body_state.dart';

class BodyCubit extends Cubit<BodyState> {
  BodyCubit(this._bodyRepository) : super(BodyState());

  final BodyRepository _bodyRepository;

  Future<void> fetchBody() async {
    try {
      final body = await _bodyRepository.getBodyLatest();
      final weightList = await _bodyRepository.getWeightList();
      emit(state.copyWith(
          status: BodyStatus.success, body: body, weightList: weightList));
    } on Exception {
      emit(state.copyWith(status: BodyStatus.failure));
    }
  }

  Future<void> updateWeight(int weight) async {
    try {
      emit(state.copyWith(status: BodyStatus.loading));
      await _bodyRepository.addWeight(weight);
      final weightList = await _bodyRepository.getWeightList();
      emit(state.copyWith(status: BodyStatus.success, weightList: weightList));
    } catch (e) {
      print(e);
    }
  }
}
