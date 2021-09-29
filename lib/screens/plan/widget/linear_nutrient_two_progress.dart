import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class LinearNutrientTwoProgress extends StatelessWidget {
  late double proteinTotal = getTotalNutrient()[0];
  late double proteinPlan = getPlanNutrient()[0];
  late double proteinGoal = getGoalNutrient()[0];

  late double carbTotal = getTotalNutrient()[1];
  late double carbPlan = getPlanNutrient()[1];
  late double carbGoal = getGoalNutrient()[1];

  late double fatTotal = getTotalNutrient()[2];
  late double fatPlan = getPlanNutrient()[2];
  late double fatGoal = getGoalNutrient()[2];

  @override
  Widget build(BuildContext context) {
    return Container(
        key: const Key("nutrient_info"),
        height: 86,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _LinearIndicator(
                keyString: "plan_protein_linear",
                label: "โปรตีน",
                totalNutrient: proteinTotal,
                planNutrient: proteinPlan,
                goalNutrient: proteinGoal),
            _LinearIndicator(
                keyString: "plan_carb_linear",
                label: "คาร์บ",
                totalNutrient: carbTotal,
                planNutrient: carbPlan,
                goalNutrient: carbGoal),
            _LinearIndicator(
                keyString: "plan_fat_linear",
                label: "ไขมัน",
                totalNutrient: fatTotal,
                planNutrient: fatPlan,
                goalNutrient: fatGoal)
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
      {required this.keyString,
      required this.label,
      required this.totalNutrient,
      required this.planNutrient,
      required this.goalNutrient});

  String keyString;
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
      key: Key(keyString),
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
