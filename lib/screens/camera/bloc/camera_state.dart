part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, success, failure }

class CameraState extends Equatable {
  final CameraStatus status;
  final BodyPredict? results;
  final List<Predict> predicts;
  final int isFlat;
  final bool hasPlane;
  final bool? isSupportAR;
  final FoodCalory cal;

  CameraState(
      {this.status = CameraStatus.initial,
      BodyPredict? results,
      List<Predict>? predicts,
      this.isFlat = 75,
      this.hasPlane = false,
      this.cal = const FoodCalory.pure(),
      this.isSupportAR})
      : this.results = results ?? null,
        this.predicts = predicts ?? [];

  CameraState copyWith(
      {CameraStatus? status,
      BodyPredict? results,
      List<Predict>? predicts,
      int? isFlat,
      bool? hasPlane,
      bool? isSupportAR,
      FoodCalory? cal}) {
    return CameraState(
      status: status ?? this.status,
      results: results ?? this.results,
      predicts: predicts ?? this.predicts,
      isFlat: isFlat ?? this.isFlat,
      hasPlane: hasPlane ?? this.hasPlane,
      isSupportAR: isSupportAR ?? this.isSupportAR,
      cal: cal ?? this.cal,
    );
  }

  @override
  String toString() {
    return "CameraState { status: $status, results: $results, predicts: $predicts isFlat: $isFlat, hasPlane: $hasPlane, isSupportAR: $isSupportAR, cal: $cal }";
  }

  @override
  List<Object?> get props =>
      [status, results, predicts, isFlat, hasPlane, isSupportAR, cal];
}
