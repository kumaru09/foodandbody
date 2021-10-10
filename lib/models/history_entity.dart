import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/nutrient.dart';

class HistoryEntity extends Equatable {
  final Timestamp date;
  final List<Menu> menuList;
  final int totalWater;
  final double totalCal;
  final Nutrient totalNutrientList;
  final Nutrient planNutrientList;

  const HistoryEntity(this.date, this.menuList, this.totalCal, this.totalWater,
      this.totalNutrientList, this.planNutrientList);

  HistoryEntity fromJson(Map<dynamic, dynamic> json) {
    return HistoryEntity(
        json['date'] as Timestamp,
        List.from(json['menuList']),
        json['totalCal'] as double,
        json['totalWater'] as int,
        Nutrient.fromJson(json['totalNutrient']),
        Nutrient.fromJson(json['planNutrient']));
  }

  Map<String, Object?> toJson() {
    return {
      'date': date,
      'menuList': menuList,
      'totalCal': totalCal,
      'totalWater': totalWater,
      'totalNutrient': totalNutrientList.toJson(),
      'planNutrient': planNutrientList.toJson()
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
    return 'HistoryEntity {data: $date, totalCal: $totalCal, totalWater: $totalWater, totalNutrient: $totalNutrientList, menuList: $menuList, planNutrient: ${planNutrientList.toString()}}';
  }

  @override
  List<Object?> get props => [
        date,
        menuList,
        totalCal,
        totalWater,
        totalNutrientList,
        planNutrientList
      ];

  static HistoryEntity fromSnapshot(DocumentSnapshot snap) {
    return HistoryEntity(
        snap['date'],
        List.from(snap['menuList']),
        snap['totalCal'],
        snap['totalWater'],
        Nutrient.fromJson(snap['totalNutrient']),
        Nutrient.fromJson(snap['planNutrient']));
  }
}
