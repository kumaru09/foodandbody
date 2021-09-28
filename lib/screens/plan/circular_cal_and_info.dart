import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodandbody/screens/plan/edit_goal_dialog.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class CircularCalAndInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _totalCal = getTotalCal();
    int _planCal = getPlanCal();
    int _goalCal = getGoalCal();

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
          flex: 6,
          child: Container(
              constraints: BoxConstraints(minHeight: 100),
              padding: EdgeInsets.only(left: 18, top: 18),
              child: _CircularCalTwoProgress(
                totalCal: _totalCal,
                planCal: _planCal,
                goalCal: _goalCal,
              ))),
      Expanded(
          flex: 4,
          child: Container(
            child: _PlanInfo(
                totalCal: _totalCal, planCal: _planCal, goalCal: _goalCal),
          )),
    ]);
  }

  int getTotalCal() {
    //query from DB
    return 1182;
  }

  int getPlanCal() {
    //query from DB
    return 1678;
  }

  int getGoalCal() {
    //query from DB
    return 1800;
  }
}

// ignore: must_be_immutable
class _CircularCalTwoProgress extends StatelessWidget {
  _CircularCalTwoProgress(
      {required this.totalCal, required this.planCal, required this.goalCal});

  final int totalCal;
  final int planCal;
  final int goalCal;
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
      cal = (totalCal - goalCal).toString();
      percentTotalCal = 1;
      percentTotalCal = 1;
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
      cal = (goalCal - planCal).toString();
    }

    return Stack(
      children: [
        //plan cal
        CircularPercentIndicator(
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

  final int totalCal;
  final int planCal;
  final int goalCal;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 25, top: 18),
        child: Row(
          children: [
            Container(
              child: Text(
                "เป้าหมาย",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(0),
              width: 35,
              height: 35,
              child: EditGoalDialog(),
            )
          ],
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 25, bottom: 15),
        child: Text(
          "$goalCal",
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
          "$planCal",
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
          "$totalCal",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(color: Theme.of(context).primaryColor)),
        ),
      )
    ]);
  }
}
