import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WeightList extends Equatable {
  final int weight;
  Timestamp? date;

  WeightList({required this.weight, required this.date});

  static WeightList fromJson(Map<String, Object> json) {
    return WeightList(
        weight: json['weight'] as int, date: json['date'] as Timestamp);
  }

  static WeightList fromSanpShot(DocumentSnapshot snap) {
    return WeightList(weight: snap['weight'], date: snap['date']);
  }

  Map<String, Object?> toJson() {
    return {"date": date, "weight": weight};
  }

  @override
  List<Object?> get props => [weight, date];
}
