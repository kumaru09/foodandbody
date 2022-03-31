part of 'plan_bloc.dart';

enum PlanStatus { initial, loading, success, failure }

class PlanState extends Equatable {
  final PlanStatus status;
  final History plan;
  final FormzStatus goalStatus;
  final Calory goal;

  PlanState({
    this.status = PlanStatus.initial,
    required this.plan,
    this.goalStatus = FormzStatus.pure,
    this.goal = const Calory.pure(),
  });

  PlanState copyWith({
    PlanStatus? status,
    History? plan,
    FormzStatus? goalStatus,
    Calory? goal,
  }) {
    return PlanState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      goalStatus: goalStatus ?? this.goalStatus,
      goal: goal ?? this.goal,
    );
  }

  @override
  String toString() {
    return 'PlanState {status: $status, plan: $plan, goalStatus: $goalStatus, goal: $goal}';
  }

  @override
  List<Object?> get props => [status, plan, goalStatus, goal];
}
