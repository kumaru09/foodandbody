import 'package:flutter/material.dart';
import 'package:foodandbody/models/menu_detail.dart';

class ShowFoodResult extends StatefulWidget {
  @override
  _ShowFoodResultState createState() => _ShowFoodResultState();
}

class _ShowFoodResultState extends State<ShowFoodResult> {
  // List<MenuDetail> _menu = [];
  List<TestMenu> _menu = [
    TestMenu(
        name: "ข้าวมันไก่",
        calories: 765.2,
        imageUrl:
            "https://shopee.co.th/blog/wp-content/uploads/2020/10/%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A7%E0%B8%A1%E0%B8%B1%E0%B8%99%E0%B9%84%E0%B8%81%E0%B9%88-1140x815.jpg",
        protein: 27.5,
        carb: 89.1,
        fat: 32.2),
    TestMenu(
        name: "ข้าวยำไก่แซ่บ",
        calories: 640.0,
        imageUrl:
            "https://babban.club/wp-content/uploads/2020/07/%E0%B8%A7%E0%B8%B4%E0%B8%98%E0%B8%B5%E0%B8%97%E0%B8%B3%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A7%E0%B8%A2%E0%B8%B3%E0%B9%84%E0%B8%81%E0%B9%88%E0%B9%81%E0%B8%8B%E0%B9%88%E0%B8%9A-1024x765.jpg",
        protein: 25.3,
        carb: 94.1,
        fat: 18.2),
    TestMenu(
        name: "ไก่ย่าง",
        calories: 167,
        imageUrl:
            "https://siamallfood.com/wp-content/uploads/2014/11/Turmeric-Grilled-Chicken-SiamAllFood.com_-740x431.jpg",
        protein: 25.3,
        carb: 0.0,
        fat: 6.6),
    TestMenu(
        name: "ข้าวมันไก่",
        calories: 765.2,
        imageUrl:
            "https://shopee.co.th/blog/wp-content/uploads/2020/10/%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A7%E0%B8%A1%E0%B8%B1%E0%B8%99%E0%B9%84%E0%B8%81%E0%B9%88-1140x815.jpg",
        protein: 27.5,
        carb: 89.1,
        fat: 32.2),
    TestMenu(
        name: "ข้าวยำไก่แซ่บ",
        calories: 640.0,
        imageUrl:
            "https://babban.club/wp-content/uploads/2020/07/%E0%B8%A7%E0%B8%B4%E0%B8%98%E0%B8%B5%E0%B8%97%E0%B8%B3%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A7%E0%B8%A2%E0%B8%B3%E0%B9%84%E0%B8%81%E0%B9%88%E0%B9%81%E0%B8%8B%E0%B9%88%E0%B8%9A-1024x765.jpg",
        protein: 25.3,
        carb: 94.1,
        fat: 18.2),
    TestMenu(
        name: "ไก่ย่าง",
        calories: 167,
        imageUrl:
            "https://siamallfood.com/wp-content/uploads/2014/11/Turmeric-Grilled-Chicken-SiamAllFood.com_-740x431.jpg",
        protein: 25.3,
        carb: 0.0,
        fat: 6.6)
  ];
  late int _resultMatch = _menu.length; //ผลลัพธ์ที่ match กับรูป
  late List<bool> _isChecked = List<bool>.generate(_resultMatch, (i) => false);
  double _totalCal = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Wrap(
        children: _resultMatch == 0
            ? _noResultMatch(context)
            : _buildResultList(context),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(11, 5, 20, 5),
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
                alignment: Alignment.topCenter,
                constraints: BoxConstraints(minWidth: 50),
                child: Text(
                  "${_totalCal.round()}",
                  style: Theme.of(context).textTheme.headline6!.merge(
                        TextStyle(color: Colors.white),
                      ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "แคล",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .merge(TextStyle(color: Colors.white)),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
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
      )
    ]);
  }

  _noResultMatch(BuildContext context) {
    return [
      ListTile(
        trailing: IconButton(
          icon: Icon(
            Icons.expand_more,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: Text("ไม่พบผลลัพธ์ที่ตรงกัน"),
      )
    ];
  }

  _buildResultList(BuildContext context) {
    return [
      ListTile(
        contentPadding: EdgeInsets.only(left: 16, right: 10),
        title: Text(
          "$_resultMatch ผลลัพธ์ที่ตรงกัน",
          style: Theme.of(context).textTheme.subtitle1!.merge(
                TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.expand_more,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.zero,
        child: Divider(
          color: Color(0x21212114),
          thickness: 1,
        ),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: _resultMatch,
          itemBuilder: (context, index) {
            return Column(children: [
              InkWell(
                onTap: () {},
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 15, top: 11, right: 15),
                  leading: Image.network(
                    _menu[index].imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            "${_menu[index].name}",
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
                                text: "${_menu[index].calories.round()} ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .merge(
                                      TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                              ),
                              TextSpan(
                                text: "แคล",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .merge(
                                      TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
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
                    value: _isChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked[index] = value!;
                        value
                            ? _totalCal += _menu[index].calories
                            : _totalCal -= _menu[index].calories;
                      });
                    },
                  ),
                ),
              ),
              index == _resultMatch - 1
                  ? Container(padding: EdgeInsets.only(bottom: 30))
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.zero,
                      child: Divider(
                        color: Color(0x21212114),
                        thickness: 1,
                        indent: 11,
                        endIndent: 15,
                      ),
                    )
            ]);
          })
    ];
  }
}

class TestMenu {
  const TestMenu(
      {required this.name,
      required this.calories,
      required this.imageUrl,
      required this.protein,
      required this.carb,
      required this.fat});

  final String name;
  final double calories;
  final String imageUrl;
  final double protein;
  final double carb;
  final double fat;
}
