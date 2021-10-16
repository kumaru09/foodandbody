import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodandbody/screens/body/weight_graph.dart';
import 'package:intl/intl.dart';

class WeightAndHeightInfo extends StatelessWidget {
  WeightAndHeightInfo({Key? key}) : super(key: key);

  late int weight = 48;
  late int height = 165;
  late double bmi = double.parse(
      (weight / pow(height / 100, 2)).toStringAsFixed(2));
  late String date = DateFormat("dd/MM/yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 100),
          width: MediaQuery.of(context).size.width * 0.45,
          child: Card(
            elevation: 2,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, top: 11),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "น้ำหนัก",
                    style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "$weight",
                    style: Theme.of(context).textTheme.headline4!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "วันที่ $date",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .merge(TextStyle(color: Color(0xFFA19FB9))),
                  ),
                ),
                WeightGraph(),
                Container(
                  alignment: Alignment.topRight,
                  constraints: BoxConstraints.tightFor(height: 30),
                  child: _EditWeightDialog(),
                )
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 100),
              width: MediaQuery.of(context).size.width * 0.45,
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16, top: 11),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "ส่วนสูง",
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "$height",
                        style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      constraints: BoxConstraints.tightFor(height: 30),
                      child: _EditHeightDialog(),
                    )
                  ],
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 100),
              width: MediaQuery.of(context).size.width * 0.45,
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16, top: 11),
                      alignment: Alignment.topLeft,
                      child: Text("BMI",
                          style: Theme.of(context).textTheme.bodyText2!.merge(
                              TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary))),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "$bmi",
                        style: Theme.of(context).textTheme.headline4!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _EditWeightDialog extends StatelessWidget {
  const _EditWeightDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(right: 16, bottom: 11),
          minimumSize: Size.zero,
          alignment: Alignment.topRight,
        ),
        child: Text("แก้ไข",
            style: Theme.of(context).textTheme.button!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary))),
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text("แก้ไขน้ำหนัก",
                      style: Theme.of(context).textTheme.headline6!.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "ตัวอย่าง 50"),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("แก้ไข",
                            style: Theme.of(context).textTheme.button!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("ยกเลิก",
                            style: Theme.of(context).textTheme.button!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor))))
                  ],
                )));
  }
}

class _EditHeightDialog extends StatelessWidget {
  const _EditHeightDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(right: 16, bottom: 11),
          minimumSize: Size.zero,
          alignment: Alignment.topRight,
        ),
        child: Text("แก้ไข",
            style: Theme.of(context).textTheme.button!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary))),
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text("แก้ไขส่วนสูง",
                      style: Theme.of(context).textTheme.headline6!.merge(
                          TextStyle(color: Theme.of(context).primaryColor))),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "ตัวอย่าง 165"),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("แก้ไข",
                            style: Theme.of(context).textTheme.button!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("ยกเลิก",
                            style: Theme.of(context).textTheme.button!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor))))
                  ],
                )));
  }
}