import 'package:flutter/material.dart';

class AteMenuCardList extends StatelessWidget {
  const AteMenuCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List ateMenu = getAteMenuList();
    List<Widget> ateMenuCardList = [];
    for (int index = 0; index < ateMenu.length; index++) {
      ateMenuCardList.add(_buildAteMenuCard(context, ateMenu[index]));
    }
    return Column(children: ateMenuCardList);
  }

  Widget _buildAteMenuCard(BuildContext context, _AteMenuList item) {
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
              child: Text("${item.cal}",
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

  List getAteMenuList() {
    //query from DB
    return [
      _AteMenuList(menu: "โอวัลติน", cal: 177, time: "7:00"),
      _AteMenuList(menu: "ส้มตำไทย", cal: 240, time: "12:00"),
      _AteMenuList(menu: "ข้าวมันไก่", cal: 765, time: "17:35"),
    ];
  }
}

class _AteMenuList {
  _AteMenuList({required this.menu, required this.cal, required this.time});

  final String menu;
  final int cal;
  final String time;
}
