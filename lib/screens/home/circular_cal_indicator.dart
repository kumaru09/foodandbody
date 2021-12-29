import 'package:flutter/material.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class CircularCalIndicator extends StatelessWidget {
  CircularCalIndicator(this._plan, this._info);
  final History _plan;
  final Info _info;
  late double _totalCal = _plan.totalCal;
  late double _goalCal = _info.goal!.toDouble();
  late double _exercise = 0;

  @override
  Widget build(BuildContext context) {
    double percentCal = _totalCal / (_goalCal + _exercise);

    Color progressColor;
    Color backgroundColor;
    String label;
    String cal;

    if (percentCal > 1) {
      progressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      label = "กินเกินแล้ว";
      cal = (_totalCal - (_goalCal + _exercise)).round().toString();
      percentCal = 1;
    } else {
      progressColor = Theme.of(context).indicatorColor;
      backgroundColor = Color(0xFFFFBB91);
      label = "เหลือ";
      cal = ((_goalCal + _exercise) - _totalCal).round().toString();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 6,
          child: Container(
            constraints: BoxConstraints(minHeight: 100),
            padding: EdgeInsets.only(left: 24, top: 18, bottom: 18),
            child: _CircularCalInfo(
                percentCal: percentCal,
                progressColor: progressColor,
                backgroundColor: backgroundColor,
                label: label,
                cal: cal),
          ),
        ),
        Expanded(
          flex: 4,
          child: _UserCalInfo(
            goalCal: _goalCal,
            totalCal: _totalCal,
            exercise: _exercise,
          ),
        )
      ],
    );
  }
}

class _CircularCalInfo extends StatelessWidget {
  _CircularCalInfo(
      {required this.percentCal,
      required this.progressColor,
      required this.backgroundColor,
      required this.label,
      required this.cal});

  final double percentCal;
  final String cal;
  final String label;
  final Color progressColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      key: const Key('home_calories_circular'),
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
          key: const Key('home_calories_data_column'),
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

class _UserCalInfo extends StatelessWidget {
  _UserCalInfo(
      {required this.goalCal, required this.totalCal, required this.exercise});
  final double goalCal;
  final double totalCal;
  final double exercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('home_user_calories_info'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 25, top: 18),
          child: Text(
            "เป้าหมาย",
            style: Theme.of(context).textTheme.subtitle1!.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 25, bottom: 10),
          child: Text(
            "${goalCal.round()}",
            style: Theme.of(context).textTheme.headline6!.merge(
                  TextStyle(
                    color: Colors.white,
                  ),
                ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 25),
          child: Text(
            "กินแล้ว",
            style: Theme.of(context).textTheme.subtitle1!.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 25, bottom: 10),
          child: Text(
            "${totalCal.round()}",
            style: Theme.of(context).textTheme.headline6!.merge(
                  TextStyle(
                    color: Colors.white,
                  ),
                ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 25),
          child: Text(
            "เผาผลาญ",
            style: Theme.of(context).textTheme.subtitle1!.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 25, bottom: 10),
          child: Text(
            "${exercise.round()}",
            style: Theme.of(context).textTheme.headline6!.merge(
                  TextStyle(
                    color: Colors.white,
                  ),
                ),
          ),
        )
      ],
    );
  }
}
