part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final int water;
  final HomeStatus status;
  final List<ExerciseRepo> exerciseList;
  HomeState(
      {this.status = HomeStatus.initial,
      this.water = 0,
      List<ExerciseRepo>? exerciseList})
      : this.exerciseList = exerciseList ?? [];

  HomeState copyWith(
      {HomeStatus? status, int? water, List<ExerciseRepo>? exerciseList}) {
    return HomeState(
        status: status ?? this.status,
        water: water ?? this.water,
        exerciseList: exerciseList ?? this.exerciseList);
  }

  @override
  String toString() {
    return 'HomeState { status: $status, water: $water, exerciseList: $exerciseList }';
  }

  @override
  List<Object> get props => [status, water, exerciseList];
}
