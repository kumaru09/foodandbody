import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'home_event.dart';
part 'home_state.dart';

const _duration = const Duration(milliseconds: 1000);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.planRepository}) : super(HomeState(water: 0)) {
    on<WaterChanged>(_onWaterChanged, transformer: debounce(_duration));
    on<IncreaseWaterEvent>(
        (event, emit) => emit(HomeState(water: state.water + 1)));
    on<DecreaseWaterEvent>((event, emit) =>
        emit(HomeState(water: state.water <= 0 ? 0 : state.water - 1)));
    on<LoadWater>(_onFetchWater);
  }

  final PlanRepository planRepository;

  void _onWaterChanged(WaterChanged event, Emitter<HomeState> emit) async {
    final water = event.water;
    try {
      print('adding water: $water');
      await planRepository.addWaterPlan(water);
    } catch (e) {
      print('error adding water');
    }
  }

  void _onFetchWater(LoadWater event, Emitter<HomeState> emit) async {
    try {
      emit(HomeState(water: await planRepository.getWaterPlan()));
    } catch (e) {
      print('$e');
    }
  }
}
