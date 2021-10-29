import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(water: 0));

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is IncreaseWaterEvent) {
      yield HomeState(water: state.water + 1);
    }
    else if(event is DecreaseWaterEvent) {
      yield HomeState(water: state.water <= 0 ? 0 : state.water - 1);
    }
  }
}