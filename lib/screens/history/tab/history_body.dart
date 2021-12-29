import 'package:flutter/material.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/screens/history/tab/history_card.dart';

class HistoryBody extends StatelessWidget {
  const HistoryBody(
      {Key? key, required this.data})
      : super(key: key);

  final GraphList? data;

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
                    startDate: data!.bodyEndDate,
                    stopDate: data!.bodyStartDate,
                    isBody: true),
              if (data!.chestList.isNotEmpty)
                HistoryCard(
                    name: 'รอบอก',
                    dataList: data!.chestList,
                    startDate: data!.bodyEndDate,
                    stopDate: data!.bodyStartDate,
                    isBody: true),
              if (data!.waistList.isNotEmpty)
                HistoryCard(
                    name: 'รอบเอว',
                    dataList: data!.waistList,
                    startDate: data!.bodyEndDate,
                    stopDate: data!.bodyStartDate,
                    isBody: true),
              if (data!.hipList.isNotEmpty)
                HistoryCard(
                    name: 'รอบสะโพก',
                    dataList: data!.hipList,
                    startDate: data!.bodyEndDate,
                    stopDate: data!.bodyStartDate,
                    isBody: true),
              if (data!.weightList.isNotEmpty)
                HistoryCard(
                    name: 'น้ำหนัก',
                    dataList: data!.weightList,
                    startDate: data!.weightEndDate,
                    stopDate: data!.weightStartDate,
                    isBody: true),
            ],
          ),
        ),
      ),
    );
  }
}
