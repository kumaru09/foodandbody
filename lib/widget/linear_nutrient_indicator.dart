import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearNutrientIndicator extends StatelessWidget {
  const LinearNutrientIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //variable
    var totalProtein = getTotalNutrient()[0];
    var totalCarb = getTotalNutrient()[1];
    var totalFat = getTotalNutrient()[2];

    var goalProtein = getGoalNutrient()[0];
    var goalCarb = getGoalNutrient()[1];
    var goalFat = getGoalNutrient()[2];

    double percentProtein = totalProtein / goalProtein;
    double percentCarb = totalCarb / goalCarb;
    double percentFat = totalFat / goalFat;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildLinearIndicator(context, const Key('protein_linear_indicator'),
            "โปรตีน", totalProtein, goalProtein, percentProtein),
        buildLinearIndicator(context, const Key('carb_linear_indicator'),
            "คาร์บ", totalCarb, goalCarb, percentCarb),
        buildLinearIndicator(context, const Key('fat_linear_indicator'),
            "ไขมัน", totalFat, goalFat, percentFat),
      ],
    );
  }

  Widget buildLinearIndicator(BuildContext context, Key key, String label,
      int total, int goal, double percent) {
    return Column(
      key: key,
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
          width: 97,
          animation: true,
          animationDuration: 750,
          lineHeight: 6,
          percent: percent > 1 ? percent - 1 : percent,
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

  List getTotalNutrient() {
    //query from DB
    var _totalProtein = 47;
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

  Color getProgressColor(BuildContext context, double percent) {
    return percent > 1 ? Color(0xFFFF4040) : Theme.of(context).indicatorColor;
  }

  Color getbackgroundColor(BuildContext context, double percent) {
    return percent > 1
        ? Theme.of(context).indicatorColor.withOpacity(0.8)
        : Color(0xFFFFBB91);
  }
}
