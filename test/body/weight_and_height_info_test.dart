import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockInfo extends Mock implements Info {}

void main() {
  var mockWeightList = [
    WeightList(weight: 55, date: Timestamp.now()),
    WeightList(weight: 56, date: Timestamp.now()),
    WeightList(weight: 57, date: Timestamp.now()),
    WeightList(weight: 56, date: Timestamp.now()),
    WeightList(weight: 54, date: Timestamp.now()),
  ];

  const bodyWeightGraphKey = Key("body_weight_graph");
  const bodyEditWeightButtonKey = Key("body_edit_weight_button");

  const bodyEditWeightDialogKey = Key("body_edit_weight_dialog");
  const bodyEditWeightDialogTextFieldKey =
      Key("body_edit_weight_dialog_text_field");
  const bodyEditWeightDialogSaveButtonKey =
      Key("body_edit_weight_dialog_save_button");
  const bodyEditWeightDialogCancelButtonKey =
      Key("body_edit_weight_dialog_cancel_button");
  const bodyEditHeightButtonKey = Key("body_edit_height_button");
  const bodyEditHeightDialogKey = Key("body_edit_height_dialog");
  const bodyEditHeightDialogTextFieldKey =
      Key("body_edit_height_dialog_text_field");
  const bodyEditHeightDialogSaveButtonKey =
      Key("body_edit_height_dialog_save_button");
  const bodyEditHeightDialogCancelButtonKey =
      Key("body_edit_height_dialog_cancel_button");

  group("Weight and Height Info", () {
    late Info info;

    setUp(() {
      info = MockInfo();
      when(() => info.height).thenReturn(164);
    });

    group("can render", () {
      testWidgets("weight card", (tester) async {
        await tester.pumpWidget(
            MaterialApp(home: WeightAndHeightInfo(info, mockWeightList)));
        expect(find.text("น้ำหนัก"), findsOneWidget);
        expect(
            find.text(mockWeightList.first.weight.toString()), findsOneWidget);
        expect(
            find.text(
                "วันที่ " + DateFormat("dd/MM/yyyy").format(DateTime.now())),
            findsOneWidget);
        expect(find.byKey(bodyWeightGraphKey), findsOneWidget);
        expect(find.byKey(bodyEditWeightButtonKey), findsOneWidget);
      });

      testWidgets("height card", (tester) async {
        await tester.pumpWidget(
            MaterialApp(home: WeightAndHeightInfo(info, mockWeightList)));
        expect(find.text("ส่วนสูง"), findsOneWidget);
        expect(find.text(info.height.toString()), findsOneWidget);
        expect(find.byKey(bodyEditHeightButtonKey), findsOneWidget);
      });

      testWidgets("BMI card", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: WeightAndHeightInfo(info, mockWeightList),
        ));
        final double expectBMI = double.parse(
            (mockWeightList.first.weight / pow(info.height! / 100, 2))
                .toStringAsFixed(2));
        expect(find.text("BMI"), findsOneWidget);
        expect(find.text(expectBMI.toString()), findsOneWidget);
      });
    });

    group("when press", () {
      testWidgets("แก้ไข button in weight card", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: WeightAndHeightInfo(info, mockWeightList),
        ));
        await tester.tap(find.byKey(bodyEditWeightButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditWeightDialogKey), findsOneWidget);
        expect(find.text("แก้ไขน้ำหนัก"), findsOneWidget);
        expect(find.byKey(bodyEditWeightDialogTextFieldKey), findsOneWidget);
        expect(find.byKey(bodyEditWeightDialogSaveButtonKey), findsOneWidget);
        expect(find.byKey(bodyEditWeightDialogCancelButtonKey), findsOneWidget);
        await tester.tap(find.byKey(bodyEditWeightDialogCancelButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditWeightDialogKey), findsNothing);
      });

      testWidgets("แก้ไข button in height card", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: WeightAndHeightInfo(info, mockWeightList),
        ));
        await tester.tap(find.byKey(bodyEditHeightButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditHeightDialogKey), findsOneWidget);
        expect(find.text("แก้ไขส่วนสูง"), findsOneWidget);
        expect(find.byKey(bodyEditHeightDialogTextFieldKey), findsOneWidget);
        expect(find.byKey(bodyEditHeightDialogSaveButtonKey), findsOneWidget);
        expect(find.byKey(bodyEditHeightDialogCancelButtonKey), findsOneWidget);
        await tester.tap(find.byKey(bodyEditHeightDialogCancelButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditHeightDialogKey), findsNothing);
      });
    });
  });
}
