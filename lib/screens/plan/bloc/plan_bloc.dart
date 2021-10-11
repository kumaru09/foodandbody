import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';

import 'dart:async';

part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc(this._planRepository) : super(PlanInitial());

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
}
