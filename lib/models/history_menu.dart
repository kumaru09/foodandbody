import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryMenuItem {
  const HistoryMenuItem({
    required this.name,
    required this.date,
    required this.calory,
  });
  final String name;
  final Timestamp? date;
  final int calory;
}
