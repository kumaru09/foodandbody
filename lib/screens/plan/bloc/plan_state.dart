part of 'plan_bloc.dart';

enum PlanStatus { initial, loading, success, failure }

class PlanState extends Equatable {
  final PlanStatus status;
  final History plan;

  PlanState({this.status = PlanStatus.initial, required this.plan});

  PlanState copyWith({PlanStatus? status, History? plan}) {
    return PlanState(status: status ?? this.status, plan: plan ?? this.plan);
  }

  @override
  String toString() {
    return 'PlanState {status: $status, plan: $plan}';
  }

  @override
  List<Object> get props => [status, plan];
}
