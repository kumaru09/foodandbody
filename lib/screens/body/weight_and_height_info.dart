import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_graph.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

// ignore: must_be_immutable
class WeightAndHeightInfo extends StatelessWidget {
  WeightAndHeightInfo(this._info, this.weightList);

  final Info _info;
  final List<WeightList> weightList;

  late int? weight = weightList.first.weight;
  late int? height = _info.height;
  late double bmi =
      double.parse((weight! / pow(height! / 100, 2)).toStringAsFixed(2));
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
            key: const Key("body_weight_card"),
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
                WeightGraph(weightList),
                Container(
                    alignment: Alignment.topRight,
                    constraints: BoxConstraints.tightFor(height: 30),
                    child: TextButton(
                      key: const Key("body_edit_weight_button"),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(right: 16, bottom: 11),
                        minimumSize: Size.zero,
                        alignment: Alignment.topRight,
                      ),
                      child: Text("แก้ไข",
                          style: Theme.of(context).textTheme.button!.merge(
                              TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary))),
                      onPressed: () async {
                        final value = await showDialog<int?>(
                            context: context,
                            builder: (BuildContext context) =>
                                EditWeightDialog());
                        if (value != null && value != 0) {
                          context
                              .read<InfoBloc>()
                              .add(UpdateWeight(weight: value));
                          context.read<BodyCubit>().updateWeight(value);
                        }
                      },
                    ))
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
                key: const Key("body_height_card"),
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: _buildCardContent(
                    context: context,
                    content: "ส่วนสูง",
                    value: height!.toDouble(),
                  )),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 100),
              width: MediaQuery.of(context).size.width * 0.45,
              child: Card(
                key: const Key("body_bmi_card"),
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: _buildCardContent(
                      context: context, content: "BMI", value: bmi)),
            )
          ],
        )
      ],
    );
  }

  _buildCardContent({
    required BuildContext context,
    required String content,
    required double value,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, top: 11),
          alignment: Alignment.topLeft,
          child: Text(content,
              style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
        ),
        Container(
          padding: EdgeInsets.only(left: 16),
          alignment: Alignment.topLeft,
          child: Text(content == "ส่วนสูง" ? "${value.toInt()}" : "$value",
              style: Theme.of(context).textTheme.headline4!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
        ),
        content == "ส่วนสูง"
            ? Container(
                alignment: Alignment.topRight,
                constraints: BoxConstraints.tightFor(height: 30),
                child: TextButton(
                  key: const Key("body_edit_height_button"),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.only(right: 16, bottom: 11),
                      minimumSize: Size.zero,
                      alignment: Alignment.topRight),
                  child: Text("แก้ไข",
                      style: Theme.of(context).textTheme.button!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                  onPressed: () async {
                    final value = await showDialog<int?>(
                        context: context,
                        builder: (BuildContext context) => EditHeightDialog());
                    if (value != null && value != 0) {
                      context.read<InfoBloc>().add(UpdateHeight(height: value));
                    }
                  },
                ),
              )
            : Container()
      ],
    );
  }
}

class EditWeightDialog extends StatefulWidget {
  const EditWeightDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeightDialog();
}

class _WeightDialog extends State<EditWeightDialog> {
  String _currentWeight = '0';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key("body_edit_weight_dialog"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text("แก้ไขน้ำหนัก",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(color: Theme.of(context).primaryColor))),
      content: TextField(
        key: const Key("body_edit_weight_dialog_text_field"),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: "ตัวอย่าง 50"),
        onChanged: (weight) => setState(() {
          _currentWeight = weight;
        }),
      ),
      actions: <Widget>[
        TextButton(
            key: const Key("body_edit_weight_dialog_save_button"),
            onPressed: () => Navigator.pop(context, int.parse(_currentWeight)),
            child: Text("ตกลง",
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .merge(TextStyle(color: Theme.of(context).primaryColor)))),
        TextButton(
            key: const Key("body_edit_weight_dialog_cancel_button"),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("ยกเลิก",
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .merge(TextStyle(color: Theme.of(context).primaryColor))))
      ],
    );
  }
}

class EditHeightDialog extends StatefulWidget {
  const EditHeightDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeightDialog();
}

class _HeightDialog extends State<EditHeightDialog> {
  String _currentHeight = '0';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key("body_edit_height_dialog"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text("แก้ไขส่วนสูง",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(color: Theme.of(context).primaryColor))),
      content: TextField(
          key: const Key("body_edit_height_dialog_text_field"),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "ตัวอย่าง 165"),
          onChanged: (height) => setState(() {
                _currentHeight = height;
              })),
      actions: <Widget>[
        TextButton(
            key: const Key("body_edit_height_dialog_save_button"),
            onPressed: () => Navigator.pop(context, int.parse(_currentHeight)),
            child: Text("ตกลง",
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .merge(TextStyle(color: Theme.of(context).primaryColor)))),
        TextButton(
            key: const Key("body_edit_height_dialog_cancel_button"),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("ยกเลิก",
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .merge(TextStyle(color: Theme.of(context).primaryColor))))
      ],
    );
  }
}
