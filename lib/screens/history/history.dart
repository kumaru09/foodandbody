import 'package:flutter/material.dart';
import 'package:foodandbody/screens/history/tab/history_menu.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

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
            HistoryMenu(),
            Center(child: Text('CATS')),
            Center(child: Text('BIRDS')),
          ],
        ),
      ),
    );
  }
}
