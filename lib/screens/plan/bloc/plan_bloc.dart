import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';

import 'dart:async';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc({required PlanRepository planRepository})
      : _planRepository = planRepository,
        super(PlanInitial());

  final PlanRepository _planRepository;

  @override
  Stream<PlanState> mapEventToState(PlanEvent event) async* {
    if (event is LoadPlan) {
      try {
        yield PlanLoading();
        final plan = await _planRepository.getPlanById();
        yield PlanLoaded(plan);
      } catch (e) {
        print('error: $e');
        yield PlanError();
      }
    }
  }

  Future<void> deleteMenu(String name) async {
    try {
      await _planRepository.deletePlan(name);
    } catch (e) {
      print('error: $e');
    }
  }
}
