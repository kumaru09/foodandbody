part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final int water;
  final HomeStatus status;
  HomeState({this.status = HomeStatus.initial, this.water = 0});

  HomeState copyWith({HomeStatus? status, int? water}) {
    return HomeState(status: status ?? this.status, water: water ?? this.water);
  }

  @override
  String toString() {
    return 'HomeState { status: $status, water: $water }';
  }

  @override
  List<Object> get props => [status, water];
}
