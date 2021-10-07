import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodandbody/models/history_entity.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';

class History {
  final Timestamp date;
  final List<Menu> menuList;
  final int totalWater;
  final double totalCal;
  final Nutrient totalNutrientList;
  final Nutrient planNutrientList;

  History(this.date,
      {this.totalCal = 0,
      this.totalNutrientList = const Nutrient(),
      this.planNutrientList = const Nutrient(),
      this.totalWater = 0,
      List<Menu>? menuList})
      : this.menuList = menuList ?? [];

  History copyWith(
      {Timestamp? date,
      List<Menu>? menuList,
      double? totalCal,
      int? totalWater,
      Nutrient? totalNutrientList,
      Nutrient? planNutrientList}) {
    return History(date ?? this.date,
        menuList: menuList ?? this.menuList,
        totalCal: totalCal ?? this.totalCal,
        totalNutrientList: totalNutrientList ?? this.totalNutrientList,
        totalWater: totalWater ?? this.totalWater,
        planNutrientList: planNutrientList ?? this.planNutrientList);
  }

  @override
  int get hashCode =>
      date.hashCode ^
      menuList.hashCode ^
      totalCal.hashCode ^
      totalNutrientList.hashCode ^
      totalWater.hashCode ^
      planNutrientList.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is History &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          totalCal == other.totalCal &&
          totalNutrientList == other.totalNutrientList &&
          totalWater == other.totalWater &&
          planNutrientList == other.planNutrientList;

  @override
  String toString() {
    return 'History {data: $date, totalCal: $totalCal, totalWater: $totalWater, totalNutrient: $totalNutrientList, menuList: $menuList, planNutrient: ${planNutrientList.toString()}}';
  }

  HistoryEntity toEntity() {
    return HistoryEntity(date, menuList, totalCal, totalWater,
        totalNutrientList, planNutrientList);
  }

  static History fromEntity(HistoryEntity entity) {
    return History(entity.date,
        menuList: entity.menuList,
        totalCal: entity.totalCal,
        totalNutrientList: entity.totalNutrientList,
        totalWater: entity.totalWater,
        planNutrientList: entity.planNutrientList);
  }
}
