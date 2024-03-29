import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/exercise_time.dart';
import 'package:foodandbody/models/exercise_type.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
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
        super(PlanState()) {
    on<LoadPlan>(_fetchPlan);
    on<DeleteMenu>(_deleteMenu);
    on<AddExercise>(_onAddExercise);
    on<ExerciseTypeChange>(_exerciseTypeChanged);
    on<ExerciseTimeChange>(_exerciseTimeChanged);
    on<DeleteExercise>(_deleteExercies);
    on<UpdateGoal>(_updateGoal);
    on<GoalChange>(_goalChanged);
  }

  final PlanRepository _planRepository;
  final UserRepository _userRepository;

  Future<void> _fetchPlan(LoadPlan event, Emitter<PlanState> emit) async {
    try {
      if (!event.isRefresh) emit(state.copyWith(status: PlanStatus.loading));
      final plan = await _planRepository.getPlanById();
      final info = await _userRepository.getInfo(true);
      emit(state.copyWith(
        status: PlanStatus.success,
        plan: plan,
        info: info,
        goal: Calory.dirty(info!.goal.toString()),
        exerciseStatus: FormzStatus.submissionSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: PlanStatus.failure,
          exerciseStatus: FormzStatus.submissionFailure));
      print('fetchPlan error: $e');
    }
  }

  Future<void> _deleteMenu(DeleteMenu event, Emitter<PlanState> emit) async {
    try {
      emit(state.copyWith(
          deleteMenuStatus: DeleteMenuStatus.loading, isDeleteMenu: true));
      await _planRepository.deletePlan(event.name, event.volume);
      emit(state.copyWith(deleteMenuStatus: DeleteMenuStatus.success));
    } catch (e) {
      print('DeleteMenu error: $e');
      emit(state.copyWith(deleteMenuStatus: DeleteMenuStatus.failure));
    }
  }

  Future<void> _onAddExercise(
      AddExercise event, Emitter<PlanState> emit) async {
    try {
      emit(state.copyWith(exerciseStatus: FormzStatus.submissionInProgress));
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
      emit(state.copyWith(
          exerciseStatus: FormzStatus.submissionSuccess, plan: plan));
    } catch (e) {
      emit(state.copyWith(exerciseStatus: FormzStatus.submissionFailure));
      print('onAddExercise error: $e');
    }
  }

  void _exerciseTypeChanged(ExerciseTypeChange event, Emitter<PlanState> emit) {
    final type = ExerciseType.dirty(event.value);
    emit(state.copyWith(
      exerciseType: type,
      exerciseStatus: Formz.validate([type, state.exerciseTime]),
    ));
  }

  void _exerciseTimeChanged(ExerciseTimeChange event, Emitter<PlanState> emit) {
    final time = ExerciseTime.dirty(event.value);
    emit(state.copyWith(
      exerciseTime: time,
      exerciseStatus: Formz.validate([state.exerciseType, time]),
    ));
  }

  Future<void> _deleteExercies(
      DeleteExercise event, Emitter<PlanState> emit) async {
    try {
      emit(state.copyWith(exerciseStatus: FormzStatus.submissionInProgress));
      await _planRepository.deleteExercise(event.exerciseRepo);
      final plan = await _planRepository.getPlanById();
      emit(state.copyWith(
          exerciseStatus: FormzStatus.submissionSuccess, plan: plan));
    } catch (e) {
      emit(state.copyWith(exerciseStatus: FormzStatus.submissionFailure));
      print('_deleteExercise error: $e');
    }
  }

  Future<void> _updateGoal(UpdateGoal event, Emitter<PlanState> emit) async {
    try {
      emit(state.copyWith(
          goalStatus: FormzStatus.submissionInProgress, isDeleteMenu: false));
      await _userRepository.updateGoalInfo(int.parse(event.goal));
      final info = await _userRepository.getInfo();
      emit(state.copyWith(
        goalStatus: FormzStatus.submissionSuccess,
        goal: Calory.dirty(info!.goal.toString()),
        info: info,
      ));
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
}

const List exerciseDataList = [
  {'id': '0', 'name': 'แอโรบิค', 'MET': 8},
  {'id': '1', 'name': 'ปั่นจักรยาน', 'MET': 7.5},
  {'id': '2', 'name': 'วิ่ง', 'MET': 6},
];
