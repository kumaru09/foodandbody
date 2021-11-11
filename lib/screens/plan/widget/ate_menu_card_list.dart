import 'package:flutter/material.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AteMenuCardList extends StatelessWidget {
  AteMenuCardList(this._plan);
  final History _plan;
  late List<Menu> ateMenu =
      _plan.menuList.where((value) => value.timestamp != null).toList();

  @override
  Widget build(BuildContext context) {
    List<Widget> ateMenuCardList = [];
    for (int index = 0; index < ateMenu.length; index++) {
      ateMenuCardList.add(_buildAteMenuCard(context, ateMenu[index]));
    }
    return Column(
        key: const Key("ate_menu_card_list"), children: ateMenuCardList);
  }

  Widget _buildAteMenuCard(BuildContext context, Menu item) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 6,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Text("${item.name}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .merge(TextStyle(color: Color(0xFF515070))))),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16, bottom: 16),
                      child: Text(
                          "${DateFormat.Hm().format(item.timestamp!.toDate())}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .merge(TextStyle(color: Color(0xFFA19FB9)))))
                ],
              )),
          Container(
              margin: EdgeInsets.only(right: 15),
              child: Text("${item.calories.round()}",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .merge(TextStyle(color: Color(0xFF515070))))),
          Container(
              padding: EdgeInsets.only(right: 16),
              child: Text("แคล",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .merge(TextStyle(color: Color(0xFF515070)))))
        ],
      ),
    );
  }
}
