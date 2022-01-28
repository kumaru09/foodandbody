import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';

class HistoryEntity extends Equatable {
  final Timestamp date;
  final List<Menu> menuList;
  final List<ExerciseRepo> exerciseList;
  final int totalWater;
  final double totalCal;
  final double totalBurn;
  final Nutrient totalNutrientList;

  const HistoryEntity(this.date, this.menuList, this.exerciseList,
      this.totalCal, this.totalBurn, this.totalWater, this.totalNutrientList);

  HistoryEntity fromJson(Map<dynamic, dynamic> json) {
    return HistoryEntity(
        json['date'] as Timestamp,
        List.from(json['menuList']),
        List.from(json['exerciseList']),
        json['totalCal'] as double,
        json['totalBurn'] as double,
        json['totalWater'] as int,
        Nutrient.fromJson(json['totalNutrient']));
  }

  Map<String, Object?> toJson() {
    return {
      'date': date,
      'menuList': menuList,
      'exerciseList': exerciseList,
      'totalCal': totalCal,
      'totalBurn': totalBurn,
      'totalWater': totalWater,
      'totalNutrient': totalNutrientList.toJson(),
    };
  }

  // static const empty = HistoryEntity(
  //   date: null,
  //   totalCal: null,
  //   totalNutrientList: null,
  //   totalWater: null,
  //   menuList: null,
  // );

  @override
  String toString() {
    return 'HistoryEntity {data: $date, totalCal: $totalCal, totalBurn: $totalBurn, totalWater: $totalWater, totalNutrient: $totalNutrientList, menuList: $menuList, exerciseList: $exerciseList}';
  }

  @override
  List<Object?> get props => [
        date,
        menuList,
        exerciseList,
        totalCal,
        totalBurn,
        totalWater,
        totalNutrientList,
      ];

  static HistoryEntity fromSnapshot(DocumentSnapshot snap) {
    return HistoryEntity(
        snap['date'],
        snap['menuList'].map<Menu>((menu) => Menu.fromJson(menu)).toList(),
        snap['exerciseList']
            .map<ExerciseRepo>((exercise) => ExerciseRepo.fromJson(exercise))
            .toList(),
        snap['totalCal'],
        snap['totalBurn'],
        snap['totalWater'],
        Nutrient.fromJson(snap['totalNutrient']));
  }
}
