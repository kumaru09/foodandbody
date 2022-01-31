import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';

import 'dart:async';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc({required PlanRepository planRepository})
      : _planRepository = planRepository,
        super(PlanState(plan: History(Timestamp.now()))) {
    on<LoadPlan>(_fetchPlan);
    on<AddExercise>(_onAddExercise);
    on<DeleteExercise>(_deleteExercies);
  }

  final PlanRepository _planRepository;

  Future<void> _fetchPlan(LoadPlan event, Emitter<PlanState> emit) async {
    try {
      emit(state.copyWith(status: PlanStatus.loading));
      final plan = await _planRepository.getPlanById();
      emit(state.copyWith(status: PlanStatus.success, plan: plan));
    } catch (e) {
      emit(state.copyWith(status: PlanStatus.failure));
      print('fetchPlan error: $e');
    }
  }

  Future<void> deleteMenu(String name) async {
    try {
      await _planRepository.deletePlan(name);
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
}

const List exerciseDataList = [
  {'id': '0', 'name': 'แอโรบิค', 'MET': 8},
  {'id': '1', 'name': 'ปั่นจักรยาน', 'MET': 7.5},
  {'id': '2', 'name': 'วิ่ง', 'MET': 6},
];
