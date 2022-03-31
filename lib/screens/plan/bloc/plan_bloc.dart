import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';

import 'dart:async';

import 'package:foodandbody/repositories/user_repository.dart';
import 'package:formz/formz.dart';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc({
    required PlanRepository planRepository,
    required UserRepository userRepository,
  })  : _planRepository = planRepository,
        _userRepository = userRepository,
        super(PlanState(plan: History(Timestamp.now()))) {
    on<LoadPlan>(_fetchPlan);
    on<AddExercise>(_onAddExercise);
    on<DeleteExercise>(_deleteExercies);
    on<UpdateGoal>(_updateGoal);
    on<GoalChange>(_goalChanged);
    on<ReturnGoalStatus>(_returnGoalStatus);
  }

  final PlanRepository _planRepository;
  final UserRepository _userRepository;

  Future<void> _fetchPlan(LoadPlan event, Emitter<PlanState> emit) async {
    try {
      if (!event.isRefresh) emit(state.copyWith(status: PlanStatus.loading));
      final plan = await _planRepository.getPlanById();
      final info = await _userRepository.getInfo();
      emit(state.copyWith(
          status: PlanStatus.success,
          plan: plan,
          goal: Calory.dirty(info.goal.toString())));
    } catch (e) {
      emit(state.copyWith(status: PlanStatus.failure));
      print('fetchPlan error: $e');
    }
  }

  Future<void> deleteMenu(String name, double volume) async {
    try {
      await _planRepository.deletePlan(name, volume);
    } catch (e) {
      print('DeleteMenu error: $e');
    }
  }

  Future<void> _onAddExercise(
      AddExercise event, Emitter<PlanState> emit) async {
    try {
      emit(state.copyWith(status: PlanStatus.loading));
      final data =
          exerciseDataList.where((element) => element['id'] == event.id).first;
      final calories = (data['MET'] * 3.5 * event.min * event.weight) / 200;
      await _planRepository.addExercise(ExerciseRepo(
          id: event.id,
          name: data['name'],
          min: event.min,
          calory: calories,
          timestamp: Timestamp.now()));
      final plan = await _planRepository.getPlanById();
      emit(state.copyWith(status: PlanStatus.success, plan: plan));
    } catch (e) {
      emit(state.copyWith(status: PlanStatus.failure));
      print('onAddExercise error: $e');
    }
  }

  Future<void> _deleteExercies(
      DeleteExercise event, Emitter<PlanState> emit) async {
    try {
      await _planRepository.deleteExercise(event.exerciseRepo);
      emit(state.copyWith(status: PlanStatus.loading));
      final plan = await _planRepository.getPlanById();
      emit(state.copyWith(status: PlanStatus.success, plan: plan));
    } catch (e) {
      emit(state.copyWith(status: PlanStatus.failure));
      print('_deleteExercise error: $e');
    }
  }

  Future<void> _updateGoal(UpdateGoal event, Emitter<PlanState> emit) async {
    try {
      emit(state.copyWith(goalStatus: FormzStatus.submissionInProgress));
      await _userRepository.updateGoalInfo(int.parse(event.goal));
      final info = await _userRepository.getInfo();
      emit(state.copyWith(
          goalStatus: FormzStatus.submissionSuccess,
          goal: Calory.dirty(info.goal.toString())));
    } catch (e) {
      print('updateGoal: $e');
      emit(state.copyWith(goalStatus: FormzStatus.submissionFailure));
    }
  }

  void _goalChanged(GoalChange event, Emitter<PlanState> emit) {
    final goal = Calory.dirty(event.value);
    emit(state.copyWith(
      goal: goal,
      goalStatus: Formz.validate([goal]),
    ));
  }

  void _returnGoalStatus(ReturnGoalStatus event, Emitter<PlanState> emit) {
    emit(state.copyWith(goalStatus: FormzStatus.pure));
  }
}

const List exerciseDataList = [
  {'id': '0', 'name': 'แอโรบิค', 'MET': 8},
  {'id': '1', 'name': 'ปั่นจักรยาน', 'MET': 7.5},
  {'id': '2', 'name': 'วิ่ง', 'MET': 6},
];
