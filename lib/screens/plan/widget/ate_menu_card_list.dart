import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AteMenuCardList extends StatelessWidget {
  late List ateMenu = [
    AteMenuList(menu: "โอวัลติน", cal: 177.2, time: "7:00"),
    AteMenuList(menu: "ส้มตำไทย", cal: 240.3, time: "12:00"),
    AteMenuList(menu: "ข้าวมันไก่", cal: 765.0, time: "17:35"),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> ateMenuCardList = [];
    for (int index = 0; index < ateMenu.length; index++) {
      ateMenuCardList.add(_buildAteMenuCard(context, ateMenu[index]));
    }
    return Column(
        key: const Key("ate_menu_card_list"), children: ateMenuCardList);
  }

  Widget _buildAteMenuCard(BuildContext context, AteMenuList item) {
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
                      child: Text("${item.menu}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .merge(TextStyle(color: Color(0xFF515070))))),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16, bottom: 16),
                      child: Text("${item.time}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .merge(TextStyle(color: Color(0xFFA19FB9)))))
                ],
              )),
          Container(
              margin: EdgeInsets.only(right: 15),
              child: Text("${item.cal.round()}",
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

class AteMenuList {
  AteMenuList({required this.menu, required this.cal, required this.time});

  final String menu;
  final double cal;
  final String time;
}
