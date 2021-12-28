import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/history/tab/history_card.dart';

void main() {
  final mockList = List<int>.generate(10, (x) => x = x + 1);
  final mockList1 = [123];
  final mockListLess = [200, 100];
  final mockListMore = [100, 200];
  final startDate = DateTime(2021);
  final stopDate = DateTime.now();

  const compareBody = Key('historyCard_compare_body');
  const startDateText = Key('historyCard_startDate');
  const stopDateText = Key('historyCard_stopDate');

  group('HistoryCard', () {
    group('render', () {
      testWidgets('correct card name', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'แคลอรี',
                dataList: mockList,
                startDate: startDate,
                stopDate: stopDate,
                isBody: false),
          ),
        );
        expect(find.text('แคลอรี'), findsOneWidget);
      });

      testWidgets('correct when isBody false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'แคลอรี',
                dataList: mockList,
                startDate: startDate,
                stopDate: stopDate,
                isBody: false),
          ),
        );
        expect(find.byKey(compareBody), findsNothing);
        expect(find.text('เทียบกับครั้งก่อนหน้า'), findsNothing);
      });

      testWidgets('correct when isBody true and have 1 element in List', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'แคลอรี',
                dataList: mockList1,
                startDate: startDate,
                stopDate: stopDate,
                isBody: true),
          ),
        );
        expect(find.byKey(compareBody), findsNothing);
        expect(find.text('เทียบกับครั้งก่อนหน้า'), findsNothing);
      });

      testWidgets('correct when isBody true and have more than 1 element in List', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'ไหล่',
                dataList: mockList,
                startDate: startDate,
                stopDate: stopDate,
                isBody: true),
          ),
        );
        expect(find.byKey(compareBody), findsOneWidget);
        expect(find.text('เทียบกับครั้งก่อนหน้า'), findsOneWidget);
      });

      testWidgets('less when compare result is less than', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'ไหล่',
                dataList: mockListLess,
                startDate: startDate,
                stopDate: stopDate,
                isBody: true),
          ),
        );
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
        expect(find.text('100 '), findsOneWidget);
        expect(find.text('เซนติเมตร'), findsOneWidget);
      });

      testWidgets('more when compare result is more than', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'น้ำหนัก',
                dataList: mockListMore,
                startDate: startDate,
                stopDate: stopDate,
                isBody: true),
          ),
        );
        expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
        expect(find.text('100 '), findsOneWidget);
        expect(find.text('กิโลกรัม'), findsOneWidget);
      });

      testWidgets('only stopDate when have 1 element in List', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'แคลอรี',
                dataList: mockList1,
                startDate: startDate,
                stopDate: stopDate,
                isBody: false),
          ),
        );
        expect(find.byKey(startDateText), findsNothing);
        expect(find.byKey(stopDateText), findsOneWidget);
      });

      testWidgets('startDate and stopDate when have more than 1 element in List', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'แคลอรี',
                dataList: mockList,
                startDate: startDate,
                stopDate: stopDate,
                isBody: false),
          ),
        );
        expect(find.byKey(startDateText), findsOneWidget);
        expect(find.byKey(stopDateText), findsOneWidget);
      });

      testWidgets('correct Date format', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'แคลอรี',
                dataList: mockList,
                startDate: startDate,
                stopDate: stopDate,
                isBody: false),
          ),
        );
        expect(find.text('${startDate.day}/${startDate.month}/${startDate.year}'), findsOneWidget);
        expect(find.text('วันนี้'), findsOneWidget);
      });

      testWidgets('graph', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HistoryCard(
                name: 'แคลอรี',
                dataList: mockList,
                startDate: startDate,
                stopDate: stopDate,
                isBody: false),
          ),
        );
        expect(find.byType(LineChart), findsOneWidget);
      });
    });
  });
}
