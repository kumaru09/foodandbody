part of 'history_bloc.dart';

enum HistoryStatus { initial, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final GraphList? graphList;
  final List<HistoryMenuItem> menuList;
  final DateTime dateMenuList;

  HistoryState({
    this.status = HistoryStatus.initial,
    GraphList? graphList,
    List<HistoryMenuItem>? menuList,
    required DateTime dateMenuList,
  })  : this.graphList = graphList ?? null,
        this.menuList = menuList ?? [],
        this.dateMenuList = dateMenuList;

  HistoryState copyWith({
    HistoryStatus? status,
    GraphList? graphList,
    List<HistoryMenuItem>? menuList,
    DateTime? dateMenuList,
  }) {
    return HistoryState(
      status: status ?? this.status,
      graphList: graphList ?? this.graphList,
      menuList: menuList ?? this.menuList,
      dateMenuList: dateMenuList ?? this.dateMenuList,
    );
  }

  @override
  String toString() {
    return 'HistoryState { status: $status,  graphList: $graphList, menuList: $menuList, dateMenuList: $dateMenuList }';
  }

  @override
  List<Object?> get props => [status, graphList, menuList, dateMenuList];
}
