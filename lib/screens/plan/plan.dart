import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/widget/linear_nutrient_two_progress.dart';
import 'package:foodandbody/screens/plan/widget/plan_menu_card_list.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';
import 'package:formz/formz.dart';

import 'widget/ate_menu_card_list.dart';
import 'widget/circular_cal_and_info.dart';

class Plan extends StatelessWidget {
  Plan({Key? key}) : super(key: key);

  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanBloc, PlanState>(
      listener: (context, state) {
        if (state.goalStatus == FormzStatus.submissionFailure) {
          _failUpdateGoal(context);
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text("แผน",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .merge(TextStyle(color: Theme.of(context).primaryColor))),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<PlanBloc, PlanState>(builder: (context, state) {
            switch (state.status) {
              case PlanStatus.success:
                return _buildPlan(context, state.plan, state.goal.value);
              case PlanStatus.failure:
                return _failureWidget(context);
              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }

  Widget _buildPlan(BuildContext context, History plan, String goal) {
    return BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
      return state.status == InfoStatus.success
          ? Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Text("แผนแคลอรี่วันนี้",
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 8, right: 16),
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(minHeight: 100),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularCalAndInfo(plan, goal),
                        LinearNutrientTwoProgress(state.info!, plan)
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text("เมนูที่จะกิน",
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                            TextStyle(color: Theme.of(context).primaryColor),
                          )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, top: 8, right: 15),
                  child: PlanMenuCardList(plan),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                      key: const Key("add_menu_button"),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).scaffoldBackgroundColor,
                          elevation: 0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        "เพิ่มเมนู",
                        style: Theme.of(context).textTheme.button!.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    "เมนูที่กินแล้ว",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 8),
                  child: AteMenuCardList(plan),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            );
    });
  }

  Widget _failureWidget(BuildContext context) {
    return Center(
      child: Column(
        key: Key('plan_failure_widget'),
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/error.png')),
          SizedBox(height: 10),
          Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
              style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
          OutlinedButton(
            child: Text('ลองอีกครั้ง'),
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            onPressed: () => context.read<PlanBloc>().add(LoadPlan()),
          ),
        ],
      ),
    );
  }

  void _failUpdateGoal(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          _timer =
              Timer(Duration(seconds: 2), () => Navigator.of(context).pop());
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.report,
                    color: Theme.of(context).colorScheme.secondary, size: 80),
                Text('กรอกข้อมูลไม่สำเร็จ',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
                Text('กรุณาลองอีกครั้ง',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ],
            ),
          );
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }
}
