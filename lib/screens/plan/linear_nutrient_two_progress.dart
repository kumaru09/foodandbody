import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearNutrientTwoProgress extends StatelessWidget {
  const LinearNutrientTwoProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 86,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _LinearIndicator(
                label: "โปรตีน",
                totalNutrient: getTotalNutrient()[0],
                planNutrient: getPlanNutrient()[0],
                goalNutrient: getGoalNutrient()[0]),
            _LinearIndicator(
                label: "คาร์บ",
                totalNutrient: getTotalNutrient()[1],
                planNutrient: getPlanNutrient()[1],
                goalNutrient: getGoalNutrient()[1]),
            _LinearIndicator(
                label: "ไขมัน",
                totalNutrient: getTotalNutrient()[2],
                planNutrient: getPlanNutrient()[2],
                goalNutrient: getGoalNutrient()[2])
          ],
        ));
  }

  List getTotalNutrient() {
    //query from DB
    double _totalProtein = 45;
    double _totalCarb = 145;
    double _totalFat = 14;
    return [_totalProtein, _totalCarb, _totalFat];
  }

  List getPlanNutrient() {
    //query from DB
    double _planProtein = 60;
    double _planCarb = 180;
    double _planFat = 30;
    return [_planProtein, _planCarb, _planFat];
  }

  List getGoalNutrient() {
    //query from DB
    double _goalProtein = 85;
    double _goalCarb = 200;
    double _goalFat = 51;
    return [_goalProtein, _goalCarb, _goalFat];
  }
}

// ignore: must_be_immutable
class _LinearIndicator extends StatelessWidget {
  _LinearIndicator(
      {required this.label,
      required this.totalNutrient,
      required this.planNutrient,
      required this.goalNutrient});

  String label;
  double totalNutrient;
  double planNutrient;
  double goalNutrient;

  @override
  Widget build(BuildContext context) {
    Color totalProgressColor;
    Color planProgressColor;
    Color backgroundColor;

    double planPercent = planNutrient / goalNutrient;
    double totalPercent = totalNutrient / goalNutrient;

    //check value
    if (totalPercent > 1) {
      totalProgressColor = Color(0xFFFF4040);
      planProgressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      totalPercent = 1;
    } else if (totalPercent < 1 && planPercent > 1) {
      totalProgressColor = Theme.of(context).primaryColor;
      planProgressColor = Color(0xFFFFBB91);
      backgroundColor = Color(0xFFD8D8D8);
      planPercent = 1;
    } else {
      totalProgressColor = Theme.of(context).primaryColor;
      planProgressColor = Color(0xFFFFBB91);
      backgroundColor = Color(0xFFD8D8D8);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(TextStyle(color: Theme.of(context).primaryColor)),
        ),
        Stack(
          children: [
            //plan
            LinearPercentIndicator(
              width: 97,
              animation: true,
              animationDuration: 750,
              lineHeight: 6,
              percent: planPercent,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: planProgressColor,
              backgroundColor: backgroundColor,
            ),
            //total
            LinearPercentIndicator(
              width: 97,
              animation: true,
              animationDuration: 750,
              lineHeight: 6,
              percent: totalPercent,
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: totalProgressColor,
              backgroundColor: backgroundColor.withOpacity(0),
            ),
          ],
        ),
        Text(
          "$totalNutrient/$goalNutrient g",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(TextStyle(color: totalProgressColor)),
        )
      ],
    );
  }
}
