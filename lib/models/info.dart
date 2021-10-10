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

  Info(
      {this.name,
      this.goal,
      this.height,
      this.weight,
      this.gender,
      this.photoUrl,
      this.goalNutrient});

  Info copyWith(
      {String? name,
      int? goal,
      int? height,
      int? weight,
      String? gender,
      String? photoUrl,
      Nutrient? goalNutrient}) {
    return Info(
        name: name ?? this.name,
        goal: goal ?? this.goal,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        gender: gender ?? this.gender,
        photoUrl: photoUrl ?? this.photoUrl,
        goalNutrient: goalNutrient ?? this.goalNutrient);
  }

  @override
  int get hashCode =>
      name.hashCode ^
      goal.hashCode ^
      height.hashCode ^
      weight.hashCode ^
      gender.hashCode ^
      photoUrl.hashCode ^
      goalNutrient.hashCode;

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
          goalNutrient == other.goalNutrient;

  @override
  String toString() {
    return 'Todo { name: $name, goal: $goal, height: $height, weight: $weight, gender: $gender, photoUrl: $photoUrl, goalNutrient: $goalNutrient}';
  }

  InfoEntity toEntity() {
    return InfoEntity(
        name: name,
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
        goal: entity.goal,
        height: entity.height,
        weight: entity.weight,
        gender: entity.gender,
        photoUrl: entity.photoUrl,
        goalNutrient: entity.goalNutrient);
  }
}
