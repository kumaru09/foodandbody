import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/models/history_menu.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/history/tab/history_body.dart';
import 'package:foodandbody/screens/history/tab/history_menu.dart';
import 'package:foodandbody/screens/history/tab/history_nutrient.dart';
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
  final List<HistoryMenuItem> mockMenuList = [
    HistoryMenuItem(
        name: 'ชื่ออาหาร',
        date: Timestamp.fromDate(DateTime.now()),
        calory: 300)
  ];
  final List<HistoryMenuItem> mockMenuListEmpty = [];

  setUpAll(() {
    registerFallbackValue<HistoryState>(FakeHistoryState());
    registerFallbackValue<HistoryEvent>(FakeHistoryEvent());
  });

  setUp(() {
    historyBloc = MockHistoryBloc();
  });

  group('History', () {
    group('render', () {
      testWidgets('AppBar', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success, dateMenuList: DateTime.now()));
        await tester.pumpHistory(historyBloc);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('ประวัติ'), findsOneWidget);
      });

      testWidgets('TabBar', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success, dateMenuList: DateTime.now()));
        await tester.pumpHistory(historyBloc);
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.text('เมนู'), findsOneWidget);
        expect(find.text('สารอาหาร'), findsOneWidget);
        expect(find.text('ร่างกาย'), findsOneWidget);
      });

      testWidgets('CircularProgressIndicator when status is initial', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.initial,
            graphList: mockGraphList,
            menuList: mockMenuList,
            dateMenuList: DateTime.now()));
        await tester.pumpHistory(historyBloc);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('HistoryMenu when tab menu', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphList,
            menuList: mockMenuList,
            dateMenuList: DateTime.now()));
        await tester.pumpHistory(historyBloc);
        await tester.tap(find.text('เมนู'));
        await tester.pumpAndSettle();
        expect(find.byType(HistoryMenu), findsOneWidget);
      });

      testWidgets('HistoryNutrient when tab nutrient', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphList,
            menuList: mockMenuList,
            dateMenuList: DateTime.now()));
        await tester.pumpHistory(historyBloc);
        await tester.tap(find.text('สารอาหาร'));
        await tester.pumpAndSettle();
        expect(find.byType(HistoryNutrient), findsOneWidget);
        expect(find.text('ไม่มีประวัติสารอาหารในขณะนี้'), findsNothing);
      });

      testWidgets('no HistoryNutrient when tab nutrient and not have nutrient data in list', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphListNoData,
            menuList: mockMenuListEmpty,
            dateMenuList: DateTime.now()));
        await tester.pumpHistory(historyBloc);
        await tester.tap(find.text('สารอาหาร'));
        await tester.pumpAndSettle();
        expect(find.byType(HistoryNutrient), findsNothing);
        expect(find.text('ไม่มีประวัติสารอาหารในขณะนี้'), findsOneWidget);
      });

      testWidgets('HistoryBody when tab body', (tester) async {
        when(() => historyBloc.state).thenReturn(HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphList,
            menuList: mockMenuList,
            dateMenuList: DateTime.now()));
        await tester.pumpHistory(historyBloc);
        await tester.tap(find.text('ร่างกาย'));
        await tester.pumpAndSettle();
        expect(find.byType(HistoryBody), findsOneWidget);
      });
    });
  });
}
