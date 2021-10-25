import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String name;
  final double calories;
  Timestamp? timestamp;
  final double serve;
  final double protein;
  final double carb;
  final double fat;
  final double volumn;

  Menu(
      {this.timestamp,
      required this.name,
      required this.calories,
      required this.protein,
      required this.carb,
      required this.fat,
      required this.serve,
      required this.volumn});

  static Menu fromJson(Map<String, Object?> json) {
    return Menu(
        name: json['name'] as String,
        calories: json['calories'] as double,
        // calories: double.parse(json['calories'].toString()),
        timestamp:
            json['timestamp'] == null ? null : json['timestamp'] as Timestamp,
        serve: json['serve'] as double,
        protein: json['protein'] as double,
        carb: json['carb'] as double,
        fat: json['fat'] as double,
        volumn: json['volumn'] as double);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "calories": calories,
      "timestamp": timestamp,
      "serve": serve,
      "protein": protein,
      "carb": carb,
      "fat": fat,
      "volumn": volumn
    };
  }
}
