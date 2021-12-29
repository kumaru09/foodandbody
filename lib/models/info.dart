import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodandbody/models/info_entity.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:meta/meta.dart';

@immutable
class Info {
  final String? name;
  final int? goal;
  final int? height;
  final int? weight;
  final String? gender;
  final String? photoUrl;
  final Nutrient? goalNutrient;
  final Timestamp? birthDate;

  Info(
      {this.name,
      this.goal,
      this.height,
      this.weight,
      this.gender,
      this.photoUrl,
      this.goalNutrient,
      this.birthDate});

  Info copyWith(
      {String? name,
      int? goal,
      int? height,
      int? weight,
      String? gender,
      String? photoUrl,
      Nutrient? goalNutrient,
      Timestamp? birthDate}) {
    return Info(
        name: name ?? this.name,
        goal: goal ?? this.goal,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        gender: gender ?? this.gender,
        photoUrl: photoUrl ?? this.photoUrl,
        goalNutrient: goalNutrient ?? this.goalNutrient,
        birthDate: birthDate ?? this.birthDate);
  }

  @override
  int get hashCode =>
      name.hashCode ^
      goal.hashCode ^
      height.hashCode ^
      weight.hashCode ^
      gender.hashCode ^
      photoUrl.hashCode ^
      goalNutrient.hashCode ^
      birthDate.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Info &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          goal == other.goal &&
          height == other.height &&
          weight == other.weight &&
          gender == other.gender &&
          photoUrl == other.photoUrl &&
          goalNutrient == other.goalNutrient &&
          birthDate == other.birthDate;

  @override
  String toString() {
    return 'Info { name: $name, birthDate: $birthDate, goal: $goal, height: $height, weight: $weight, gender: $gender, photoUrl: $photoUrl, goalNutrient: $goalNutrient}';
  }

  InfoEntity toEntity() {
    return InfoEntity(
        name: name,
        birthDate: birthDate,
        goal: goal,
        height: height,
        weight: weight,
        gender: gender,
        photoUrl: photoUrl,
        goalNutrient: goalNutrient);
  }

  static Info fromEntity(InfoEntity entity) {
    return Info(
        name: entity.name,
        birthDate: entity.birthDate,
        goal: entity.goal,
        height: entity.height,
        weight: entity.weight,
        gender: entity.gender,
        photoUrl: entity.photoUrl,
        goalNutrient: entity.goalNutrient);
  }
}
