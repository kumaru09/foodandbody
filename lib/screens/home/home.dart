import 'package:flutter/material.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/home/circular_cal_indicator.dart';
import 'package:foodandbody/screens/search/search.dart';
import 'package:foodandbody/screens/plan/plan.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:foodandbody/widget/bottom_appbar.dart';
import 'package:foodandbody/screens/home/linear_nutrient_indicator.dart';
import 'package:foodandbody/widget/menu_card.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: Home());

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _page = [Home(), Plan(), Body(), History()];
  int _bottomAppBarIndex = 0;
  int _water = 0;

  @override
  Widget build(BuildContext context) {
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
                key: const Key('setting_button'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Setting()));
                },
                icon: Icon(Icons.settings,
                    color: Theme.of(context).primaryColor)),
            ElevatedButton(
                onPressed: () =>
                    context.read<AppBloc>().add(AppLogoutRequested()),
                key: const Key('homePage_logout_iconButton'),
                child: Text('Logout'))
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              //today's calories
              Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    "แคลอรีวันนี้",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                          TextStyle(color: Theme.of(context).primaryColor),
                        ),
                  )),
              //calories progress card
              Container(
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
                          child: LinearNutrientIndicator(), //line progress
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "เมนูแนะนำ",
                        style: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(color: Theme.of(context).primaryColor),
                            ),
                      ),
                      ElevatedButton.icon(
                        key: const Key('menu_all_button'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).scaffoldBackgroundColor,
                            elevation: 0),
                        onPressed: () {
                          //chage page
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Search()));
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text("ดูทั้งหมด",
                            style: Theme.of(context).textTheme.button!.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor),
                                )),
                      )
                    ],
                  )),
              MenuCardWidget(), //show menu card
              Container(
                padding: EdgeInsets.only(left: 16, top: 16),
                height: 51,
                child: Text(
                  "น้ำวันนี้",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
              Container(
                height: 74,
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 30),
                child: Card(
                  key: const Key('daily_water_card'),
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
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
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
                                  key: const Key('remove_water_button'),
                                  onPressed: _removeWater,
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
                                child: Text("$_water",
                                    key: const Key('daily_water_display'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .merge(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        )),
                              ),
                              Container(
                                width: 35,
                                height: 38,
                                child: ElevatedButton(
                                  key: const Key('add_water_button'),
                                  onPressed: _addWater,
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Text(
                        "แก้ว",
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
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
          key: const Key('camera_floating_button'),
          onPressed: () {
            //change to camera mode
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Camera()));
          },
          elevation: 0.4,
          child: Icon(Icons.photo_camera),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        bottomNavigationBar: BottomAppBarWidget(
            index: _bottomAppBarIndex, onChangedTab: _onChangedTab));
  }

  void _onChangedTab(int index) {
    setState(() {
      this._bottomAppBarIndex = index;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => _page[index]));
    });
  }

  void _addWater() {
    setState(() {
      _water++;
    });
  }

  void _removeWater() {
    setState(() {
      _water--;
      if (_water < 0) _water = 0;
    });
  }
}
