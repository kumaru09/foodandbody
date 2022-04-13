import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/food_calory.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/repositories/camera_repository.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc({required this.cameraRepository}) : super(CameraState()) {
    on<GetPredicton>(_getPredictionFood);
    on<CalChanged>(_onCalChanged);
  }

  final CameraRepository cameraRepository;

  Future<void> _getPredictionFood(
      GetPredicton event, Emitter<CameraState> emit) async {
    try {
      emit(state.copyWith(status: CameraStatus.loading));
      final results = await cameraRepository.getPredictFood(event.file);
      emit(state.copyWith(status: CameraStatus.success, results: results));
    } catch (e) {
      emit(state.copyWith(status: CameraStatus.failure));
    }
  }

  Future<void> _onCalChanged(
      CalChanged event, Emitter<CameraState> emit) async {
    emit(state.copyWith(cal: FoodCalory.dirty(event.value)));
  }
}
