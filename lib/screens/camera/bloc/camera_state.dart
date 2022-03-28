part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, success, failure }

class CameraState extends Equatable {
  final CameraStatus status;
  final List<MenuShow> results;
  final List<Predict> predicts;
  final int isFlat;
  final bool hasPlane;

  CameraState(
      {this.status = CameraStatus.initial,
      List<MenuShow>? results,
      List<Predict>? predicts,
      this.isFlat = 75,
      this.hasPlane = false})
      : this.results = results ?? [],
        this.predicts = predicts ?? [];

  CameraState copyWith(
      {CameraStatus? status,
      List<MenuShow>? results,
      List<Predict>? predicts,
      int? isFlat,
      bool? hasPlane}) {
    return CameraState(
        status: status ?? this.status,
        results: results ?? this.results,
        predicts: predicts ?? this.predicts,
        isFlat: isFlat ?? this.isFlat,
        hasPlane: hasPlane ?? this.hasPlane);
  }

  @override
  String toString() {
    return "CameraState { status: $status, results: $results, predicts: $predicts isFlat: $isFlat, hasPlane: $hasPlane }";
  }

  @override
  List<Object?> get props => [status, results, predicts, isFlat, hasPlane];
}
