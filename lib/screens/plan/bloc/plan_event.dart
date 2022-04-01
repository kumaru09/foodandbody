part of 'plan_bloc.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();

  @override
  List<Object> get props => [];
}

class LoadPlan extends PlanEvent {
  const LoadPlan({this.isRefresh = false});
  final bool isRefresh;
}

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

class DeleteExercise extends PlanEvent {
  final ExerciseRepo exerciseRepo;

  const DeleteExercise({required this.exerciseRepo});

  @override
  String toString() {
    return 'deleteExercise {$exerciseRepo}';
  }

  @override
  List<Object> get props => [exerciseRepo];
}

class UpdateGoal extends PlanEvent {
  const UpdateGoal({required this.goal});
  final String goal;

  @override
  String toString() {
    return 'goal {$goal}';
  }

  @override
  List<Object> get props => [goal];
}

class GoalChange extends PlanEvent {
  const GoalChange({required this.value});
  final String value;

  @override
  String toString() {
    return 'goal {$value}';
  }

  @override
  List<Object> get props => [value];
}
