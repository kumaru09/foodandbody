import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodandbody/models/body_entity.dart';

class Body {
  final Timestamp date;
  final int weight;
  final int shoulder;
  final int chest;
  final int waist;
  final int hip;

  Body(this.date,
      {this.weight = 0,
      this.shoulder = 0,
      this.chest = 0,
      this.waist = 0,
      this.hip = 0});

  Body copyWith(
      {Timestamp? date,
      int? weight,
      int? shoulder,
      int? chest,
      int? waist,
      int? hip}) {
    return Body(date ?? this.date,
        weight: weight ?? this.weight,
        waist: waist ?? this.waist,
        shoulder: shoulder ?? this.shoulder,
        chest: chest ?? this.chest,
        hip: hip ?? this.hip);
  }

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
    return Body(entity.date,
        weight: entity.weight,
        waist: entity.waist,
        shoulder: entity.shoulder,
        chest: entity.chest,
        hip: entity.hip);
  }
}
