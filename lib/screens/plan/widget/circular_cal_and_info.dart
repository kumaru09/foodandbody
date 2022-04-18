import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:formz/formz.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircularCalAndInfo extends StatelessWidget {
  CircularCalAndInfo(this._plan, this._goal);

  final History _plan;
  final String _goal;
  late double planCal = _plan.menuList
      .map((value) => value.calories)
      .fold(0, (previous, current) => previous + current);
  late double totalCal = _plan.totalCal;
  late double goalCal = int.parse(_goal).toDouble();

  @override
  Widget build(BuildContext context) {
    return Row(
        key: const Key("circular_cal_and_info"),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 6,
              child: Container(
                  constraints: BoxConstraints(minHeight: 100),
                  padding: EdgeInsets.only(left: 18, top: 18),
                  child: _CircularCalTwoProgress(
                      totalCal: totalCal, planCal: planCal, goalCal: goalCal))),
          Expanded(
              flex: 4,
              child: Container(
                child: _PlanInfo(
                    totalCal: totalCal, planCal: planCal, goalCal: goalCal),
              )),
        ]);
  }
}

class _CircularCalTwoProgress extends StatelessWidget {
  _CircularCalTwoProgress(
      {required this.totalCal, required this.planCal, required this.goalCal});

  final double totalCal;
  final double planCal;
  final double goalCal;
  late double percentTotalCal = totalCal / goalCal;
  late double percentPlanCal = planCal / goalCal;

  late Color totalProgressColor;
  late Color planProgressColor;
  late Color backgroundColor;
  late String label;
  late String cal;

  @override
  Widget build(BuildContext context) {
    //check value
    if (percentTotalCal > 1) {
      totalProgressColor = Color(0xFFFF4040);
      planProgressColor = Color(0xFFFF4040);
      backgroundColor = Theme.of(context).indicatorColor.withOpacity(0.8);
      label = "กินเกินแล้ว";
      cal = (totalCal - goalCal).round().toString();
      percentTotalCal = 1;
      percentPlanCal = 1;
    } else if (percentTotalCal < 1 && percentPlanCal > 1) {
      totalProgressColor = Theme.of(context).primaryColor;
      planProgressColor = Color(0xFFFFBB91);
      backgroundColor = Color(0xFFD8D8D8);
      label = "เพิ่มได้อีก";
      cal = "0";
      percentPlanCal = 1;
    } else {
      totalProgressColor = Theme.of(context).primaryColor;
      planProgressColor = Color(0xFFFFBB91);
      backgroundColor = Color(0xFFD8D8D8);
      label = "เพิ่มได้อีก";
      cal = (goalCal - planCal).round().toString();
    }

    return Stack(
      children: [
        //plan cal
        CircularPercentIndicator(
          key: const Key("circular_plan_cal"),
          radius: 183,
          lineWidth: 8,
          percent: percentPlanCal,
          animation: true,
          animationDuration: 750,
          progressColor: planProgressColor,
          backgroundColor: backgroundColor,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        //top: total cal
        CircularPercentIndicator(
          key: const Key("circular_total_cal"),
          radius: 183,
          lineWidth: 8,
          percent: percentTotalCal,
          animation: true,
          animationDuration: 750,
          progressColor: totalProgressColor,
          backgroundColor: backgroundColor.withOpacity(0),
          circularStrokeCap: CircularStrokeCap.round,
          center: Center(
            child: Column(
              key: const Key("circular_data_col"),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
                Text(
                  cal,
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .merge(TextStyle(color: totalProgressColor)),
                ),
                Text(
                  "แคล",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _PlanInfo extends StatelessWidget {
  const _PlanInfo(
      {required this.totalCal, required this.planCal, required this.goalCal});

  final double totalCal;
  final double planCal;
  final double goalCal;

  @override
  Widget build(BuildContext context) {
    return Column(
        key: const Key("cal_info"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 25, top: 18),
            child: Row(
              children: [
                Container(
                  child: Text(
                    "เป้าหมาย",
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(0),
                    width: 35,
                    height: 35,
                    child: IconButton(
                        key: const Key("edit_goal_button"),
                        iconSize: 24,
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          final value = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                BlocProvider<PlanBloc>(
                              create: (_) => PlanBloc(
                                  planRepository:
                                      context.read<PlanRepository>(),
                                  userRepository:
                                      context.read<UserRepository>()),
                              child: EditGoalDialog(),
                            ),
                          );
                          if (value != 'cancel' && value != null) {
                            context
                                .read<PlanBloc>()
                                .add(UpdateGoal(goal: value));
                          }
                        }))
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25, bottom: 15),
            child: BlocBuilder<PlanBloc, PlanState>(
                buildWhen: (previous, current) =>
                    previous.goalStatus != current.goalStatus,
                builder: (context, state) {
                  if (state.goalStatus == FormzStatus.submissionInProgress)
                    return CircularProgressIndicator();
                  else
                    return Text(
                      "${goalCal.round()}",
                      style: Theme.of(context).textTheme.headline6!.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    );
                }),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "ที่จะกิน",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25, bottom: 15),
            child: Text(
              "${planCal.round()}",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "ที่กินแล้ว",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "${totalCal.round()}",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          )
        ]);
  }
}

class EditGoalDialog extends StatelessWidget {
  const EditGoalDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key("edit_goal_dialog"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text("แก้ไขเป้าหมายแคลอรี่",
          style: Theme.of(context).textTheme.subtitle1!.merge(
              TextStyle(color: Theme.of(context).colorScheme.secondary))),
      content: BlocBuilder<PlanBloc, PlanState>(
          buildWhen: (previous, current) => previous.goal != current.goal,
          builder: (context, state) {
            return TextFormField(
              key: const Key("edit_goal_textFormField"),
              onChanged: (goal) =>
                  context.read<PlanBloc>().add(GoalChange(value: goal)),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'ตัวอย่าง 1600',
                errorText:
                    state.goal.invalid ? 'กรุณาระบุแคลอรีให้ถูกต้อง' : null,
              ),
            );
          }),
      actions: <Widget>[
        TextButton(
            key: const Key("cancel_button_in_edit_goal_dialog"),
            onPressed: () {
              Navigator.pop(context, 'cancel');
            },
            child: Text("ยกเลิก",
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .merge(TextStyle(color: Theme.of(context).colorScheme.secondary)))),
        BlocBuilder<PlanBloc, PlanState>(
            buildWhen: (previous, current) => previous.goal != current.goal,
            builder: (context, state) {
              return TextButton(
                key: const Key("edit_button_in_edit_goal_dialog"),
                onPressed: state.goal.valid
                    ? () => Navigator.pop(context, state.goal.value)
                    : null,
                child: Text("ตกลง"),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  onSurface: Theme.of(context)
                      .colorScheme
                      .secondaryVariant, // Disable color
                ),
              );
            }),
      ],
    );
  }
}
