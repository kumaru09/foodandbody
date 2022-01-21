import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/screens/body/weight_graph.dart';

void main() {
  const bodyWeightGraphKey = Key("body_weight_graph");
  late List<WeightList> mockWeightList = [
    WeightList(weight: 55, date: Timestamp.now())
  ];

  group("Weight Graph", () {
    testWidgets("can render", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: WeightGraph(mockWeightList),
      ));
      expect(find.byKey(bodyWeightGraphKey), findsOneWidget);
    });
  });
}