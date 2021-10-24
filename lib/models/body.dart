import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/body_entity.dart';

class Body extends Equatable {
  final Timestamp date;
  final List<int> weight;
  final int shoulder;
  final int chest;
  final int waist;
  final int hip;

  const Body(
      {required this.date,
      required this.weight,
      required this.shoulder,
      required this.chest,
      required this.waist,
      required this.hip});

  Body copyWith(
      {Timestamp? date,
      List<int>? weight,
      int? shoulder,
      int? chest,
      int? waist,
      int? hip}) {
    return Body(
        date: date ?? this.date,
        weight: weight ?? this.weight,
        waist: waist ?? this.waist,
        shoulder: shoulder ?? this.shoulder,
        chest: chest ?? this.chest,
        hip: hip ?? this.hip);
  }

  static final empty = Body(
      date: Timestamp.now(),
      weight: List.empty(),
      waist: 0,
      shoulder: 0,
      chest: 0,
      hip: 0);

  @override
  int get hashCode =>
      date.hashCode ^
      weight.hashCode ^
      shoulder.hashCode ^
      waist.hashCode ^
      chest.hashCode ^
      hip.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Body &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          weight == other.weight &&
          waist == other.waist &&
          shoulder == other.shoulder &&
          chest == other.chest &&
          hip == other.hip;

  @override
  String toString() {
    return super.toString();
  }

  BodyEntity toEntity() {
    return BodyEntity(date, weight, shoulder, chest, waist, hip);
  }

  static Body fromEmtity(BodyEntity entity) {
    return Body(
        date: entity.date,
        weight: entity.weight,
        waist: entity.waist,
        shoulder: entity.shoulder,
        chest: entity.chest,
        hip: entity.hip);
  }

  @override
  List<Object?> get props => [date, weight, waist, shoulder, chest, hip];
}
