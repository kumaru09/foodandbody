import 'package:flutter/material.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/screens/history/tab/history_card.dart';

class HistoryNutrient extends StatelessWidget {
  const HistoryNutrient(
      {Key? key,
      required this.data,
      required this.startDate,
      required this.stopDate})
      : super(key: key);

  final GraphList? data;
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
              if (data!.caloriesList.isNotEmpty)
                HistoryCard(
                    name: 'แคลอรี',
                    dataList: data!.caloriesList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (data!.proteinList.isNotEmpty)
                HistoryCard(
                    name: 'โปรตีน',
                    dataList: data!.proteinList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (data!.carbList.isNotEmpty)
                HistoryCard(
                    name: 'คาร์โบไฮเดรต',
                    dataList: data!.carbList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (data!.fatList.isNotEmpty)
                HistoryCard(
                    name: 'ไขมัน',
                    dataList: data!.fatList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (data!.waterList.isNotEmpty)
                HistoryCard(
                    name: 'น้ำ',
                    dataList: data!.waterList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
            ],
          ),
        ),
      ),
    );
  }
}
