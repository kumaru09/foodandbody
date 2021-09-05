import 'package:flutter/material.dart';
import 'package:foodandbody/menuCard.dart';
import 'package:foodandbody/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Home extends StatefulWidget {
  // const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MenuCard> cardItems = [];
  var _water = 0;

  @override
  Widget build(BuildContext context) {
    this.cardItems = getMenuCard(); //get recommend menu from DB

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
                print("setting");
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

            //calories progress card
            Container(
              color: Color(0xFFF6F6F6),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Card(
                  color: AppTheme.themeData.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(102, 18, 95, 0),
                          //circular progress
                          child: CircularPercentIndicator(
                            radius: 183,
                            lineWidth: 8,
                            percent: getRemainCal()[0],
                            animation: true,
                            animationDuration: 750,
                            progressColor: Colors.white,
                            center: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "กินได้อีก",
                                    style: AppTheme
                                        .themeData.textTheme.subtitle1!
                                        .merge(TextStyle(color: Colors.white)),
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
                          //show line progress
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              //protein
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "โปรตีน",
                                    style: AppTheme
                                        .themeData.textTheme.bodyText2!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                  LinearPercentIndicator(
                                    width: 97,
                                    animation: true,
                                    animationDuration: 750,
                                    lineHeight: 6,
                                    percent: double.parse(getNutrient()[0]),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.white,
                                  ),
                                  Text(
                                    getNutrient()[1],
                                    style: AppTheme
                                        .themeData.textTheme.bodyText2!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              //carb
                              Column(
                                children: [
                                  Text(
                                    "คาร์บ",
                                    style: AppTheme
                                        .themeData.textTheme.bodyText2!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                  LinearPercentIndicator(
                                    width: 97,
                                    animation: true,
                                    animationDuration: 750,
                                    lineHeight: 6,
                                    percent: double.parse(getNutrient()[2]),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.white,
                                  ),
                                  Text(
                                    getNutrient()[3],
                                    style: AppTheme
                                        .themeData.textTheme.bodyText2!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              //fat
                              Column(
                                children: [
                                  Text(
                                    "ไขมัน",
                                    style: AppTheme
                                        .themeData.textTheme.bodyText2!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                  LinearPercentIndicator(
                                    width: 97,
                                    animation: true,
                                    animationDuration: 750,
                                    lineHeight: 6,
                                    percent: double.parse(getNutrient()[4]),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.white,
                                  ),
                                  Text(
                                    getNutrient()[5],
                                    style: AppTheme
                                        .themeData.textTheme.bodyText2!
                                        .merge(TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
                color: Color(0xFFF6F6F6),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "เมนูแนะนำ",
                          style: AppTheme.themeData.textTheme.bodyText1!.merge(
                            TextStyle(color: AppTheme.themeData.primaryColor),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            //change page
                            print("menu all");
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft),
                          label: Text(
                            "ดูทั้งหมด",
                            style: AppTheme.themeData.textTheme.button!.merge(
                                TextStyle(
                                    color: AppTheme.themeData.primaryColor)),
                          ),
                          icon: Icon(Icons.add,
                              color: AppTheme.themeData.primaryColor),
                        )
                      ],
                    ))),
            Container(
              height: 200,
              color: Color(0xFFF6F6F6),
              child: ListView.builder(
                  itemCount: cardItems.length, //show 5 card
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 8),
                  itemBuilder: (BuildContext context, int index) {
                    return buildMenuCard(index);
                  }),
            ),
            Container(
              height: 51,
              color: Color(0xFFF6F6F6),
              child: Padding(
                padding: EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  "น้ำวันนี้",
                  style: AppTheme.themeData.textTheme.bodyText1!
                      .merge(TextStyle(color: AppTheme.themeData.primaryColor)),
                ),
              ),
            ),
            Container(
              height: 74,
              color: Color(0xFFF6F6F6),
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "วันนี้คุณดื่มน้ำไปแล้ว",
                      style: AppTheme.themeData.textTheme.bodyText2!.merge(
                          TextStyle(color: AppTheme.themeData.accentColor)),
                    ),
                    Container(
                        height: 50,
                        width: 135,
                        child: Row(
                          children: [
                            Container(
                              width: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  border: Border.all(
                                      color: Color(0xFFC4C4C4), width: 1)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: AppTheme.themeData.accentColor,
                                ),
                                onPressed: removeWater,
                                color: AppTheme.themeData.accentColor,
                                padding: EdgeInsets.only(left: 0),
                              ),
                            ),
                            Container(
                              width: 57,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFFC4C4C4), width: 1)),
                              child: Text("${_water.toString()}",
                                  style: AppTheme.themeData.textTheme.headline5!
                                      .merge(
                                    TextStyle(
                                        color: AppTheme.themeData.accentColor),
                                  )),
                            ),
                            Container(
                              width: 35,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  border: Border.all(
                                      color: Color(0xFFC4C4C4), width: 1)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: AppTheme.themeData.accentColor,
                                ),
                                onPressed: addWater,
                                padding: EdgeInsets.only(left: 0),
                              ),
                            )
                          ],
                        )),
                    Text(
                      "แก้ว",
                      style: AppTheme.themeData.textTheme.bodyText2!.merge(
                          TextStyle(color: AppTheme.themeData.accentColor)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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

  List<MenuCard> getMenuCard() {
    //query menu image, menu name, calories
    return [
      MenuCard(
          "https://www.haveazeed.com/wp-content/uploads/2019/08/3.%E0%B8%AA%E0%B9%89%E0%B8%A1%E0%B8%95%E0%B8%B3%E0%B9%84%E0%B8%97%E0%B8%A2%E0%B9%84%E0%B8%82%E0%B9%88%E0%B9%80%E0%B8%84%E0%B9%87%E0%B8%A1-1.png",
          "ตำไทยไข่เค็ม",
          "172"),
      MenuCard("https://dilafashionshop.files.wordpress.com/2019/03/71.jpg",
          "ข้าวกะเพราไก่ไข่ดาว", "480"),
      MenuCard(
          "https://img.kapook.com/u/pirawan/Cooking1/thai%20spicy%20mushrooms%20salad.jpg",
          "ยำเห็ดรวมมิตร",
          "104"),
      MenuCard(
          "https://snpfood.com/wp-content/uploads/2020/01/Breakfast-00002-scaled-1-1536x1536.jpg",
          "ข้าวต้มปลา",
          "220"),
      MenuCard(
          "https://snpfood.com/wp-content/uploads/2020/01/Highlight-Menu-0059-scaled-1-1536x1536.jpg",
          "ข้าวผัดปู",
          "551"),
    ]; //dummy data
  }

  Widget buildMenuCard(int index) {
    final item = cardItems[index];
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 8),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          semanticContainer: true,
          child: InkWell(
            onTap: () {
              //change page
              print("tap menu card");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    item.image,
                    height: 150,
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.only(left: 8, top: 6),
                      child: Text(
                        item.menu,
                        textAlign: TextAlign.left,
                        style: AppTheme.themeData.textTheme.bodyText2!.merge(
                            TextStyle(color: AppTheme.themeData.accentColor)),
                      ),
                    ),
                    Container(
                      width: 50,
                      padding: EdgeInsets.only(top: 3, right: 8),
                      child: Text(
                        "${item.calories}",
                        textAlign: TextAlign.right,
                        style: AppTheme.themeData.textTheme.headline6!.merge(
                            TextStyle(color: AppTheme.themeData.accentColor)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  void addWater() {
    setState(() {
      print("add water");
      _water++;
    });
  }

  void removeWater() {
    setState(() {
      print("remove water");
      _water--;
      if (_water < 0) _water = 0;
    });
  }
}
