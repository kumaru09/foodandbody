import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class LinearNutrientIndicator extends StatelessWidget {
  LinearNutrientIndicator({Key? key}) : super(key: key);

  late double totalProtein = 44.8;
  late double totalCarb = 145.2;
  late double totalFat = 13.9;

  late double goalProtein = 85.0;
  late double goalCarb = 200.4;
  late double goalFat = 50.6;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key('linear_indicator_row'),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _BuildLinearIndicator(
            keyCol: const Key('protein_linear_indicator'),
            keyLinear: const Key('protein_line'),
            label: "โปรตีน",
            total: totalProtein,
            goal: goalProtein),
        _BuildLinearIndicator(
            keyCol: const Key('carb_linear_indicator'),
            keyLinear: const Key('carb_line'),
            label: "คาร์บ",
            total: totalCarb,
            goal: goalCarb),
        _BuildLinearIndicator(
            keyCol: const Key('fat_linear_indicator'),
            keyLinear: const Key('fat_line'),
            label: "ไขมัน",
            total: totalFat,
            goal: goalFat),
      ],
    );
  }
}

class _BuildLinearIndicator extends StatelessWidget {
  const _BuildLinearIndicator(
      {required this.keyCol,
      required this.keyLinear,
      required this.label,
      required this.total,
      required this.goal});

  final Key keyCol;
  final Key keyLinear;
  final String label;
  final double total;
  final double goal;

  @override
  Widget build(BuildContext context) {
    double percent = total / goal;
    Color progressColor;
    Color backgroundColor;

    if (percent > 1) {
      progressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      percent = 1;
    } else {
      progressColor = Theme.of(context).indicatorColor;
      backgroundColor = Color(0xFFFFBB91);
    }

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
          percent: percent,
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: progressColor,
          backgroundColor: backgroundColor,
        ),
        Text("${total.round()}/${goal.round()} g",
            style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: progressColor),
                ))
      ],
    );
  }
}
