import 'package:flutter/material.dart';
import 'package:foodandbody/screens/home/circularCaIndicator.dart';
import 'package:foodandbody/widget/buttomAppBar.dart';
import 'package:foodandbody/widget/linearNutrientIndicator.dart';
import 'package:foodandbody/widget/menuCard.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: Home());

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MenuCard> cardItems = [];
  var _water = 0;
  int bottomAppBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    this.cardItems = getMenuCard(); //get recommend menu from DB

    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text("หน้าหลัก",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .merge(TextStyle(color: Theme.of(context).primaryColor))),
          actions: [
            IconButton(
                onPressed: () {
                  // change page to setting page
                  print("setting");
                },
                icon: Icon(Icons.settings,
                    color: Theme.of(context).primaryColor)),
            ElevatedButton(
                onPressed: () =>
                    context.read<AppBloc>().add(AppLogoutRequested()),
                child: Text('Logout'))
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              //today's calories
              Container(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "แคลอรีวันนี้",
                  style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor),
                      ),
                ),
              )),

              //calories progress card
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(102, 18, 95, 0),
                            child: CircularCalIndicator(), //circular progress
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:
                                LinearNutrientIndicator(), //show line progress
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "เมนูแนะนำ",
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary:
                                    Theme.of(context).scaffoldBackgroundColor,
                                elevation: 0),
                            onPressed: () {
                              //chage page
                              print("menu all");
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                            label: Text("ดูทั้งหมด",
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .merge(
                                      TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )),
                          )
                        ],
                      ))),
              Container(
                height: 200,
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
                child: Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    "น้ำวันนี้",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
              Container(
                height: 74,
                // color: Color(0xFFF6F6F6),
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 30),
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
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                      ),
                      Container(
                          height: 38,
                          width: 135,
                          child: Row(
                            children: [
                              Container(
                                width: 35,
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: removeWater,
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).cardColor,
                                      elevation: 0,
                                      padding: EdgeInsets.all(0),
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFC4C4C4)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft:
                                                  Radius.circular(10)))),
                                  child: Icon(
                                    Icons.remove,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: 57,
                                height: 38,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFC4C4C4), width: 1)),
                                child: Text("${_water.toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .merge(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        )),
                              ),
                              Container(
                                width: 35,
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: addWater,
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).cardColor,
                                      elevation: 0,
                                      padding: EdgeInsets.all(0),
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFC4C4C4)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10)))),
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Text(
                        "แก้ว",
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //change to camera mode
            print("camera");
          },
          elevation: 0.4,
          child: Icon(Icons.photo_camera),
          backgroundColor: Theme.of(context).accentColor,
        ),
        bottomNavigationBar: BottomAppBarWidget(
            index: bottomAppBarIndex, onChangedTab: onChangedTab));
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
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
                      ),
                    ),
                    Container(
                      width: 50,
                      padding: EdgeInsets.only(top: 3, right: 8),
                      child: Text(
                        "${item.calories}",
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headline6!.merge(
                            TextStyle(color: Theme.of(context).accentColor)),
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

  void onChangedTab(int index) {
    setState(() {
      this.bottomAppBarIndex = index;
    });
  }
}
