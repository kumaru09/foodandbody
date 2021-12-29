import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/screens/history/tab/history_body.dart';
import 'package:foodandbody/screens/history/tab/history_card.dart';

void main() {
  final GraphList mockGraphList = GraphList(
      caloriesList: List<int>.generate(10, (x) => x = x + 1),
      proteinList: List<int>.generate(10, (x) => x = x + 1),
      fatList: List<int>.generate(10, (x) => x = x + 1),
      carbList: List<int>.generate(10, (x) => x = x + 1),
      waterList: List<int>.generate(10, (x) => x = x + 1),
      waistList: List<int>.generate(10, (x) => x = x + 1),
      shoulderList: List<int>.generate(10, (x) => x = x + 1),
      chestList: List<int>.generate(10, (x) => x = x + 1),
      weightList: List<int>.generate(10, (x) => x = x + 1),
      hipList: List<int>.generate(10, (x) => x = x + 1),
      foodStartDate: DateTime(2021),
      foodEndDate: DateTime.now(),
      bodyStartDate: DateTime(2021),
      bodyEndDate: DateTime.now(),
      weightStartDate: DateTime(2021),
      weightEndDate: DateTime.now());

  final GraphList mockGraphListNoData = GraphList(
      caloriesList: List<int>.generate(10, (x) => x= 0),
      proteinList: List<int>.generate(10, (x) => x= 0),
      fatList: List<int>.generate(10, (x) => x= 0),
      carbList: List<int>.generate(10, (x) => x= 0),
      waterList: List<int>.generate(10, (x) => x= 0),
      waistList: [],
      shoulderList: [],
      chestList: [],
      weightList: [],
      hipList: [],
      foodStartDate: DateTime(2021),
      foodEndDate: DateTime.now(),
      bodyStartDate: DateTime(2021),
      bodyEndDate: DateTime.now(),
      weightStartDate: DateTime(2021),
      weightEndDate: DateTime.now());

  group('HistoryBody', () {
    group('render', () {
      testWidgets('HistoryCard when have data', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryBody(data: mockGraphList),
          ),
        );
        expect(find.byType(HistoryCard), findsNWidgets(5));
        expect(find.text('ไหล่'), findsOneWidget);
        expect(find.text('รอบอก'), findsOneWidget);
        expect(find.text('รอบเอว'), findsOneWidget);
        expect(find.text('รอบสะโพก'), findsOneWidget);
        expect(find.text('น้ำหนัก'), findsOneWidget);
      });

      testWidgets('nothing when have no data', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryBody(data: mockGraphListNoData),
          ),
        );
        expect(find.byType(HistoryCard), findsNothing);
        expect(find.text('ไหล่'), findsNothing);
        expect(find.text('รอบอก'), findsNothing);
        expect(find.text('รอบเอว'), findsNothing);
        expect(find.text('รอบสะโพก'), findsNothing);
        expect(find.text('น้ำหนัก'), findsNothing);
      });
    });
  });
}