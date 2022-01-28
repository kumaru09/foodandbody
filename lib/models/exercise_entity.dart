import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final int min;
  final int calory;
  final Timestamp timestamp;

  const ExerciseEntity(this.id, this.min, this.calory, this.timestamp);

  Map<String, Object> toJson() {
    return {'id': id, 'min': min, 'calory': calory};
  }

  static ExerciseEntity fromSnapshot(DocumentSnapshot snap) {
    return ExerciseEntity(
        snap['id'], snap['min'], snap['calory'], snap['timestamp']);
  }

  @override
  String toString() {
    return 'ExerciseEntity {id: $id, min: $min, calory: $calory, timestamp: $timestamp}';
  }

  @override
  List<Object?> get props => [id, min, calory, timestamp];
}
