import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:formz/formz.dart';

part 'body_state.dart';

class BodyCubit extends Cubit<BodyState> {
  BodyCubit({required this.bodyRepository, required this.userRepository})
      : super(BodyState());

  final BodyRepository bodyRepository;
  final UserRepository userRepository;

  Future<void> fetchBody() async {
    try {
      emit(state.copyWith(status: BodyStatus.loading));
      final body = await bodyRepository.getBodyLatest();
      final weightList = await bodyRepository.getWeightList();
      final info = await userRepository.getInfo();
      emit(state.copyWith(
        status: BodyStatus.success,
        weightList: weightList,
        shoulder: BodyFigure.dirty(body.shoulder.toString()),
        chest: BodyFigure.dirty(body.chest.toString()),
        waist: BodyFigure.dirty(body.waist.toString()),
        hip: BodyFigure.dirty(body.hip.toString()),
        bodyDate: body.date,
        height: Height.dirty(info!.height.toString()),
      ));
    } on Exception {
      emit(state.copyWith(status: BodyStatus.failure));
    }
  }

  Future<void> updateWeight(String value) async {
    try {
      emit(state.copyWith(
          weightStatus: FormzStatus.submissionInProgress,
          isWeightUpdate: true));
      await userRepository.updateWeightInfo(int.parse(value));
      final weightList = await bodyRepository.getWeightList();
      emit(state.copyWith(
          weightStatus: FormzStatus.submissionSuccess, weightList: weightList));
    } catch (e) {
      print('updateWeight: $e');
      emit(state.copyWith(weightStatus: FormzStatus.submissionFailure));
    }
  }

  void weightChanged(String value) {
    final weight = Weight.dirty(value);
    emit(state.copyWith(
      weight: weight,
      weightStatus: Formz.validate([weight]),
    ));
  }

  Future<void> updateHeight(String value) async {
    try {
      emit(state.copyWith(
          heightStatus: FormzStatus.submissionInProgress,
          isWeightUpdate: false));
      await userRepository.updateHeightInfo(int.parse(value));
      final info = await userRepository.getInfo();
      emit(state.copyWith(
          heightStatus: FormzStatus.submissionSuccess,
          height: Height.dirty(info!.height.toString())));
    } catch (e) {
      print('updateHeight: $e');
      emit(state.copyWith(heightStatus: FormzStatus.submissionFailure));
    }
  }

  void heightChanged(String value) {
    final height = Height.dirty(value);
    emit(state.copyWith(
      height: height,
      heightStatus: Formz.validate([height]),
    ));
  }

  Future<void> updateBody() async {
    if (!state.editBodyStatus.isValidated) return;
    emit(state.copyWith(editBodyStatus: FormzStatus.submissionInProgress));
    try {
      await bodyRepository.updateBody(Body(
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

  void initBodyFigure({
    required String shoulder,
    required String chest,
    required String waist,
    required String hip,
  }) {
    emit(state.copyWith(
      shoulder: shoulder == '0'? BodyFigure.pure(): BodyFigure.dirty(shoulder),
      chest: chest == '0'? BodyFigure.pure(): BodyFigure.dirty(chest),
      waist: waist == '0'? BodyFigure.pure(): BodyFigure.dirty(waist),
      hip: hip == '0'? BodyFigure.pure(): BodyFigure.dirty(hip),
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
