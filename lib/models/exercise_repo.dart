import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ExerciseRepo extends Equatable {
  final String id;
  final String name;
  final int min;
  final double calory;
  final Timestamp timestamp;

  const ExerciseRepo(
      {required this.id,
      required this.name,
      required this.min,
      required this.calory,
      required this.timestamp});

  ExerciseRepo copyWith(String? id, String? name, int? min, double? calory,
      Timestamp? timestamp) {
    return ExerciseRepo(
        id: id ?? this.id,
        name: name ?? this.name,
        min: min ?? this.min,
        calory: calory ?? this.calory,
        timestamp: timestamp ?? this.timestamp);
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'min': min,
      'calory': calory,
      'timestamp': timestamp,
    };
  }

  static ExerciseRepo fromJson(Map<String, Object?> json) {
    return ExerciseRepo(
        id: json['id'] as String,
        name: json['name'] as String,
        min: json['min'] as int,
        calory: json['calory'] as double,
        timestamp: json['timestamp'] as Timestamp);
  }

  // static ExerciseRepo fromSnapshot(DocumentSnapshot snap) {
  //   return ExerciseRepo(
  //       id: snap['id'],
  //       name: snap['name'],
  //       min: snap['min'],
  //       calory: snap['calory'],
  //       timestamp: snap['timestamp']);
  // }

  @override
  String toString() {
    return 'ExerciseRepo {id: $id, min: $min, calory: $calory}';
  }

  @override
  List<Object?> get props => [id, name, min, calory, timestamp];
}
