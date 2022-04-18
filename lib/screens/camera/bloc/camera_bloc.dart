import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/models/depth.dart';
import 'package:foodandbody/models/food_calory.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/services/arcore_service.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc(
      {required this.cameraRepository,
      required this.planRepository,
      required this.bodyRepository})
      : super(CameraState()) {
    on<GetPredictonWithDepth>(_getPredictionFoodWithDepth);
    on<SetIsFlat>((event, emit) => emit(state.copyWith(isFlat: event.isFlat)));
    on<SetHasPlane>(
        (event, emit) => emit(state.copyWith(hasPlane: event.hasPlane)));
    // on<GetPredicton>(_getPredictionFood);
    on<CalChanged>(_onCalChanged);
    on<AddPlanCamera>(_addPlanCamera);
    on<GetBodyPredict>(_getBodyPredict);
    on<AddBodyCamera>(_addBodyCamera);
  }

  final CameraRepository cameraRepository;
  final PlanRepository planRepository;
  final BodyRepository bodyRepository;

  // Future<void> _getPredictionFood(
  //     GetPredicton event, Emitter<CameraState> emit) async {
  //   try {
  //     emit(state.copyWith(status: CameraStatus.loading, results: List.empty()));
  //     final results = await cameraRepository.getPredictFood(event.file);
  //     emit(state.copyWith(status: CameraStatus.success, results: results));
  //   } catch (e) {
  //     emit(state.copyWith(status: CameraStatus.failure));
  //   }
  // }

  Future<void> _getPredictionFoodWithDepth(
      GetPredictonWithDepth event, Emitter<CameraState> emit) async {
    try {
      emit(
          state.copyWith(status: CameraStatus.loading, predicts: List.empty()));
      final results = await cameraRepository.getPredictionFoodWithDepth(
          event.file, event.depth);
      emit(state.copyWith(status: CameraStatus.success, predicts: results));
    } catch (e) {
      emit(state.copyWith(status: CameraStatus.failure));
    }
  }

  Future<void> _getBodyPredict(
      GetBodyPredict event, Emitter<CameraState> emit) async {
    try {
      emit(state.copyWith(status: CameraStatus.loading, results: null));
      final results = await cameraRepository.getPredictBody(
          image: event.image, height: event.height);
      emit(state.copyWith(status: CameraStatus.success, results: results));
    } catch (_) {
      emit(state.copyWith(status: CameraStatus.failure));
    }
  }

  Future<void> _addPlanCamera(
      AddPlanCamera event, Emitter<CameraState> emit) async {
    try {
      emit(state.copyWith(status: CameraStatus.loading));
      for (var i in event.predicts) {
        await planRepository.addPlanCamera(i);
      }
      emit(state.copyWith(status: CameraStatus.success, predicts: []));
    } catch (_) {
      emit(state.copyWith(status: CameraStatus.failure));
    }
  }

  Future<void> _addBodyCamera(
      AddBodyCamera event, Emitter<CameraState> emit) async {
    try {
      emit(state.copyWith(status: CameraStatus.loading));
      await bodyRepository.updateBody(Body(
          date: Timestamp.now(),
          shoulder: event.bodyPredict.shoulder,
          chest: event.bodyPredict.chest,
          waist: event.bodyPredict.waist,
          hip: event.bodyPredict.hip));
      emit(state.copyWith(status: CameraStatus.success, results: null));
    } catch (_) {
      emit(state.copyWith(status: CameraStatus.failure));
    }
  }

  Future<void> _onCalChanged(
      CalChanged event, Emitter<CameraState> emit) async {
    emit(state.copyWith(cal: FoodCalory.dirty(event.value)));
  }
}
