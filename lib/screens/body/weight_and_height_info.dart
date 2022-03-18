import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_graph.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class WeightAndHeightInfo extends StatelessWidget {
  WeightAndHeightInfo(this.height, this.weightList);

  final int? height;
  final List<WeightList> weightList;

  late int? weight = weightList.first.weight;
  late double bmi =
      double.parse((weight! / pow(height! / 100, 2)).toStringAsFixed(2));
  late String date =
      DateFormat("dd/MM/yyyy").format(weightList.first.date!.toDate());

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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child:
                  BlocBuilder<BodyCubit, BodyState>(builder: (context, state) {
                switch (state.weightStatus) {
                  case FormzStatus.submissionInProgress:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16, top: 11),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "น้ำหนัก",
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "$weight",
                            style: Theme.of(context).textTheme.headline4!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
                              onPressed: () async {
                                final value = await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      BlocProvider<BodyCubit>(
                                    create: (_) => BodyCubit(
                                        bodyRepository:
                                            context.read<BodyRepository>(),
                                        userRepository:
                                            context.read<UserRepository>()),
                                    child: EditWeightDialog(),
                                  ),
                                );
                                if (value != 'cancel' && value != null) {
                                  context.read<BodyCubit>().updateWeight(value);
                                  context
                                      .read<HistoryBloc>()
                                      .add(LoadHistory());
                                }
                              },
                            ))
                      ],
                    );
                }
              })),
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
                child: BlocBuilder<BodyCubit, BodyState>(
                    builder: (context, state) {
                  switch (state.heightStatus) {
                    case FormzStatus.submissionInProgress:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return _buildCardContent(
                        context: context,
                        content: "ส่วนสูง",
                        value: height!.toDouble(),
                      );
                  }
                }),
              ),
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
                    final value = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          BlocProvider<BodyCubit>(
                        create: (_) => BodyCubit(
                            bodyRepository: context.read<BodyRepository>(),
                            userRepository: context.read<UserRepository>()),
                        child: EditHeightDialog(),
                      ),
                    );
                    if (value != 'cancel' && value != null) {
                      context.read<BodyCubit>().updateHeight(value);
                    }
                  },
                ),
              )
            : Container()
      ],
    );
  }
}

class EditWeightDialog extends StatelessWidget {
  const EditWeightDialog({Key? key}) : super(key: key);

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
      content: BlocBuilder<BodyCubit, BodyState>(
          buildWhen: (previous, current) => previous.weight != current.weight,
          builder: (context, state) {
            return TextFormField(
              key: const Key("body_edit_weight_dialog_text_field"),
              onChanged: (weight) =>
                  context.read<BodyCubit>().weightChanged(weight),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'ตัวอย่าง 50',
                errorText:
                    state.weight.invalid ? 'กรุณาระบุน้ำหนักให้ถูกต้อง' : null,
              ),
            );
          }),
      actions: <Widget>[
        BlocBuilder<BodyCubit, BodyState>(
            buildWhen: (previous, current) => previous.weight != current.weight,
            builder: (context, state) {
              return TextButton(
                key: const Key("body_edit_weight_dialog_save_button"),
                onPressed: state.weight.valid
                    ? () => Navigator.pop(context, state.weight.value)
                    : null,
                child: Text("ตกลง"),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onSurface: Theme.of(context)
                      .colorScheme
                      .primaryVariant, // Disable color
                ),
              );
            }),
        TextButton(
            key: const Key("body_edit_weight_dialog_cancel_button"),
            onPressed: () {
              Navigator.pop(context, 'cancel');
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

class EditHeightDialog extends StatelessWidget {
  const EditHeightDialog({Key? key}) : super(key: key);

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
      content: BlocBuilder<BodyCubit, BodyState>(
          buildWhen: (previous, current) => previous.height != current.height,
          builder: (context, state) {
            return TextFormField(
              key: const Key("body_edit_height_dialog_text_field"),
              onChanged: (height) =>
                  context.read<BodyCubit>().heightChanged(height),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'ตัวอย่าง 160',
                errorText:
                    state.height.invalid ? 'กรุณาระบุส่วนสูงให้ถูกต้อง' : null,
              ),
            );
          }),
      actions: <Widget>[
        BlocBuilder<BodyCubit, BodyState>(
            buildWhen: (previous, current) => previous.height != current.height,
            builder: (context, state) {
              return TextButton(
                key: const Key("body_edit_height_dialog_save_button"),
                onPressed: state.height.valid
                    ? () => Navigator.pop(context, state.height.value)
                    : null,
                child: Text("ตกลง"),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onSurface: Theme.of(context)
                      .colorScheme
                      .primaryVariant, // Disable color
                ),
              );
            }),
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
