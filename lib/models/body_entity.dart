import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BodyEntity extends Equatable {
  final Timestamp date;
  final int shoulder;
  final int chest;
  final int waist;
  final int hip;

  const BodyEntity(this.date, this.shoulder, this.chest, this.waist, this.hip);

  Map<String, Object?> toJson() {
    return {
      'date': date,
      'shoulder': shoulder,
      'chest': chest,
      'waist': waist,
      'hip': hip
    };
  }

  @override
  String toString() {
    return 'BodyEntity {date: $date, shoulder: $shoulder, chest: $chest, waist: $waist, hip: $hip}';
  }

  @override
  List<Object?> get props => [date, shoulder, chest, waist, hip];

  static BodyEntity fromSnapshot(DocumentSnapshot snap) {
    return BodyEntity(
      snap['date'],
      snap['shoulder'],
      snap['chest'],
      snap['waist'],
      snap['hip'],
    );
  }
}
