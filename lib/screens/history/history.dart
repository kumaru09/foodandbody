import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/history_repository.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';
import 'package:foodandbody/screens/history/tab/history_body.dart';
import 'package:foodandbody/screens/history/tab/history_menu.dart';
import 'package:foodandbody/screens/history/tab/history_nutrient.dart';

class History extends StatelessWidget {
  // const History({Key? key}) : super(key: key);
  History({Key? key}) : super(key: key);

  late DateTime startDate = stopDate.subtract(new Duration(days: 10));
  final DateTime stopDate = DateTime.now();

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
          body:
              BlocBuilder<HistoryBloc, HistoryState>(builder: (context, state) {
            if (state.status == HistoryStatus.success &&
                state.graphList != null) {
              return TabBarView(
                children: [
                  HistoryMenu(
                      startDate: startDate,
                      items: state.menuList,
                      dateMenuList: state.dateMenuList),
                  // Center(
                  //     child: Text(
                  //     'ไม่มีประวัติสารอาหารในขณะนี้',
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .subtitle1!
                  //         .merge(TextStyle(
                  //             color: Theme.of(context)
                  //                 .colorScheme
                  //                 .secondary)),
                  //   ))
                  HistoryNutrient(
                      data: state.graphList,
                      startDate: state.graphList!.foodEndDate,
                      stopDate: state.graphList!.foodStartDate),
                  // Center(
                  //   child: Text(
                  //   'ไม่มีประวัติร่างกายในขณะนี้',
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .subtitle1!
                  //       .merge(TextStyle(
                  //           color: Theme.of(context)
                  //               .colorScheme
                  //               .secondary)),
                  // ))
                  HistoryBody(
                    data: state.graphList,
                    startDate: state.graphList!.bodyEndDate,
                    stopDate: state.graphList!.bodyStartDate,
                    weightEndDate: state.graphList!.weightEndDate,
                    weightStartDate: state.graphList!.weightStartDate,
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          })),
    );
  }
}
