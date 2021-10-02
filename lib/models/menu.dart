import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  final String name;
  final double calories;
  final Timestamp timestamp;

  const Menu(
      {required this.timestamp, required this.name, required this.calories});

  static Menu fromJson(Map<String, Object?> json) {
    return Menu(
        name: json['Name'] as String,
        calories: json['Calories'] as double,
        timestamp: json['timestamp'] as Timestamp);
  }

  Map<dynamic, dynamic> toJson() {
    return {"name": name, "calories": calories, "timestamp": timestamp};
  }

  @override
  List<Object?> get props => [name, calories, timestamp];
}
