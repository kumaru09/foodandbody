part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, success, failure }

class CameraState extends Equatable {
  final CameraStatus status;
  final List<MenuShow> results;

  CameraState({this.status = CameraStatus.initial, List<MenuShow>? results})
      : this.results = results ?? [];

  CameraState copyWith({CameraStatus? status, List<MenuShow>? results}) {
    return CameraState(
        status: status ?? this.status, results: results ?? this.results);
  }

  @override
  String toString() {
    return "CameraState { status: $status, results: $results }";
  }

  @override
  List<Object?> get props => [status, results];
}
