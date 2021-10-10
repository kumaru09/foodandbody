import 'package:equatable/equatable.dart';

class MenuDetail extends Equatable {
  final String name;
  final double calories;
  final String imageUrl;
  final double protein;
  final double fat;
  final double carb;
  final int serve;
  final String unit;

  const MenuDetail(
      {required this.protein,
      required this.fat,
      required this.carb,
      required this.serve,
      required this.unit,
      required this.name,
      required this.calories,
      required this.imageUrl});

  static MenuDetail fromJson(Map<String, Object?> json) {
    return MenuDetail(
        name: json['Name'] as String,
        calories: json['Calories'] as double,
        imageUrl: json['imageUrl'] as String,
        protein: json['protein'] as double,
        fat: json['fat'] as double,
        carb: json['carb'] as double,
        serve: json['serve'] as int,
        unit: json['unit'] as String);
  }

  @override
  List<Object?> get props =>
      [name, calories, imageUrl, protein, fat, carb, serve, unit];
}
