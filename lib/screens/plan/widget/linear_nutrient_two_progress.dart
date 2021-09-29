import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class LinearNutrientTwoProgress extends StatelessWidget {
  late double proteinTotal = 45.3;
  late double proteinPlan = 60.9;
  late double proteinGoal = 80.2;

  late double carbTotal = 145.0;
  late double carbPlan = 180.2;
  late double carbGoal = 200.3;

  late double fatTotal = 14.7;
  late double fatPlan = 30.3;
  late double fatGoal = 51.4;

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
          "${totalNutrient.round()}/${goalNutrient.round()} g",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(TextStyle(color: totalProgressColor)),
        )
      ],
    );
  }
}
