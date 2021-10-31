import 'package:flutter/material.dart';
import 'package:foodandbody/screens/history/tab/history_card.dart';

class HistoryBody extends StatelessWidget {
  const HistoryBody({Key? key, required this.data, required this.startDate, required this.stopDate}) : super(key: key);

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
              HistoryCard(name: 'ไหล่',dataList: data, startDate: startDate, stopDate: stopDate, isBody: true),
              HistoryCard(name: 'รอบอก',dataList: data, startDate: startDate, stopDate: stopDate, isBody: true),
              HistoryCard(name: 'รอบเอว',dataList: data, startDate: startDate, stopDate: stopDate, isBody: true),
              HistoryCard(name: 'รอบสะโพก',dataList: data, startDate: startDate, stopDate: stopDate, isBody: true),
              HistoryCard(name: 'น้ำหนัก',dataList: data, startDate: startDate, stopDate: stopDate, isBody: true),
            ],
          ),
        ),
      ),
    );
  }
}