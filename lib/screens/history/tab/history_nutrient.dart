import 'package:flutter/material.dart';
import 'package:foodandbody/screens/history/tab/nutrient_card.dart';

class HistoryNutrient extends StatelessWidget {
  const HistoryNutrient({Key? key, required this.data, required this.startDate, required this.stopDate}) : super(key: key);

  final List<int> data;
  final DateTime startDate;
  final DateTime stopDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              NutrientCard(name: 'แคลอรี',dataList: data, startDate: startDate, stopDate: stopDate),
              NutrientCard(name: 'โปรตีน',dataList: data, startDate: startDate, stopDate: stopDate),
              NutrientCard(name: 'คาร์โบไฮเดรต',dataList: data, startDate: startDate, stopDate: stopDate),
              NutrientCard(name: 'ไขมัน',dataList: data, startDate: startDate, stopDate: stopDate),
              NutrientCard(name: 'น้ำ',dataList: data, startDate: startDate, stopDate: stopDate),
            ],
          ),
        ),
      ),
    );
  }
}