import 'package:flutter/material.dart';

class MenuDetail extends StatelessWidget {
  const MenuDetail({Key? key, required this.menuName}) : super(key: key);
  final String menuName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text("$menuName",
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