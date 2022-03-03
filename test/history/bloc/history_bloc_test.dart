import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/graph_list.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/history_menu.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/history_repository.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockBodyRepository extends Mock implements BodyRepository {}

void main() {
  group('HistoryBloc', () {
    final DateTime mockDateMenuList = DateTime.now();
    final List<HistoryMenuItem> mockHistoryMenuList = [
      HistoryMenuItem(
          name: 'ชื่ออาหาร',
          date: Timestamp.fromDate(mockDateMenuList),
          calory: 300)
    ];
    final List<Menu> mockMenuList = [
      Menu(
          name: 'ชื่ออาหาร',
          timestamp: Timestamp.fromDate(mockDateMenuList),
          calories: 300,
          protein: 20,
          carb: 20,
          fat: 20,
          serve: 1,
          volumn: 1)
    ];
    final GraphList mockGraphList = GraphList(
      caloriesList: [0, 0],
      burnList: [0, 0],
      proteinList: [0, 0],
      fatList: [0, 0],
      carbList: [0, 0],
      waterList: [0, 0],
      waistList: [40],
      shoulderList: [40],
      chestList: [40],
      hipList: [40],
      weightList: [50],
      foodStartDate: DateTime(2022),
      foodEndDate: mockDateMenuList,
      bodyStartDate: DateTime(2022),
      bodyEndDate: DateTime(2022),
      weightStartDate: DateTime(2022),
      weightEndDate: DateTime(2022),
    );
    final List<History> mockHistoryList = [
      History(Timestamp.fromDate(DateTime(2022))),
      History(Timestamp.fromDate(mockDateMenuList)),
    ];
    final List<Body> mockBodyList = [
      Body(
          date: Timestamp.fromDate(DateTime(2022)),
          shoulder: 40,
          chest: 40,
          waist: 40,
          hip: 40)
    ];
    final List<WeightList> mockWeightList = [
      WeightList(weight: 50, date: Timestamp.fromDate(DateTime(2022)))
    ];
    final List<History> mockHistoryListZero = [
      History(Timestamp.fromDate(mockDateMenuList)),
    ];
    final List<WeightList> mockWeightListZero = [
      WeightList(weight: 50, date: Timestamp.fromDate(mockDateMenuList))
    ];
    final Timestamp mockStateTime = Timestamp.fromDate(DateTime(
        mockDateMenuList.year, mockDateMenuList.month, mockDateMenuList.day));
    final Timestamp mockEndTime = Timestamp.fromDate(DateTime(
            mockDateMenuList.year, mockDateMenuList.month, mockDateMenuList.day)
        .add(new Duration(hours: 23, minutes: 59, seconds: 59)));

    late HistoryBloc historyBloc;
    late HistoryRepository historyRepository;
    late BodyRepository bodyRepository;

    setUp(() {
      historyRepository = MockHistoryRepository();
      bodyRepository = MockBodyRepository();
      historyBloc = HistoryBloc(
          historyRepository: historyRepository, bodyRepository: bodyRepository);
    });

    test('initial state is HistoryState()', () {
      expect(historyBloc.state,
          HistoryState(dateMenuList: historyBloc.state.dateMenuList));
    });

    group('LoadHistory', () {
      blocTest<HistoryBloc, HistoryState>(
        'emits successful status when fetches initial load history',
        setUp: () {
          when(() => historyRepository.getHistory())
              .thenAnswer((_) async => mockHistoryList);
          when(() => bodyRepository.getBodyList())
              .thenAnswer((_) async => mockBodyList);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => historyBloc,
        act: (bloc) => bloc.add(LoadHistory()),
        expect: () => <HistoryState>[
          HistoryState(
            status: HistoryStatus.success,
            graphList: mockGraphList,
            dateMenuList: historyBloc.state.dateMenuList,
          )
        ],
        verify: (_) {
          verify(() => historyRepository.getHistory()).called(1);
          verify(() => bodyRepository.getBodyList()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits failure status when fetches history and throw exception',
        setUp: () {
          when(() => historyRepository.getHistory())
              .thenAnswer((_) async => mockHistoryList);
          when(() => bodyRepository.getBodyList())
              .thenAnswer((_) async => mockBodyList);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => historyBloc,
        act: (bloc) => bloc.add(LoadHistory()),
        expect: () => <HistoryState>[
          HistoryState(
            status: HistoryStatus.failure,
            dateMenuList: historyBloc.state.dateMenuList,
          )
        ],
        verify: (_) {
          verify(() => historyRepository.getHistory()).called(1);
          verify(() => bodyRepository.getBodyList()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits successful status when '
        '0 additional history are fetched',
        setUp: () {
          when(() => historyRepository.getHistory())
              .thenAnswer((_) async => mockHistoryListZero);
          when(() => bodyRepository.getBodyList()).thenAnswer((_) async => []);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightListZero);
        },
        build: () => historyBloc,
        act: (bloc) => bloc.add(LoadHistory()),
        expect: () => <HistoryState>[
          HistoryState(
            status: HistoryStatus.success,
            graphList: historyBloc.state.graphList,
            dateMenuList: historyBloc.state.dateMenuList,
          )
        ],
        verify: (_) {
          verify(() => historyRepository.getHistory()).called(1);
          verify(() => bodyRepository.getBodyList()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );
    });

    group('LoadMenuList', () {
      blocTest<HistoryBloc, HistoryState>(
        'emits success status when load menu list success',
        setUp: () {
          when(() => historyRepository.getMenuListByDate(
                  mockStateTime, mockEndTime))
              .thenAnswer((_) async => mockMenuList);
        },
        build: () => historyBloc,
        act: (bloc) => bloc.add(LoadMenuList(dateTime: mockDateMenuList)),
        expect: () => <HistoryState>[
          HistoryState(
            status: HistoryStatus.success,
            menuList: mockHistoryMenuList,
            dateMenuList: historyBloc.state.dateMenuList,
          )
        ],
        verify: (_) {
          verify(() => historyRepository.getMenuListByDate(
              mockStateTime, mockEndTime)).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits failure status when load menu event fail',
        setUp: () {
          when(() => historyRepository.getMenuListByDate(
                  mockStateTime, mockEndTime))
              .thenAnswer((_) async => throw Exception());
        },
        build: () => historyBloc,
        act: (bloc) => bloc.add(LoadMenuList(dateTime: mockDateMenuList)),
        expect: () => <HistoryState>[
          HistoryState(
            status: HistoryStatus.failure,
            dateMenuList: historyBloc.state.dateMenuList,
          )
        ],
        verify: (_) {
          verify(() => historyRepository.getMenuListByDate(
              mockStateTime, mockEndTime)).called(1);
        },
      );
    });
  });
}
