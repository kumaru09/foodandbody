import 'package:flutter/material.dart';
import 'package:foodandbody/screens/plan/widget/linear_nutrient_two_progress.dart';
import 'package:foodandbody/screens/plan/widget/plan_menu_card_list.dart';

import 'widget/ate_menu_card_list.dart';
import 'widget/circular_cal_and_info.dart';

class Plan extends StatelessWidget {
  const Plan({Key? key}) : super(key: key);

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
              padding:
                  EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 8),
              child: AteMenuCardList(),
            )
          ],
        )));
  }
}
