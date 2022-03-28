import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HistoryMenuItem extends Equatable {
  const HistoryMenuItem({
    required this.name,
    required this.date,
    required this.calory,
  });
  final String name;
  final Timestamp? date;
  final int calory;

  @override
   String toString() {
    return 'MenuShow { name: $name,\n date: $date,\n calory: $calory,}';
  }

  @override
  List<Object?> get props => [name, date, calory,];
}
