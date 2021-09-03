import 'package:flutter/material.dart';
import 'package:foodandbody/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
              style: Theme.of(context)
                  .textTheme
                  .headline5!
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
              Container(
                  height: 51,
                  color: Colors.amber,
                  child: Text(
                    "แคลอรี่วันนี้",
                    style: Theme.of(context).textTheme.bodyText1!.merge(
                        TextStyle(color: AppTheme.themeData.primaryColor)),
                  )),
              Container(
                height: 287,
                color: Colors.blue,
                child: Text("กินได้อีก"),
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
}
