part of 'plan_bloc.dart';

enum PlanStatus { initial, loading, success, failure }
enum ExerciseStatus { initial, loading, success, failure }

class PlanState extends Equatable {
  final PlanStatus status;
  final History plan;
  final Info? info;
  final FormzStatus goalStatus;
  final Calory goal;
  final ExerciseStatus exerciseStatus;


  PlanState({
    this.status = PlanStatus.initial,
    required this.plan,
    this.info,
    this.goalStatus = FormzStatus.pure,
    this.goal = const Calory.pure(),
    this.exerciseStatus = ExerciseStatus.initial,
  });

  PlanState copyWith({
    PlanStatus? status,
    History? plan,
    Info? info,
    FormzStatus? goalStatus,
    Calory? goal,
    ExerciseStatus? exerciseStatus,
  }) {
    return PlanState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      info: info ?? this.info,
      goalStatus: goalStatus ?? this.goalStatus,
      goal: goal ?? this.goal,
      exerciseStatus: exerciseStatus ?? this.exerciseStatus,
    );
  }

  @override
  String toString() {
    return 'PlanState {status: $status, plan: $plan, info: $info, goalStatus: $goalStatus, goal: $goal, exerciseStatus: $exerciseStatus }';
  }

  @override
  List<Object?> get props => [status, plan, info, goalStatus, goal, exerciseStatus];
}
