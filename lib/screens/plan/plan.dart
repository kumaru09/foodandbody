import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/plan/widget/linear_nutrient_two_progress.dart';
import 'package:foodandbody/screens/plan/widget/plan_menu_card_list.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';

import 'widget/ate_menu_card_list.dart';
import 'widget/circular_cal_and_info.dart';

class Plan extends StatefulWidget {
  const Plan({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<Plan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text("แผน",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .merge(TextStyle(color: Theme.of(context).primaryColor))),
        ),
        body: SingleChildScrollView(
            child: BlocBuilder<PlanBloc, PlanState>(builder: (context, state) {
          if (state is PlanLoaded) {
            return _buildPlan(context, state.plan);
          } else if (state is PlanError) {
            return Container();
          }
          return Center(child: CircularProgressIndicator());
        })));
  }

  Widget _buildPlan(BuildContext context, History plan) {
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
                        CircularCalAndInfo(state.info!, plan),
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
}
