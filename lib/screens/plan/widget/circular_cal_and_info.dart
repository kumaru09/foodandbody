import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/user.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class CircularCalAndInfo extends StatelessWidget {
  CircularCalAndInfo(this._user, this._plan);

  final History _plan;
  final User _user;
  late double planCal = _plan.menuList
      .map((value) => value.calories)
      .fold(0, (previous, current) => previous + current);
  late double totalCal = _plan.totalCal;
  late double goalCal = _user.info!.goal!.toDouble();

  @override
  Widget build(BuildContext context) {
    return Row(
        key: const Key("circular_cal_and_info"),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 6,
              child: Container(
                  constraints: BoxConstraints(minHeight: 100),
                  padding: EdgeInsets.only(left: 18, top: 18),
                  child: _CircularCalTwoProgress(
                    totalCal: totalCal,
                    planCal: planCal,
                    goalCal: goalCal,
                  ))),
          Expanded(
              flex: 4,
              child: Container(
                child: _PlanInfo(
                    totalCal: totalCal, planCal: planCal, goalCal: goalCal),
              )),
        ]);
  }
}

// ignore: must_be_immutable
class _CircularCalTwoProgress extends StatelessWidget {
  _CircularCalTwoProgress(
      {required this.totalCal, required this.planCal, required this.goalCal});

  final double totalCal;
  final double planCal;
  final double goalCal;
  late double percentTotalCal = totalCal / goalCal;
  late double percentPlanCal = planCal / goalCal;

  late Color totalProgressColor;
  late Color planProgressColor;
  late Color backgroundColor;
  late String label;
  late String cal;

  @override
  Widget build(BuildContext context) {
    //check value
    if (percentTotalCal > 1) {
      totalProgressColor = Color(0xFFFF4040);
      planProgressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      label = "กินเกินแล้ว";
      cal = (totalCal - goalCal).round().toString();
      percentTotalCal = 1;
      percentPlanCal = 1;
    } else if (percentTotalCal < 1 && percentPlanCal > 1) {
      totalProgressColor = Theme.of(context).primaryColor;
      planProgressColor = Color(0xFFFFBB91);
      backgroundColor = Color(0xFFD8D8D8);
      label = "เพิ่มได้อีก";
      cal = "0";
      percentPlanCal = 1;
    } else {
      totalProgressColor = Theme.of(context).primaryColor;
      planProgressColor = Color(0xFFFFBB91);
      backgroundColor = Color(0xFFD8D8D8);
      label = "เพิ่มได้อีก";
      cal = (goalCal - planCal).round().toString();
    }

    return Stack(
      children: [
        //plan cal
        CircularPercentIndicator(
          key: const Key("circular_plan_cal"),
          radius: 183,
          lineWidth: 8,
          percent: percentPlanCal,
          animation: true,
          animationDuration: 750,
          progressColor: planProgressColor,
          backgroundColor: backgroundColor,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        //top: total cal
        CircularPercentIndicator(
          key: const Key("circular_total_cal"),
          radius: 183,
          lineWidth: 8,
          percent: percentTotalCal,
          animation: true,
          animationDuration: 750,
          progressColor: totalProgressColor,
          backgroundColor: backgroundColor.withOpacity(0),
          circularStrokeCap: CircularStrokeCap.round,
          center: Center(
            child: Column(
              key: const Key("circular_data_col"),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
                Text(
                  cal,
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .merge(TextStyle(color: totalProgressColor)),
                ),
                Text(
                  "แคล",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

// ignore: unused_element
class _PlanInfo extends StatelessWidget {
  const _PlanInfo(
      {required this.totalCal, required this.planCal, required this.goalCal});

  final double totalCal;
  final double planCal;
  final double goalCal;

  @override
  Widget build(BuildContext context) {
    return Column(
        key: const Key("cal_info"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 25, top: 18),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "เป้าหมาย",
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  width: 35,
                  height: 35,
                  child: _EditGoalDialog(),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25, bottom: 15),
            child: Text(
              "${goalCal.round()}",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "ที่จะกิน",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25, bottom: 15),
            child: Text(
              "${planCal.round()}",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "ที่กินแล้ว",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "${totalCal.round()}",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          )
        ]);
  }
}

// ignore: must_be_immutable
class _EditGoalDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key("edit_goal_button"),
      iconSize: 24,
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                key: const Key("edit_goal_dialog"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  "แก้ไขเป้าหมายแคลอรี่",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
                content: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "ตัวอย่าง 1600"),
                ),
                actions: <Widget>[
                  TextButton(
                      key: const Key("edit_button_in_edit_goal_dialog"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("ตกลง",
                          style: Theme.of(context).textTheme.button!.merge(
                              TextStyle(
                                  color: Theme.of(context).primaryColor)))),
                  TextButton(
                      key: const Key("cancel_button_in_edit_goal_dialog"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("ยกเลิก",
                          style: Theme.of(context).textTheme.button!.merge(
                              TextStyle(
                                  color: Theme.of(context).primaryColor))))
                ],
              )),
    );
  }
}
