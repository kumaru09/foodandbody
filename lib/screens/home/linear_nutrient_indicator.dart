import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class LinearNutrientIndicator extends StatelessWidget {
  LinearNutrientIndicator({Key? key}) : super(key: key);

  late int totalProtein = getTotalNutrient()[0];
  late int totalCarb = getTotalNutrient()[1];
  late int totalFat = getTotalNutrient()[2];

  late int goalProtein = getGoalNutrient()[0];
  late int goalCarb = getGoalNutrient()[1];
  late int goalFat = getGoalNutrient()[2];

  late double percentProtein = totalProtein / goalProtein;
  late double percentCarb = totalCarb / goalCarb;
  late double percentFat = totalFat / goalFat;

  List getTotalNutrient() {
    //query from DB
    var _totalProtein = 45;
    var _totalCarb = 145;
    var _totalFat = 14;
    return [_totalProtein, _totalCarb, _totalFat];
  }

  List getGoalNutrient() {
    //query from DB
    var _goalProtein = 85;
    var _goalCarb = 200;
    var _goalFat = 51;
    return [_goalProtein, _goalCarb, _goalFat];
  }

  double getPercentDecimal(double percent) {
    if (percent > 1)
      return 1;
    else
      return percent;
  }

  Color getProgressColor(BuildContext context, double percent) {
    return percent > 1 ? Color(0xFFFF4040) : Theme.of(context).indicatorColor;
  }

  Color getbackgroundColor(BuildContext context, double percent) {
    return percent > 1
        ? Theme.of(context).indicatorColor.withOpacity(0.8)
        : Color(0xFFFFBB91);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key('linear_indicator_row'),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildLinearIndicator(context, const Key('protein_linear_indicator'), const Key('protein_line'),
            "โปรตีน", totalProtein, goalProtein, percentProtein),
        buildLinearIndicator(context, const Key('carb_linear_indicator'), const Key('carb_line'),
            "คาร์บ", totalCarb, goalCarb, percentCarb),
        buildLinearIndicator(context, const Key('fat_linear_indicator'), const Key('fat_line'),
            "ไขมัน", totalFat, goalFat, percentFat),
      ],
    );
  }

  Widget buildLinearIndicator(BuildContext context, Key keyCol, Key keyLinear, String label,
      int total, int goal, double percent) {
    return Column(
      key: keyCol,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(TextStyle(color: Colors.white)),
        ),
        LinearPercentIndicator(
          key: keyLinear,
          width: 97,
          animation: true,
          animationDuration: 750,
          lineHeight: 6,
          percent: getPercentDecimal(percent),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: getProgressColor(context, percent),
          backgroundColor: getbackgroundColor(context, percent),
        ),
        Text(
          "$total/$goal g",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(TextStyle(color: getProgressColor(context, percent))),
        )
      ],
    );
  }
}
