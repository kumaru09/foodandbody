part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class IncreaseWaterEvent extends HomeEvent {}

class DecreaseWaterEvent extends HomeEvent {}

class WaterChanged extends HomeEvent {
  const WaterChanged({required this.water});
  final int water;

  @override
  List<Object> get props => [water];

  @override
  String toString() {
    return 'WaterChanged { water: $water }';
  }
}

class LoadWater extends HomeEvent {
  const LoadWater({this.isRefresh = false});
  final bool isRefresh;
}