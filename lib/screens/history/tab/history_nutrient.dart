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

  bool _isNotZeroList(List<int> list){
    return list.length >= 10 
    ? list.sublist(0, 10).any((x) => x > 0)
    : list.any((x) => x > 0) ; 
  }

  @override
  Widget build(BuildContext context) {
    final List<int> exerciseList = [250, 300, 150, 400, 350, 500, 200, 540, 340, 600];
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              if (_isNotZeroList(data!.caloriesList))
                HistoryCard(
                    name: 'แคลอรี',
                    dataList: data!.caloriesList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (_isNotZeroList(data!.proteinList))
                HistoryCard(
                    name: 'โปรตีน',
                    dataList: data!.proteinList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (_isNotZeroList(data!.carbList))
                HistoryCard(
                    name: 'คาร์โบไฮเดรต',
                    dataList: data!.carbList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (_isNotZeroList(data!.fatList))
                HistoryCard(
                    name: 'ไขมัน',
                    dataList: data!.fatList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (_isNotZeroList(data!.waterList))
                HistoryCard(
                    name: 'น้ำ',
                    dataList: data!.waterList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: false),
              if (_isNotZeroList(exerciseList))
                HistoryCard(
                    name: 'เผาผลาญพลังงาน',
                    dataList: exerciseList,
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
