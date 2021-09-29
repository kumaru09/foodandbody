import 'package:flutter/material.dart';

class PlanMenuCardList extends StatefulWidget {
  const PlanMenuCardList({Key? key}) : super(key: key);

  @override
  _PlanMenuCardListState createState() => _PlanMenuCardListState();
}

class _PlanMenuCardListState extends State<PlanMenuCardList> {
  
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey();
  late List planMenu = [
      PlanMenu(menu: "ตำไทยไข่เค็ม", calories: 172.6),
      PlanMenu(menu: "ยำเห็ดรวมมิตร", calories: 104.2),
      PlanMenu(menu: "ข้าวต้มปลา", calories: 220.0)
    ];

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: animatedListKey,
      initialItemCount: planMenu.length,
      shrinkWrap: true,
      itemBuilder: (context, index, animation) {
        return _buildPlanCard(planMenu[index], animation);
      },
    );
  }

  Widget _buildPlanCard(PlanMenu item, Animation<double> animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: InkWell(
            onTap: () {
              print("tap card");
            },
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(17, 10, 10, 10),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text("${item.calories.round()}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .merge(TextStyle(color: Color(0xFF515070))))),
                    Expanded(
                        flex: 7,
                        child: Text("${item.menu}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .merge(TextStyle(color: Color(0xFF515070)))))
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Color(0xFF515070),
                  ),
                  onPressed: () {
                    int removeIndex = planMenu.indexOf(item);
                    PlanMenu removedItem = planMenu.removeAt(removeIndex);

                    AnimatedListRemovedItemBuilder builder =
                        (context, animation) {
                      return _buildPlanCard(removedItem, animation);
                    };

                    animatedListKey.currentState
                        ?.removeItem(removeIndex, builder);
                  },
                ),
              ),
            )));
  }
}

class PlanMenu {
  PlanMenu({required this.menu, required this.calories});

  final String menu;
  final double calories;
}
