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

  const HistoryEntity(this.date, this.menuList, this.totalCal, this.totalWater,
      this.totalNutrientList);

  HistoryEntity fromJson(Map<dynamic, dynamic> json) {
    return HistoryEntity(
        json['date'] as Timestamp,
        List.from(json['menuList']),
        json['totalCal'] as double,
        json['totalWater'] as int,
        Nutrient.fromJson(json['totalNutrient']));
  }

  Map<String, Object?> toJson() {
    return {
      'date': date,
      'menuList': menuList,
      'totalCal': totalCal,
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
    return 'HistoryEntity {data: $date, totalCal: $totalCal, totalWater: $totalWater, totalNutrient: $totalNutrientList, menuList: $menuList}';
  }

  @override
  List<Object?> get props => [
        date,
        menuList,
        totalCal,
        totalWater,
        totalNutrientList,
      ];

  static HistoryEntity fromSnapshot(DocumentSnapshot snap) {
    return HistoryEntity(
        snap['date'],
        snap['menuList'].map<Menu>((menu) => Menu.fromJson(menu)).toList(),
        snap['totalCal'],
        snap['totalWater'],
        Nutrient.fromJson(snap['totalNutrient']));
  }
}
