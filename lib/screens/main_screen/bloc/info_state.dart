part of 'info_bloc.dart';

enum InfoStatus { initial, loading, success, failure }

class InfoState extends Equatable {
  InfoState({this.status = InfoStatus.initial, Info? info}) : this.info = info;

  final Info? info;
  final InfoStatus status;

  InfoState copyWith({InfoStatus? status, Info? info}) {
    return InfoState(
      status: status ?? this.status,
      info: info ?? this.info,
    );
  }

  @override
  String toString() {
    return 'InfoStatus { status: $status, info: $info }';
  }

  @override
  List<Object?> get props => [status, info];
}
