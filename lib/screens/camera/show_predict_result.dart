import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';

class ShowPredictResult extends StatefulWidget {
  @override
  _ShowPredictResultState createState() => _ShowPredictResultState();
}

class _ShowPredictResultState extends State<ShowPredictResult> {
  // List<MenuDetail> _menu = [];
  List<TestMenu> _menu = [
    TestMenu(
        name: "ข้าวมันไก่",
        calories: 765.2,
        imageUrl:
            "https://shopee.co.th/blog/wp-content/uploads/2020/10/%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A7%E0%B8%A1%E0%B8%B1%E0%B8%99%E0%B9%84%E0%B8%81%E0%B9%88-1140x815.jpg",
        volumn: 217.5,
        protein: 27.5,
        carb: 89.1,
        fat: 32.2),
    TestMenu(
        name: "ข้าวยำไก่แซ่บ",
        calories: 640.0,
        imageUrl:
            "https://babban.club/wp-content/uploads/2020/07/%E0%B8%A7%E0%B8%B4%E0%B8%98%E0%B8%B5%E0%B8%97%E0%B8%B3%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A7%E0%B8%A2%E0%B8%B3%E0%B9%84%E0%B8%81%E0%B9%88%E0%B9%81%E0%B8%8B%E0%B9%88%E0%B8%9A-1024x765.jpg",
        volumn: 100.0,
        protein: 25.3,
        carb: 94.1,
        fat: 18.2),
    TestMenu(
        name: "ไก่ย่าง",
        calories: 167,
        imageUrl:
            "https://siamallfood.com/wp-content/uploads/2014/11/Turmeric-Grilled-Chicken-SiamAllFood.com_-740x431.jpg",
        volumn: 200.3,
        protein: 25.3,
        carb: 0.0,
        fat: 6.6),
  ];
  late int _resultMatch = _menu.length; //ผลลัพธ์ที่ match กับรูป
  double _totalCal = 0;
  late List<bool> _isChecked = List<bool>.generate(_resultMatch, (i) => false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            state.predicts.length == 0
                ? ""
                : "${state.predicts.length} ผลลัพธ์ที่ตรงกัน",
            style: Theme.of(context).textTheme.headline6!.merge(
                  TextStyle(color: Colors.white),
                ),
          ),
        ),
        body: state.status == CameraStatus.success
            ? SingleChildScrollView(
                child: Stack(
                  children: [
                    state.predicts.isEmpty
                        ? _noResultMatch(context)
                        : _buildResultList(context, state.predicts),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
        bottomSheet: Container(
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          padding: EdgeInsets.fromLTRB(11, 8, 20, 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "แคลอรี่รวม",
                  style: Theme.of(context).textTheme.headline6!.merge(
                        TextStyle(color: Colors.white),
                      ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minWidth: 50),
                child: Text(
                  "${_totalCal.round()}",
                  style: Theme.of(context).textTheme.headline6!.merge(
                        TextStyle(color: Colors.white),
                      ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "แคล",
                  style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(color: Colors.white),
                      ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  "ตกลง",
                  style: Theme.of(context).textTheme.button!.merge(
                        TextStyle(color: Theme.of(context).primaryColor),
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _noResultMatch(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.85,
      child: Text("ไม่พบผลลัพธ์ที่ตรงกัน",
          style: Theme.of(context).textTheme.bodyText1),
    );
  }

  Widget _buildResultList(BuildContext context, List<Predict> results) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: index == results.length - 1
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Color(0x21212114),
                ),
              ),
            ),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ShowMenuDetail(
                //               menu: results[index],
                //             )));
              },
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 11, 15, 11),
                // leading: Image.network(results[index],
                // height: 80, width: 80, fit: BoxFit.cover),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          results[index].name,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.headline6!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(children: [
                            TextSpan(
                              text: "${results[index].calory.round()}",
                              style:
                                  Theme.of(context).textTheme.headline5!.merge(
                                        TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                            ),
                            TextSpan(
                              text: " แคล",
                              style:
                                  Theme.of(context).textTheme.bodyText2!.merge(
                                        TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                            )
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
                trailing: Checkbox(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked[index] = value!;
                      print("before: $_totalCal / $value");
                      value
                          ? _totalCal += results[index].calory
                          : _totalCal -= results[index].calory;
                      print(
                          "after: $_totalCal ( +- ${results[index].calory} )");
                    });
                  },
                  value: _isChecked[index],
                ),
              ),
            ),
          );
        });
  }
}

class TestMenu {
  const TestMenu(
      {required this.name,
      required this.calories,
      required this.imageUrl,
      required this.volumn,
      required this.protein,
      required this.carb,
      required this.fat});

  final String name;
  final double calories;
  final String imageUrl;
  final double volumn;
  final double protein;
  final double carb;
  final double fat;
}
