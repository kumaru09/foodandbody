part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, success, failure }

class CameraState extends Equatable {
  final CameraStatus status;
  final List<MenuShow> results;
  final int isFlat;
  final bool hasPlane;

  CameraState(
      {this.status = CameraStatus.initial,
      List<MenuShow>? results,
      this.isFlat = 75,
      this.hasPlane = false})
      : this.results = results ?? [];

  CameraState copyWith(
      {CameraStatus? status,
      List<MenuShow>? results,
      int? isFlat,
      bool? hasPlane}) {
    return CameraState(
        status: status ?? this.status,
        results: results ?? this.results,
        isFlat: isFlat ?? this.isFlat,
        hasPlane: hasPlane ?? this.hasPlane);
  }

  @override
  String toString() {
    return "CameraState { status: $status, results: $results, isFlat: $isFlat, hasPlane: $hasPlane }";
  }

  @override
  List<Object?> get props => [status, results, isFlat, hasPlane];
}
