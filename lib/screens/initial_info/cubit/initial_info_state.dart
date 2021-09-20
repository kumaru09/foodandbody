part of 'initial_info_cubit.dart';

class InitialInfoState extends Equatable {
  const InitialInfoState({
    this.username = const Username.pure(),
    this.weight = const Weight.pure(),
    this.height = const Height.pure(),
    this.gender = const Gender.pure(),
    this.calory = const Calory.pure(),
    this.status = FormzStatus.pure
  });

  final Username username;
  final Weight weight;
  final Height height;
  final Gender gender;
  final Calory calory;
  final FormzStatus status;

  @override
  List<Object> get props => [username, weight, height, gender, calory, status];

  InitialInfoState copyWith({
    Username? username,
    Weight? weight,
    Height? height,
    Gender? gender,
    Calory? calory,
    FormzStatus? status
  }) {
    return InitialInfoState(
      username: username ?? this.username,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      calory: calory ?? this.calory,
      status: status ?? this.status
    );
  }
}