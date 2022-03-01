import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/models/history_menu.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(
      {required HistoryRepository historyRepository,
      required BodyRepository bodyRepository})
      : historyRepository = historyRepository,
        bodyRepository = bodyRepository,
        super(HistoryState(
            status: HistoryStatus.initial, dateMenuList: DateTime.now())) {
    on<LoadHistory>(_onFetchHistory);
    on<LoadMenuList>(_onFetchMenuList);
  }

  final HistoryRepository historyRepository;
  final BodyRepository bodyRepository;

  Future<void> _onFetchHistory(
      LoadHistory event, Emitter<HistoryState> emit) async {
    try {
      if (state.status != HistoryStatus.initial)
        emit(state.copyWith(status: HistoryStatus.initial));
      final history = await historyRepository.getHistory();
      final body = await bodyRepository.getBodyList();
      final weight = await bodyRepository.getWeightList();
      final graphList = GraphList(
          caloriesList: history.map((e) => e.totalCal.toInt()).toList(),
          burnList: history.map((e) => e.totalBurn.toInt()).toList(),
          proteinList:
              history.map((e) => e.totalNutrientList.protein.toInt()).toList(),
          carbList:
              history.map((e) => e.totalNutrientList.carb.toInt()).toList(),
          fatList: history.map((e) => e.totalNutrientList.fat.toInt()).toList(),
          waterList: history.map((e) => e.totalWater).toList(),
          shoulderList: body.map((e) => e.shoulder).toList(),
          chestList: body.map((e) => e.chest).toList(),
          waistList: body.map((e) => e.waist).toList(),
          hipList: body.map((e) => e.hip).toList(),
          weightList: weight.map((e) => e.weight).toList(),
          foodStartDate: history.first.date.toDate(),
          foodEndDate: history.last.date.toDate(),
          bodyStartDate:
              body.isNotEmpty ? body.first.date.toDate() : DateTime.now(),
          bodyEndDate:
              body.isNotEmpty ? body.last.date.toDate() : DateTime.now(),
          weightStartDate: weight.first.date!.toDate(),
          weightEndDate: weight.last.date!.toDate());
      emit(state.copyWith(status: HistoryStatus.success, graphList: graphList));
    } catch (e) {
      print('$e');
      emit(state.copyWith(status: HistoryStatus.failure));
    }
  }

  Future<void> _onFetchMenuList(
      LoadMenuList event, Emitter<HistoryState> emit) async {
    if (state.status == HistoryStatus.success) {
      emit(state.copyWith(status: HistoryStatus.initial));
    }
    final DateTime midNight = DateTime(
        event.dateTime!.year, event.dateTime!.month, event.dateTime!.day);
    final DateTime beforeMidNight =
        midNight.add(new Duration(hours: 23, minutes: 59, seconds: 59));
    final Timestamp stateTime = Timestamp.fromDate(midNight);
    final Timestamp endTime = Timestamp.fromDate(beforeMidNight);
    print('${stateTime.toDate()}, ${endTime.toDate()}');
    try {
      final List<Menu> menuList =
          await historyRepository.getMenuListByDate(stateTime, endTime);
      if (menuList.isNotEmpty) print('have menu: ${menuList.length}');
      emit(state.copyWith(
          status: HistoryStatus.success,
          menuList: menuList
              .where((element) => element.timestamp != null)
              .map((e) => HistoryMenuItem(
                  name: e.name, date: e.timestamp, calory: e.calories.toInt()))
              .toList(),
          dateMenuList: event.dateTime));
    } catch (e) {
      print('$e');
      emit(state.copyWith(status: HistoryStatus.failure));
    }
  }
}
