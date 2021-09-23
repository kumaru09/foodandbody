import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class CircularCalIndicator extends StatelessWidget {
  CircularCalIndicator({Key? key}) : super(key: key);
  late int totalCal = getTotalCal();
  late int goalCal = getGoalCal();
  late double percentCal = totalCal / goalCal;

  late Color progressColor;
  late Color backgroundColor;
  late String label;
  late String cal;

  int getTotalCal() {
    //query from DB
    return 1182;
  }

  int getGoalCal() {
    //query from DB
    return 1800;
  }

  @override
  Widget build(BuildContext context) {
    //check value
    if (percentCal > 1) {
      progressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      label = "กินเกินแล้ว";
      cal = (totalCal - goalCal).toString();
      percentCal = 1;
    } else {
      progressColor = Theme.of(context).indicatorColor;
      backgroundColor = Color(0xFFFFBB91);
      label = "กินได้อีก";
      cal = (goalCal - totalCal).toString();
    }

    return CircularPercentIndicator(
      key: const Key('calories_circular_indicator'),
      radius: 183,
      lineWidth: 8,
      percent: percentCal,
      animation: true,
      animationDuration: 750,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      circularStrokeCap: CircularStrokeCap.round,
      center: Center(
        child: Column(
          key: const Key('calories_circular_indicator_column'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .merge(TextStyle(color: Colors.white))),
            Text(
              cal,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .merge(TextStyle(color: progressColor)),
            ),
            Text(
              "แคล",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .merge(TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}