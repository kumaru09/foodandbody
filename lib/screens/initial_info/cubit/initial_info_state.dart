part of 'initial_info_cubit.dart';

class InitialInfoState extends Equatable {
  const InitialInfoState({
    this.username = const Username.pure(),
    this.weight = const Weight.pure(),
    this.height = const Height.pure(),
    this.age = const Age.pure(),
    this.gender = const Gender.pure(),
    this.exercise = const Exercise.pure(),
    this.status = FormzStatus.pure
  });

  final Username username;
  final Weight weight;
  final Height height;
  final Age age;
  final Gender gender;
  final Exercise exercise;
  final FormzStatus status;

  @override
  List<Object> get props => [username, weight, height, age, gender, exercise, status];

  InitialInfoState copyWith({
    Username? username,
    Weight? weight,
    Height? height,
    Age? age,
    Gender? gender,
    Exercise? exercise,
    FormzStatus? status
  }) {
    return InitialInfoState(
      username: username ?? this.username,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      exercise: exercise ?? this.exercise,
      status: status ?? this.status
    );
  }
}