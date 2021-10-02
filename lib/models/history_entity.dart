import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu.dart';

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
      Nutrient.fromJson(json['totalNutrient']),
    );
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
  List<Object?> get props =>
      [date, menuList, totalCal, totalWater, totalNutrientList];

  static HistoryEntity fromSnapshot(DocumentSnapshot snap) {
    return HistoryEntity(
        snap['date'],
        List.from(snap['menuList']),
        snap['totalCal'],
        snap['totalWater'],
        Nutrient.fromJson(snap['totalNutrient']));
  }
}

class Nutrient {
  final double protein;
  final double fat;
  final double carb;

  const Nutrient({this.protein = 0, this.carb = 0, this.fat = 0});

  static Nutrient fromJson(Map<dynamic, dynamic> json) {
    return Nutrient(
        protein: json['protein'] as double,
        fat: json['fat'] as double,
        carb: json['carb'] as double);
  }

  Nutrient copyWith({double? protein, double? fat, double? carb}) {
    return Nutrient(
        protein: protein ?? this.protein,
        fat: fat ?? this.fat,
        carb: carb ?? this.carb);
  }

  Map<String, Object?> toJson() {
    return {'protein': protein, 'fat': fat, 'carb': carb};
  }
}
