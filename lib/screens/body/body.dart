import 'package:flutter/material.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text("ร่างกาย",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .merge(TextStyle(color: Theme.of(context).primaryColor))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(left: 16, top: 16, right: 15),
                constraints: BoxConstraints(minHeight: 100),
                width: MediaQuery.of(context).size.width,
                child: WeightAndHeightInfo()),
            Container(
              padding: EdgeInsets.only(left: 16, top: 16),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "สัดส่วน",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 16, top: 8, right: 15, bottom: 100),
              width: MediaQuery.of(context).size.width,
              child: BodyFigureInfo()
            )
          ],
        ),
      ),
    );
  }
}
