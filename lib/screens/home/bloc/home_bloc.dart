import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'home_event.dart';
part 'home_state.dart';

const _duration = const Duration(milliseconds: 1000);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.planRepository}) : super(HomeState()) {
    on<WaterChanged>(_onWaterChanged, transformer: debounce(_duration));
    on<IncreaseWaterEvent>(
        (event, emit) => emit(state.copyWith(water: state.water + 1)));
    on<DecreaseWaterEvent>((event, emit) =>
        emit(state.copyWith(water: state.water <= 0 ? 0 : state.water - 1)));
    on<LoadWater>(_onFetchWater);
  }

  final PlanRepository planRepository;

  Future<void> _onWaterChanged(
      WaterChanged event, Emitter<HomeState> emit) async {
    final water = event.water;
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      print('adding water: $water');
      await planRepository.addWaterPlan(water);
      emit(state.copyWith(
          status: HomeStatus.success,
          water: await planRepository.getWaterPlan()));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
      print('error adding water');
    }
  }

  Future<void> _onFetchWater(LoadWater event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      emit(state.copyWith(
          status: HomeStatus.success,
          water: await planRepository.getWaterPlan()));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
      print('$e');
    }
  }
}
