import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/menu_show.dart';

class Predict extends Equatable {
  final String name;
  final double calory;
  final double protein;
  final double carb;
  final double fat;

  Predict(
      {required this.name,
      required this.calory,
      required this.carb,
      required this.fat,
      required this.protein});

  static Predict fromJson(Map<String, Object?> json) {
    return Predict(
      name: json['name'] as String,
      calory: double.parse(json['calory'] as String),
      protein: double.parse(json['protein'] as String),
      carb: double.parse(json['carb'] as String),
      fat: double.parse(json['fat'] as String),
    );
  }

  Predict copyWith(
      {String? name,
      double? calory,
      double? protein,
      double? carb,
      double? fat}) {
    return Predict(
        name: name ?? this.name,
        calory: calory ?? this.calory,
        protein: protein ?? this.protein,
        carb: carb ?? this.carb,
        fat: fat ?? this.fat);
  }

  Map<String, Object> toJson() {
    return {
      "name": name,
      "calory": calory,
      "protein": protein,
      "carb": carb,
      "fat": fat
    };
  }

  @override
  List<Object?> get props => [name, calory, protein, carb, fat];
}

class PredictResult extends Equatable {
  final Predict predict;
  final MenuShow menuShow;

  PredictResult({required this.predict, required this.menuShow});

  @override
  List<Object?> get props => [predict, menuShow];
}
