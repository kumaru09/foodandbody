import 'package:equatable/equatable.dart';

class BodyPredict extends Equatable {
  final int shoulder;
  final int chest;
  final int waist;
  final int hip;

  const BodyPredict(
      {required this.shoulder,
      required this.chest,
      required this.waist,
      required this.hip});

  BodyPredict copyWith({int? shoulder, int? chest, int? waist, int? hip}) {
    return BodyPredict(
        waist: waist ?? this.waist,
        shoulder: shoulder ?? this.shoulder,
        chest: chest ?? this.chest,
        hip: hip ?? this.hip);
  }

  static BodyPredict fromJson(Map<String, Object?> json) {
    return BodyPredict(
        shoulder: json['shoulder'] as int,
        chest: json['chest'] as int,
        waist: json['waist'] as int,
        hip: json['hip'] as int);
  }

  static final empty = BodyPredict(waist: 0, shoulder: 0, chest: 0, hip: 0);

  @override
  int get hashCode =>
      shoulder.hashCode ^ waist.hashCode ^ chest.hashCode ^ hip.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyPredict &&
          runtimeType == other.runtimeType &&
          waist == other.waist &&
          shoulder == other.shoulder &&
          chest == other.chest &&
          hip == other.hip;

  @override
  String toString() {
    return "BodyPredict { waist: $waist, shoulder: $shoulder, chest: $chest, hip: $hip }";
  }

  @override
  List<Object?> get props => [waist, shoulder, chest, hip];
}
