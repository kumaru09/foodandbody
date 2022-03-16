import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:formz/formz.dart';

part 'body_state.dart';

class BodyCubit extends Cubit<BodyState> {
  BodyCubit(this._bodyRepository) : super(BodyState());

  final BodyRepository _bodyRepository;

  Future<void> fetchBody() async {
    try {
      emit(state.copyWith(status: BodyStatus.loading));
      final body = await _bodyRepository.getBodyLatest();
      final weightList = await _bodyRepository.getWeightList();
      emit(state.copyWith(
        status: BodyStatus.success,
        weightList: weightList,
        shoulder: BodyFigure.dirty(body.shoulder.toString()),
        chest: BodyFigure.dirty(body.chest.toString()),
        waist: BodyFigure.dirty(body.waist.toString()),
        hip: BodyFigure.dirty(body.hip.toString()),
        bodyDate: body.date,
      ));
    } on Exception {
      emit(state.copyWith(status: BodyStatus.failure));
    }
  }

  Future<void> updateWeight(int weight) async {
    try {
      // emit(state.copyWith(status: BodyStatus.loading));
      await _bodyRepository.addWeight(weight);
      final weightList = await _bodyRepository.getWeightList();
      emit(state.copyWith(status: BodyStatus.success, weightList: weightList));
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateBody() async {
    if (!state.editBodyStatus.isValidated) return;
    emit(state.copyWith(editBodyStatus: FormzStatus.submissionInProgress));
    try {
      await _bodyRepository.updateBody(Body(
          date: Timestamp.now(),
          shoulder: int.parse(state.shoulder.value),
          chest: int.parse(state.chest.value),
          waist: int.parse(state.waist.value),
          hip: int.parse(state.hip.value)));
      emit(state.copyWith(editBodyStatus: FormzStatus.submissionSuccess));
    } catch (e) {
      print('updateBody: $e');
      emit(state.copyWith(editBodyStatus: FormzStatus.submissionFailure));
    }
  }

  void editBodyFigure({
    required String shoulder,
    required String chest,
    required String waist,
    required String hip,
  }) {
    emit(state.copyWith(
      shoulder: BodyFigure.dirty(shoulder),
      chest: BodyFigure.dirty(chest),
      waist: BodyFigure.dirty(waist),
      hip: BodyFigure.dirty(hip),
    ));
  }

  void shoulderChanged(String value) {
    final shoulder = BodyFigure.dirty(value);
    emit(state.copyWith(
      shoulder: shoulder,
      editBodyStatus: Formz.validate([
        shoulder,
        state.chest,
        state.waist,
        state.hip,
      ]),
    ));
  }

  void chestChanged(String value) {
    final chest = BodyFigure.dirty(value);
    emit(state.copyWith(
      chest: chest,
      editBodyStatus: Formz.validate([
        state.shoulder,
        chest,
        state.waist,
        state.hip,
      ]),
    ));
  }

  void waistChanged(String value) {
    final waist = BodyFigure.dirty(value);
    emit(state.copyWith(
      waist: waist,
      editBodyStatus: Formz.validate([
        state.shoulder,
        state.chest,
        waist,
        state.hip,
      ]),
    ));
  }

  void hipChanged(String value) {
    final hip = BodyFigure.dirty(value);
    emit(state.copyWith(
      hip: hip,
      editBodyStatus: Formz.validate([
        state.shoulder,
        state.chest,
        state.waist,
        hip,
      ]),
    ));
  }
}
