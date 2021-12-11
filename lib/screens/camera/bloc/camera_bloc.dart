import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/repositories/camera_repository.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc({required this.cameraRepository}) : super(CameraState()) {
    on<GetPredicton>(getPredictionFood);
  }

  final CameraRepository cameraRepository;

  Future<void> getPredictionFood(
      GetPredicton event, Emitter<CameraState> emit) async {
    try {
      emit(state.copyWith(status: CameraStatus.loading));
      final results = await cameraRepository.getPredictFood(event.file);
      emit(state.copyWith(status: CameraStatus.success, results: results));
    } catch (e) {
      emit(state.copyWith(status: CameraStatus.failure));
    }
  }
}
