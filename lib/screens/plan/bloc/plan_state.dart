part of 'plan_bloc.dart';

abstract class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object> get props => [];
}

class PlanInitial extends PlanState {
  const PlanInitial();

  @override
  List<Object> get props => [];
}

class PlanLoading extends PlanState {
  const PlanLoading();

  @override
  List<Object> get props => [];
}

class PlanLoaded extends PlanState {
  final History plan;

  const PlanLoaded(this.plan);

  @override
  List<Object> get props => [plan];
}

class PlanError extends PlanState {}
