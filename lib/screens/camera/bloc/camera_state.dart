part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, success, failure }

class CameraState extends Equatable {
  final CameraStatus status;
  final List<MenuShow> results;
  final FoodCalory cal;

  CameraState({
    this.status = CameraStatus.initial,
    List<MenuShow>? results,
    this.cal = const FoodCalory.pure(),
  })  : this.results = results ?? [];

  CameraState copyWith(
      {CameraStatus? status,
      List<MenuShow>? results,
      FoodCalory? cal}) {
    return CameraState(
      status: status ?? this.status,
      results: results ?? this.results,
      cal: cal ?? this.cal,
    );
  }

  @override
  String toString() {
    return "CameraState { status: $status, results: $results, cal: $cal }";
  }

  @override
  List<Object?> get props => [status, results, cal];
}
