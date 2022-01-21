import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/models/history_menu.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/history/tab/history_menu.dart';
import 'package:mocktail/mocktail.dart';

class FakeHistoryState extends Fake implements HistoryState {}

class FakeHistoryEvent extends Fake implements HistoryEvent {}

class MockHistoryBloc extends MockBloc<HistoryEvent, HistoryState>
    implements HistoryBloc {}

extension on WidgetTester {
  Future<void> pumpHistory(HistoryBloc historyBloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: historyBloc,
          child: History(),
        ),
      ),
    );
  }
}

void main() {
  const calendar = Key('history_menu_calendar');

  late HistoryBloc historyBloc;
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
      caloriesList: List<int>.generate(10, (x) => x = 0),
      proteinList: List<int>.generate(10, (x) => x = 0),
      fatList: List<int>.generate(10, (x) => x = 0),
      carbList: List<int>.generate(10, (x) => x = 0),
      waterList: List<int>.generate(10, (x) => x = 0),
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
  final DateTime mockDateMenuListEmpty = DateTime.now();
  final DateTime mockDateMenuList = DateTime.utc(2021, 12, 25);
  final List<HistoryMenuItem> mockMenuListEmpty = [];
  final List<HistoryMenuItem> mockMenuList = [
    HistoryMenuItem(
        name: 'หมู',
        date: Timestamp.fromDate(DateTime.parse("2021-12-25T14:15:16")),
        calory: 300),
    HistoryMenuItem(
        name: 'หมึก',
        date: Timestamp.fromDate(DateTime.parse("2021-12-25T20:10:00")),
        calory: 400)
  ];

  setUpAll(() {
    registerFallbackValue<HistoryState>(FakeHistoryState());
    registerFallbackValue<HistoryEvent>(FakeHistoryEvent());
  });

  setUp(() {
    historyBloc = MockHistoryBloc();
  });

  group('HistoryMenu', () {
    group('render', () {

      testWidgets('CircularProgressIndicator when status is initial', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.initial,
            graphList: mockGraphListNoData,
            menuList: mockMenuListEmpty,
            dateMenuList: mockDateMenuListEmpty));
        await tester.pumpHistory(historyBloc);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
      
      testWidgets('correct date and calory', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphListNoData,
            menuList: mockMenuListEmpty,
            dateMenuList: mockDateMenuListEmpty));
        await tester.pumpHistory(historyBloc);
        expect(
            find.text(
                '${mockDateMenuListEmpty.day}/${mockDateMenuListEmpty.month}/${mockDateMenuListEmpty.year}'),
            findsOneWidget);
        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
        expect(find.text('แคลอรีรวม'), findsOneWidget);
        expect(find.text('0 '), findsOneWidget);
        expect(find.text('แคล'), findsOneWidget);
      });

      testWidgets('no menu when list is empty', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphListNoData,
            menuList: mockMenuListEmpty,
            dateMenuList: mockDateMenuListEmpty));
        await tester.pumpHistory(historyBloc);
        expect(find.text('ไม่มีประวัติเมนู'), findsOneWidget);
        expect(find.byType(HistoryMenuDaily), findsNothing);
      });

      testWidgets('menu list when list is not empty', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphList,
            menuList: mockMenuList,
            dateMenuList: mockDateMenuList));
        await tester.pumpHistory(historyBloc);
        expect(
            find.text(
                '${mockDateMenuList.day}/${mockDateMenuList.month}/${mockDateMenuList.year}'),
            findsOneWidget);
        expect(find.text('ไม่มีประวัติเมนู'), findsNothing);
        expect(find.text('700 '), findsOneWidget);
        expect(find.byType(HistoryMenuDaily), findsNWidgets(2));
        expect(find.text('หมู'), findsOneWidget);
        expect(find.text('14:15'), findsOneWidget);
        expect(find.text('300 '), findsOneWidget);
        expect(find.text('หมึก'), findsOneWidget);
        expect(find.text('20:10'), findsOneWidget);
        expect(find.text('400 '), findsOneWidget);
      });
    });
  });
}
