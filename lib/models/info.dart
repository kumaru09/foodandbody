import 'package:foodandbody/models/info_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Info {
  final String? name;
  final int? goal;
  final int? height;
  final int? weight;
  final String? gender;

  Info({this.name, this.goal, this.height, this.weight, this.gender});

  Info copyWith(
      {String? name, int? goal, int? height, int? weight, String? gender}) {
    return Info(
      name: name ?? this.name,
      goal: goal ?? this.goal,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      goal.hashCode ^
      height.hashCode ^
      weight.hashCode ^
      gender.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Info &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          goal == other.goal &&
          height == other.height &&
          weight == other.weight &&
          gender == other.gender;

  @override
  String toString() {
    return 'Todo { name: $name, goal: $goal, height: $height, weight: $weight, gender: $gender}';
  }

  InfoEntity toEntity() {
    return InfoEntity(
        name: name, goal: goal, height: height, weight: weight, gender: gender);
  }

  static Info fromEntity(InfoEntity entity) {
    return Info(
      name: entity.name,
      goal: entity.goal,
      height: entity.height,
      weight: entity.weight,
      gender: entity.gender,
    );
  }
}
