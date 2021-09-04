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
      extendBody: true,
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
              icon:
                  Icon(Icons.settings, color: AppTheme.themeData.primaryColor))
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
                            percent: getRemainCal()[0],
                            animation: true,
                            animationDuration: 750,
                            progressColor: Colors.white,
                            center: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                                    child: Text(
                                      "กินได้อีก",
                                      style: AppTheme
                                          .themeData.textTheme.subtitle1!
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  Text(
                                    //Show remain calories
                                    getRemainCal()[1].toInt().toString(),
                                    style: AppTheme
                                        .themeData.textTheme.headline3!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                  Text(
                                    "แคล",
                                    style: AppTheme
                                        .themeData.textTheme.subtitle1!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "โปรตีน",
                                        style: AppTheme
                                            .themeData.textTheme.bodyText2!
                                            .merge(
                                                TextStyle(color: Colors.white)),
                                      ),
                                      LinearPercentIndicator(
                                        width: 97,
                                        animation: true,
                                        animationDuration: 750,
                                        lineHeight: 6,
                                        percent: double.parse(getNutrient()[0]),
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                        progressColor: Colors.white,
                                      ),
                                      Text(
                                        getNutrient()[1],
                                        style: AppTheme
                                            .themeData.textTheme.bodyText2!
                                            .merge(
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "คาร์บ",
                                        style: AppTheme
                                            .themeData.textTheme.bodyText2!
                                            .merge(
                                                TextStyle(color: Colors.white)),
                                      ),
                                      LinearPercentIndicator(
                                        width: 97,
                                        animation: true,
                                        animationDuration: 750,
                                        lineHeight: 6,
                                        percent: double.parse(getNutrient()[2]),
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                        progressColor: Colors.white,
                                      ),
                                      Text(
                                        getNutrient()[3],
                                        style: AppTheme
                                            .themeData.textTheme.bodyText2!
                                            .merge(
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "ไขมัน",
                                        style: AppTheme
                                            .themeData.textTheme.bodyText2!
                                            .merge(
                                                TextStyle(color: Colors.white)),
                                      ),
                                      LinearPercentIndicator(
                                        width: 97,
                                        animation: true,
                                        animationDuration: 750,
                                        lineHeight: 6,
                                        percent: double.parse(getNutrient()[4]),
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                        progressColor: Colors.white,
                                      ),
                                      Text(
                                        getNutrient()[5],
                                        style: AppTheme
                                            .themeData.textTheme.bodyText2!
                                            .merge(
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                      //continue coding
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // change to camera mode
        },
        backgroundColor: AppTheme.themeData.accentColor,
        child: Icon(Icons.photo_camera),
      ),
    );
  }

  List<double> getRemainCal() {
    var goal = 1800; //query goalCalories
    var total = 1182; //query totalCalories
    double remainCal = goal.toDouble() - total.toDouble();
    return [getPercent(total, goal), remainCal];
  }

  List<String> getNutrient() {
    var goalProtein = 85;
    var totalProtein = 47;
    var goalCarb = 200;
    var totalCarb = 145;
    var goalFat = 51;
    var totalFat = 14;
    return [
      getPercent(totalProtein, goalProtein).toString(), //% protein
      "$totalProtein/$goalProtein g", //protein description
      getPercent(totalCarb, goalCarb).toString(), //% carb
      "$totalCarb/$goalCarb g", //carb description
      getPercent(totalFat, goalFat).toString(), //% fat
      "$totalFat/$goalFat g" //fat description
    ];
  }

  double getPercent(int total, int goal) {
    return (total / goal);
  }
}
