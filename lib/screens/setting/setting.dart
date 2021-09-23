import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text("ตั้งค่า",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(TextStyle(color: Colors.white))),
          leading: IconButton(
              onPressed: () {
                // change page to setting page
                Navigator.pop(context);
              },
              icon:
                  Icon(Icons.arrow_back, color: Colors.white)),
        ));
  }
}