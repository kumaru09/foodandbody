import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/weight_list.dart';

class GraphList extends Equatable {
  GraphList(
      {required this.caloriesList,
      required this.proteinList,
      required this.fatList,
      required this.carbList,
      required this.waterList,
      required this.waistList,
      required this.shoulderList,
      required this.chestList,
      required this.weightList,
      required this.hipList,
      required this.foodStartDate,
      required this.foodEndDate,
      required this.bodyStartDate,
      required this.bodyEndDate,
      required this.weightStartDate,
      required this.weightEndDate});
  final List<int> caloriesList;
  final List<int> proteinList;
  final List<int> fatList;
  final List<int> carbList;
  final List<int> waterList;
  final List<int> shoulderList;
  final List<int> chestList;
  final List<int> waistList;
  final List<int> hipList;
  final List<int> weightList;
  final DateTime foodStartDate;
  final DateTime foodEndDate;
  final DateTime bodyStartDate;
  final DateTime bodyEndDate;
  final DateTime weightStartDate;
  final DateTime weightEndDate;

  GraphList copyWith(
      {List<int>? caloriesList,
      List<int>? proteinList,
      List<int>? fatList,
      List<int>? carbList,
      List<int>? waterList,
      List<int>? shoulderList,
      List<int>? chestList,
      List<int>? waistList,
      List<int>? hipList,
      List<int>? weightList,
      DateTime? foodStartDate,
      DateTime? foodEndDate,
      DateTime? bodyStartDate,
      DateTime? bodyEndDate,
      DateTime? weightStartDate,
      DateTime? weightEndDate}) {
    return GraphList(
        caloriesList: caloriesList ?? this.caloriesList,
        proteinList: proteinList ?? this.proteinList,
        fatList: fatList ?? this.fatList,
        carbList: carbList ?? this.carbList,
        waterList: waterList ?? this.waterList,
        shoulderList: shoulderList ?? this.shoulderList,
        chestList: chestList ?? this.chestList,
        waistList: waistList ?? this.waistList,
        hipList: hipList ?? this.hipList,
        weightList: weightList ?? this.weightList,
        foodStartDate: foodStartDate ?? this.foodStartDate,
        foodEndDate: foodEndDate ?? this.foodEndDate,
        bodyStartDate: bodyStartDate ?? this.bodyStartDate,
        bodyEndDate: bodyEndDate ?? this.bodyEndDate,
        weightStartDate: weightStartDate ?? this.weightStartDate,
        weightEndDate: weightEndDate ?? this.weightEndDate);
  }

  @override
  String toString() {
    return "GraphList { $caloriesList, $proteinList, $fatList, $carbList, $waterList, $shoulderList, $chestList, $waistList, $hipList, $weightList, $foodStartDate - $foodEndDate, $bodyStartDate - $bodyEndDate, $weightStartDate - $weightEndDate }";
  }

  @override
  List<Object?> get props => [
        caloriesList,
        proteinList,
        fatList,
        carbList,
        waterList,
        shoulderList,
        chestList,
        waistList,
        hipList,
        weightList,
        foodStartDate,
        foodEndDate,
        bodyStartDate,
        bodyEndDate,
        weightStartDate,
        weightEndDate
      ];
}
