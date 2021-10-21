import 'package:flutter/material.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/user.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class CircularCalIndicator extends StatelessWidget {
  CircularCalIndicator(this._plan, this._user);
  final History _plan;
  final User _user;
  late double totalCal = _plan.totalCal;
  late double goalCal = _user.info!.goal!.toDouble();

  @override
  Widget build(BuildContext context) {
    double percentCal = totalCal / goalCal;

    Color progressColor;
    Color backgroundColor;
    String label;
    String cal;

    if (percentCal > 1) {
      progressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      label = "กินเกินแล้ว";
      cal = (totalCal - goalCal).round().toString();
      percentCal = 1;
    } else {
      progressColor = Theme.of(context).indicatorColor;
      backgroundColor = Color(0xFFFFBB91);
      label = "กินได้อีก";
      cal = (goalCal - totalCal).round().toString();
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
