import 'package:flutter/material.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/screens/history/tab/history_card.dart';

class HistoryBody extends StatelessWidget {
  const HistoryBody(
      {Key? key,
      required this.data,
      required this.startDate,
      required this.stopDate,
      required this.weightStartDate,
      required this.weightEndDate})
      : super(key: key);

  final GraphList? data;
  final DateTime startDate;
  final DateTime stopDate;
  final DateTime weightStartDate;
  final DateTime weightEndDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              if (data!.shoulderList.isNotEmpty)
                HistoryCard(
                    name: 'ไหล่',
                    dataList: data!.shoulderList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: true),
              if (data!.chestList.isNotEmpty)
                HistoryCard(
                    name: 'รอบอก',
                    dataList: data!.chestList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: true),
              if (data!.waistList.isNotEmpty)
                HistoryCard(
                    name: 'รอบเอว',
                    dataList: data!.waistList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: true),
              if (data!.hipList.isNotEmpty)
                HistoryCard(
                    name: 'รอบสะโพก',
                    dataList: data!.hipList,
                    startDate: startDate,
                    stopDate: stopDate,
                    isBody: true),
              if (data!.weightList.isNotEmpty)
                HistoryCard(
                    name: 'น้ำหนัก',
                    dataList: data!.weightList,
                    startDate: weightEndDate,
                    stopDate: weightStartDate,
                    isBody: true),
            ],
          ),
        ),
      ),
    );
  }
}
