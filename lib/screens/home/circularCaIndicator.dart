import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircularCalIndicator extends StatelessWidget {
  const CircularCalIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var totalCal = getTotalCal();
    var goalCal = getGoalCal();
    double percentCal = getPercentOfRemainCal(totalCal, goalCal);

    Color progressColor;
    Color backgroundColor;
    String label;
    String cal;

    //check value
    if (percentCal > 1) {
      progressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      label = "กินเกินแล้ว";
      cal = (totalCal - goalCal).toString();
      percentCal = percentCal - 1;
    } else {
      progressColor = Theme.of(context).indicatorColor;
      backgroundColor = Color(0xFFFFBB91);
      label = "กินได้อีก";
      cal = (goalCal - totalCal).toString();
    }

    return CircularPercentIndicator(
      radius: 183,
      lineWidth: 8,
      percent: percentCal,
      animation: true,
      animationDuration: 750,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      center: Center(
        child: Column(
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

  int getTotalCal() {
    //query from DB
    return 1182;
  }

  int getGoalCal() {
    //query from DB
    return 1800;
  }

  double getPercentOfRemainCal(int totalCal, int goalCal) {
    return (totalCal / goalCal);
  }
}