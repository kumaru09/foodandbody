import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/models/history_menu.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';

void main() {
  final DateTime mockDateMenuList = DateTime(2022);
  final List<HistoryMenuItem> mockMenuList = [
    HistoryMenuItem(
        name: 'ชื่ออาหาร',
        date: Timestamp.fromDate(DateTime.now()),
        calory: 300)
  ];
  final GraphList mockGraphList = GraphList(
      caloriesList: List<int>.generate(10, (x) => x = x + 1),
      burnList: List<int>.generate(10, (x) => x = x + 1),
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

  group('HistoryState', () {
    HistoryState createSubject({
      HistoryStatus status = HistoryStatus.initial,
      GraphList? graphList,
      List<HistoryMenuItem>? menuList,
      DateTime? dateMenuList,
    }) {
      return HistoryState(
        status: status,
        graphList: graphList ?? mockGraphList,
        menuList: menuList ?? mockMenuList,
        dateMenuList: dateMenuList ?? mockDateMenuList,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(HistoryState(dateMenuList: mockDateMenuList),
          HistoryState(dateMenuList: mockDateMenuList));
      expect(
        HistoryState(dateMenuList: mockDateMenuList).toString(),
        HistoryState(dateMenuList: mockDateMenuList).toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: HistoryStatus.initial,
          graphList: mockGraphList,
          menuList: mockMenuList,
          dateMenuList: mockDateMenuList,
        ).props,
        equals(<Object?>[
          HistoryStatus.initial,
          mockGraphList,
          mockMenuList,
          mockDateMenuList,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            graphList: null,
            menuList: null,
            dateMenuList: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: HistoryStatus.success,
            graphList: mockGraphList,
            menuList: mockMenuList,
            dateMenuList: mockDateMenuList,
          ),
          equals(
            createSubject(
              status: HistoryStatus.success,
              graphList: mockGraphList,
              menuList: mockMenuList,
              dateMenuList: mockDateMenuList,
            ),
          ),
        );
      });
    });
  });
}
