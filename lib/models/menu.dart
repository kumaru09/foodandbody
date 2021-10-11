import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  final String name;
  final double calories;
  Timestamp? timestamp;

  Menu({this.timestamp, required this.name, required this.calories});

  static Menu fromJson(Map<String, Object?> json) {
    return Menu(
        name: json['name'] as String,
        calories: json['calories'] as double,
        timestamp:
            json['timestamp'] == null ? null : json['timestamp'] as Timestamp);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "calories": calories, "timestamp": timestamp};
  }
}
