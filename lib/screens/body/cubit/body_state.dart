part of 'body_cubit.dart';

enum BodyStatus { initial, loading, success, failure }

extension BodyStatusX on BodyStatus {
  bool get isInitial => this == BodyStatus.initial;
  bool get isLoading => this == BodyStatus.loading;
  bool get isSuccess => this == BodyStatus.success;
  bool get isFailure => this == BodyStatus.failure;
}

class BodyState extends Equatable {
  BodyState(
      {this.status = BodyStatus.initial,
      Body? body,
      List<WeightList>? weightList})
      : body = body ?? Body.empty,
        weightList = weightList ?? List.empty();

  final BodyStatus status;
  final Body body;
  final List<WeightList> weightList;

  BodyState copyWith(
      {BodyStatus? status, Body? body, List<WeightList>? weightList}) {
    return BodyState(
        body: body ?? this.body,
        status: status ?? this.status,
        weightList: weightList);
  }

  @override
  List<Object> get props => [status, body, weightList];
}
