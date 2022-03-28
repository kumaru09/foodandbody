part of 'body_cubit.dart';

enum BodyStatus { initial, loading, success, failure }

extension BodyStatusX on BodyStatus {
  bool get isInitial => this == BodyStatus.initial;
  bool get isLoading => this == BodyStatus.loading;
  bool get isSuccess => this == BodyStatus.success;
  bool get isFailure => this == BodyStatus.failure;
}

class BodyState extends Equatable {
  BodyState({
    this.status = BodyStatus.initial,
    List<WeightList>? weightList,
    this.editBodyStatus = FormzStatus.pure,
    this.shoulder = const BodyFigure.pure(),
    this.chest = const BodyFigure.pure(),
    this.waist = const BodyFigure.pure(),
    this.hip = const BodyFigure.pure(),
    this.bodyDate,
    this.weightStatus = FormzStatus.pure,
    this.weight = const Weight.pure(),
    this.heightStatus = FormzStatus.pure,
    this.height = const Height.pure(),
    this.isWeightUpdate = true,
  }) : weightList = weightList ?? List.empty();

  final BodyStatus status;
  final List<WeightList> weightList;
  final FormzStatus editBodyStatus;
  final BodyFigure shoulder;
  final BodyFigure chest;
  final BodyFigure waist;
  final BodyFigure hip;
  final Timestamp? bodyDate;
  final FormzStatus weightStatus;
  final Weight weight;
  final FormzStatus heightStatus;
  final Height height;
  final bool isWeightUpdate;

  BodyState copyWith({
    BodyStatus? status,
    List<WeightList>? weightList,
    FormzStatus? editBodyStatus,
    BodyFigure? shoulder,
    BodyFigure? chest,
    BodyFigure? waist,
    BodyFigure? hip,
    Timestamp? bodyDate,
    FormzStatus? weightStatus,
    Weight? weight,
    FormzStatus? heightStatus,
    Height? height,
    bool? isWeightUpdate,
  }) {
    return BodyState(
      status: status ?? this.status,
      weightList: weightList ?? this.weightList,
      editBodyStatus: editBodyStatus ?? this.editBodyStatus,
      shoulder: shoulder ?? this.shoulder,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hip: hip ?? this.hip,
      bodyDate: bodyDate ?? this.bodyDate,
      weightStatus: weightStatus ?? this.weightStatus,
      weight: weight ?? this.weight,
      heightStatus: heightStatus ?? this.heightStatus,
      height: height ?? this.height,
      isWeightUpdate: isWeightUpdate ?? this.isWeightUpdate,
    );
  }

  @override
  List<Object> get props => [
        status,
        weightList,
        editBodyStatus,
        shoulder,
        chest,
        waist,
        hip,
        weightStatus,
        weight,
        heightStatus,
        height,
        isWeightUpdate,
      ];
}
