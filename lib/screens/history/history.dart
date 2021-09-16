import 'package:flutter/material.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/screens/plan/plan.dart';
import 'package:foodandbody/widget/bottom_appbar.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List page = [Home(), Plan(), Body(), History()];
  int bottomAppBarIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text("ประวัติ",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .merge(TextStyle(color: Theme.of(context).primaryColor))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //change to camera mode
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Camera()));
          },
          elevation: 0.4,
          child: Icon(Icons.photo_camera),
          backgroundColor: Theme.of(context).accentColor,
        ),
        bottomNavigationBar: BottomAppBarWidget(
            index: bottomAppBarIndex, onChangedTab: onChangedTab));
  }

  void onChangedTab(int index) {
    setState(() {
      this.bottomAppBarIndex = index;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => page[index]));
    });
  }
}