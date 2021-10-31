import 'package:flutter/material.dart';
import 'package:foodandbody/screens/history/tab/history_menu.dart';
import 'package:foodandbody/screens/history/tab/history_nutrient.dart';

class History extends StatelessWidget {
  // const History({Key? key}) : super(key: key);
  History({Key? key}) : super(key: key);

  DateTime startDate = DateTime(2020, 11, 11);
  DateTime stopDate = DateTime(2021, 12, 22);

  List<int> graphData = [
    1500,
    2000,
    1600,
    1800,
    1900,
    1500,
    1800,
    1500,
    2100,
    1600,
    1700,
    1900,
    1500,
    1800
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'ประวัติ',
            style: Theme.of(context).textTheme.headline6!.merge(
                TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.onSecondary,
            labelStyle: Theme.of(context).textTheme.button,
            labelColor: Theme.of(context).colorScheme.onSecondary,
            tabs: [
              Tab(text: 'เมนู'),
              Tab(text: 'สารอาหาร'),
              Tab(text: 'ร่างกาย'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //isEmpty?
            HistoryMenu(startDate: startDate),
            graphData.isEmpty
                ? Center(
                    child: Text(
                    'ไม่มีประวัติสารอาหารในขณะนี้',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ))
                : HistoryNutrient(
                    data: graphData, startDate: startDate, stopDate: stopDate),
            Center(child: Text('BIRDS')),
          ],
        ),
      ),
    );
  }
}
