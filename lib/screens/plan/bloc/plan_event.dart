part of 'plan_bloc.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object> get props => [];
}

class LoadPlan extends PlanEvent {}

class AddExercise extends PlanEvent {
  final String id;
  final int min;
  final int weight;

  const AddExercise(
      {required this.id, required this.min, required this.weight});

  @override
  String toString() {
    return 'AddExercise {id: $id, min: $min, weight: $weight}';
  }

  @override
  List<Object> get props => [id, min, weight];
}
