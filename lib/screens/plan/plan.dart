import 'package:flutter/material.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/screens/plan/widget/linear_nutrient_two_progress.dart';
import 'package:foodandbody/screens/plan/widget/plan_menu_card_list.dart';
import 'package:foodandbody/widget/bottom_appbar.dart';

import 'widget/ate_menu_card_list.dart';
import 'widget/circular_cal_and_info.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List page = [Home(), Plan(), Body(), History()];
  int bottomAppBarIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text("แผน",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .merge(TextStyle(color: Theme.of(context).primaryColor))),
        ),
        body: SingleChildScrollView( 
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, top: 16),
              width: MediaQuery.of(context).size.width,
              child: Text("แผนแคลอรี่วันนี้",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .merge(TextStyle(color: Theme.of(context).primaryColor))),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16),
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(minHeight: 100),
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularCalAndInfo(), LinearNutrientTwoProgress()],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text("เมนูที่จะกิน",
                  style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor),
                      )),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 8, right: 15),
              child: PlanMenuCardList(),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                  key: const Key("add_menu_button"),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0),
                  onPressed: () {
                    print("add menu");
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    "เพิ่มเมนู",
                    style: Theme.of(context).textTheme.button!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                "เมนูที่กินแล้ว",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 8),
              child: AteMenuCardList(),
            )
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //change to camera mode
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Camera()));
          },
          elevation: 0.4,
          child: Icon(Icons.photo_camera),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        bottomNavigationBar: BottomAppBarWidget(
            index: bottomAppBarIndex, onChangedTab: _onChangedTab));
  }

  void _onChangedTab(int index) {
    setState(() {
      this.bottomAppBarIndex = index;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => page[index]));
    });
  }
}