part of 'info_bloc.dart';

abstract class InfoEvent extends Equatable {
  const InfoEvent();

  @override
  List<Object> get props => [];
}

class LoadInfo extends InfoEvent {}

class AddInfo extends InfoEvent {}

class UpdateGoal extends InfoEvent {
  UpdateGoal({required this.goal});
  final int goal;
}

// class UpdateHeight extends InfoEvent {
//   UpdateHeight({required this.height});
//   final int height;
// }

// class UpdateWeight extends InfoEvent {
//   UpdateWeight({required this.weight});
//   final int weight;
// }
