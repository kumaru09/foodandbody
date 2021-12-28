import 'package:flutter/material.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/screens/body/edit_body_figure.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BodyFigureInfo extends StatelessWidget {
  BodyFigureInfo(this.body);

  final Body body;

  late int shoulder = body.shoulder;
  late int chest = body.chest;
  late int waist = body.waist;
  late int hip = body.hip;
  late String date = DateFormat.yMd().add_Hm().format(body.date.toDate());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    key: const Key('body_figure_image'),
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.only(left: 14, top: 17),
                    child: Image(
                      image: AssetImage("assets/body.png"),
                    ),
                  ),
                  CustomPaint(
                    key: const Key('body_shoulder_pointer'),
                    painter: _DrawLine(
                        context: context,
                        circleOffset: Offset(
                            MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.1),
                        lineOffset: Offset(
                            MediaQuery.of(context).size.width * 0.38,
                            MediaQuery.of(context).size.height * 0.02)),
                  ),
                  CustomPaint(
                    key: const Key('body_chest_pointer'),
                    painter: _DrawLine(
                        context: context,
                        circleOffset: Offset(
                            MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.148),
                        lineOffset: Offset(
                            MediaQuery.of(context).size.width * 0.38,
                            MediaQuery.of(context).size.height * 0.16)),
                  ),
                  CustomPaint(
                    key: const Key('body_waist_pointer'),
                    painter: _DrawLine(
                        context: context,
                        circleOffset: Offset(
                            MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.19),
                        lineOffset: Offset(
                            MediaQuery.of(context).size.width * 0.38,
                            MediaQuery.of(context).size.height * 0.295)),
                  ),
                  CustomPaint(
                    key: const Key('body_hip_pointer'),
                    painter: _DrawLine(
                        context: context,
                        circleOffset: Offset(
                            MediaQuery.of(context).size.width * 0.3,
                            MediaQuery.of(context).size.height * 0.225),
                        lineOffset: Offset(
                            MediaQuery.of(context).size.width * 0.38,
                            MediaQuery.of(context).size.height * 0.43)),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.only(left: 8, top: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "ไหล่",
                      style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            isEmpty(shoulder) ? "-" : "$shoulder",
                            style: Theme.of(context).textTheme.headline4!.merge(
                                  TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "เซนติเมตร",
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                  TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Divider(
                      color: Color(0x21212114),
                      thickness: 1,
                      indent: 8,
                      endIndent: 16,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.only(left: 8, top: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "รอบอก",
                      style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            isEmpty(chest) ? "-" : "$chest",
                            style: Theme.of(context).textTheme.headline4!.merge(
                                  TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "เซนติเมตร",
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                  TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Divider(
                      color: Color(0x21212114),
                      thickness: 1,
                      indent: 8,
                      endIndent: 16,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.only(left: 8, top: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "รอบเอว",
                      style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            isEmpty(waist) ? "-" : "$waist",
                            style: Theme.of(context).textTheme.headline4!.merge(
                                  TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "เซนติเมตร",
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                  TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Divider(
                      color: Color(0x21212114),
                      thickness: 1,
                      indent: 8,
                      endIndent: 16,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.only(left: 8, top: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "รอบสะโพก",
                      style: Theme.of(context).textTheme.bodyText2!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            isEmpty(hip) ? "-" : "$hip",
                            style: Theme.of(context).textTheme.headline4!.merge(
                                  TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "เซนติเมตร",
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                  TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 14, top: 17, bottom: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  "วันที่ $date",
                  style: Theme.of(context).textTheme.bodyText2!.merge(
                        TextStyle(
                          color: Color(0xFFA19FB9),
                        ),
                      ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(right: 16),
                  minimumSize: Size.zero,
                  alignment: Alignment.topRight,
                ),
                child: Text("แก้ไข",
                    style: Theme.of(context).textTheme.button!.merge(TextStyle(
                        color: Theme.of(context).colorScheme.secondary))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditBodyFigure(body: body)));
                },
              )
            ],
          )
        ],
      ),
    );
  }

  bool isEmpty(int value) => value == 0;
}

class _DrawLine extends CustomPainter {
  _DrawLine(
      {required this.context,
      required this.circleOffset,
      required this.lineOffset});

  final BuildContext context;
  final Offset circleOffset;
  final Offset lineOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final paintCircle = Paint()
      ..color = Color(0xFF515070)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleOffset, 5, paintCircle);

    final paintLine = Paint()
      ..color = Color(0xFF515070)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(circleOffset, lineOffset, paintLine);
    canvas.drawLine(
        lineOffset,
        Offset(MediaQuery.of(context).size.width * 0.45, lineOffset.dy),
        paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
