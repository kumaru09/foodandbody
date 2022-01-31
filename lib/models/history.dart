import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/history_entity.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';

class History {
  final Timestamp date;
  final List<Menu> menuList;
  final List<ExerciseRepo> exerciseList;
  final int totalWater;
  final double totalCal;
  final double totalBurn;
  final Nutrient totalNutrientList;

  History(this.date,
      {this.totalCal = 0,
      this.totalBurn = 0,
      this.totalNutrientList = const Nutrient(),
      this.totalWater = 0,
      List<Menu>? menuList,
      List<ExerciseRepo>? exerciseList})
      : this.menuList = menuList ?? [],
        this.exerciseList = exerciseList ?? [];

  History copyWith(
      {Timestamp? date,
      List<Menu>? menuList,
      List<ExerciseRepo>? exerciseList,
      double? totalCal,
      double? totalBurn,
      int? totalWater,
      Nutrient? totalNutrientList,
      Nutrient? planNutrientList}) {
    return History(date ?? this.date,
        menuList: menuList ?? this.menuList,
        exerciseList: exerciseList ?? this.exerciseList,
        totalCal: totalCal ?? this.totalCal,
        totalBurn: totalBurn ?? this.totalBurn,
        totalNutrientList: totalNutrientList ?? this.totalNutrientList,
        totalWater: totalWater ?? this.totalWater);
  }

  @override
  int get hashCode =>
      date.hashCode ^
      menuList.hashCode ^
      exerciseList.hashCode ^
      totalCal.hashCode ^
      totalBurn.hashCode ^
      totalNutrientList.hashCode ^
      totalWater.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is History &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          menuList == other.menuList &&
          exerciseList == other.exerciseList &&
          totalCal == other.totalCal &&
          totalBurn == other.totalBurn &&
          totalNutrientList == other.totalNutrientList &&
          totalWater == other.totalWater;

  @override
  String toString() {
    return 'History {data: $date, totalCal: $totalCal, totalWater: $totalWater, totalNutrient: $totalNutrientList, menuList: $menuList, exerciseList: $exerciseList}';
  }

  HistoryEntity toEntity() {
    return HistoryEntity(date, menuList, exerciseList, totalCal, totalBurn,
        totalWater, totalNutrientList);
  }

  static History fromEntity(HistoryEntity entity) {
    return History(entity.date,
        menuList: entity.menuList,
        exerciseList: entity.exerciseList,
        totalCal: entity.totalCal,
        totalBurn: entity.totalBurn,
        totalNutrientList: entity.totalNutrientList,
        totalWater: entity.totalWater);
  }
}
