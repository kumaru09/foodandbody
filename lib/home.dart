import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:foodandbody/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Home extends StatefulWidget {
  // const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF6F6F6),
          elevation: 0,
          title: Text("หน้าหลัก",
              style: AppTheme.themeData.textTheme.headline5!
                  .merge(TextStyle(color: AppTheme.themeData.primaryColor))),
          actions: [
            IconButton(
                onPressed: () {
                  // change page to setting page
                },
                icon: Icon(Icons.settings,
                    color: AppTheme.themeData.primaryColor))
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              //today's calories
              Container(
                  color: Color(0xFFF6F6F6),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "แคลอรีวันนี้",
                      style: AppTheme.themeData.textTheme.bodyText1!.merge(
                        TextStyle(color: AppTheme.themeData.primaryColor),
                      ),
                    ),
                  )),

              //calories progress
              Container(
                height: 287,
                color: Color(0xFFF6F6F6),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Card(
                    color: AppTheme.themeData.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(102, 18, 95, 0),
                            child: CircularPercentIndicator(
                                radius: 183,
                                lineWidth: 8,
                                percent: getPercent(),
                                animation: true,
                                center: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 25, 0, 0),
                                        child: Text(
                                          "กินได้อีก",
                                          style: AppTheme
                                              .themeData.textTheme.subtitle1!
                                              .merge(TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      //Text Widget: Show remain calories
                                      getRemainCal(),
                                      Text(
                                        "แคล",
                                        style: AppTheme
                                            .themeData.textTheme.subtitle1!
                                            .merge(
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                                progressColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 51,
                color: Colors.cyan,
                child: Text("เมนูแนะนำ + ดูทั้งหมด"),
              ),
              Container(
                height: 200,
                color: Colors.deepPurple,
                child: Text("card menu"),
              ),
              Container(
                height: 51,
                color: Colors.green,
                child: Text("น้ำวันนี้"),
              ),
              Container(
                height: 74,
                color: Colors.indigo,
                child: Text("add water"),
              ),
            ],
          ),
        ));
  }

  Widget getRemainCal() {
    var remainCal = 618; //query (goalCalories - totalCalories)
    return Text(
      "${remainCal.toString()}",
      style: AppTheme.themeData.textTheme.headline3!
          .merge(TextStyle(color: Colors.white)),
    );
  }

  double getPercent() {
    var goalCal = 1800;
    var totalCal = 1182;
    return (totalCal/goalCal);
  }
}
