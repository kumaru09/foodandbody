part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistory extends HistoryEvent {}

class LoadMenuList extends HistoryEvent {
  const LoadMenuList({required this.dateTime});
  final DateTime? dateTime;
}
