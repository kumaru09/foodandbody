part of 'body_cubit.dart';

enum BodyStatus { initial, loading, success, failure }

extension BodyStatusX on BodyStatus {
  bool get isInitial => this == BodyStatus.initial;
  bool get isLoading => this == BodyStatus.loading;
  bool get isSuccess => this == BodyStatus.success;
  bool get isFailure => this == BodyStatus.failure;
}

class BodyState extends Equatable {
  BodyState({this.status = BodyStatus.initial, Body? body})
      : body = body ?? Body.empty;

  final BodyStatus status;
  final Body body;

  BodyState copyWith({BodyStatus? status, Body? body}) {
    return BodyState(body: body ?? this.body, status: status ?? this.status);
  }

  @override
  List<Object> get props => [status, body];
}
