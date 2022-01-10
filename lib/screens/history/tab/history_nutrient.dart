import 'package:flutter/material.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/screens/history/tab/history_card.dart';

class HistoryNutrient extends StatelessWidget {
  const HistoryNutrient({Key? key, required this.data}) : super(key: key);

  final GraphList? data;

  bool _isNotZeroList(List<int> list) {
    return list.length >= 10
        ? list.sublist(0, 10).any((x) => x > 0)
        : list.any((x) => x > 0);
  }

  @override
  Widget build(BuildContext context) {
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
                    startDate: data!.foodEndDate,
                    stopDate: data!.foodStartDate,
                    isBody: false),
              if (_isNotZeroList(data!.proteinList))
                HistoryCard(
                    name: 'โปรตีน',
                    dataList: data!.proteinList,
                    startDate: data!.foodEndDate,
                    stopDate: data!.foodStartDate,
                    isBody: false),
              if (_isNotZeroList(data!.carbList))
                HistoryCard(
                    name: 'คาร์โบไฮเดรต',
                    dataList: data!.carbList,
                    startDate: data!.foodEndDate,
                    stopDate: data!.foodStartDate,
                    isBody: false),
              if (_isNotZeroList(data!.fatList))
                HistoryCard(
                    name: 'ไขมัน',
                    dataList: data!.fatList,
                    startDate: data!.foodEndDate,
                    stopDate: data!.foodStartDate,
                    isBody: false),
              if (_isNotZeroList(data!.waterList))
                HistoryCard(
                    name: 'น้ำ',
                    dataList: data!.waterList,
                    startDate: data!.foodEndDate,
                    stopDate: data!.foodStartDate,
                    isBody: false),
              if (_isNotZeroList(data!.burnList))
                HistoryCard(
                    name: 'เผาผลาญพลังงาน',
                    dataList: data!.burnList,
                    startDate: data!.foodEndDate,
                    stopDate: data!.foodStartDate,
                    isBody: false),
            ],
          ),
        ),
      ),
    );
  }
}
