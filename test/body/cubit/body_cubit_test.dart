import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyRepository extends Mock implements BodyRepository {}

class FakeBody extends Fake implements Body {}

void main() {
  group('BodyCubit', () {
    final Timestamp mockDate = Timestamp.fromDate(DateTime.now());
    final Body mockBody =
        Body(date: mockDate, shoulder: 30, chest: 30, waist: 30, hip: 30);
    final List<WeightList> mockWeightList = [
      WeightList(weight: 50, date: mockDate)
    ];

    late BodyRepository bodyRepository;
    late BodyCubit bodyCubit;

    setUp(() {
      bodyRepository = MockBodyRepository();
      bodyCubit = BodyCubit(bodyRepository);
    });

    setUpAll(() {
      registerFallbackValue<Body>(FakeBody());
    });

    test('initial state is BodyState()', () {
      expect(BodyCubit(bodyRepository).state, BodyState());
    });

    group('fetchBody', () {
      blocTest<BodyCubit, BodyState>(
        'emits successful status when fetched initial body',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[
          BodyState(
            status: BodyStatus.success,
            body: mockBody,
            weightList: mockWeightList,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits successful status when fetched empty data',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => Body.empty);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => []);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[
          BodyState(
            status: BodyStatus.success,
            body: Body.empty,
            weightList: [],
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when bodyRepository getBodyLatest throw exception',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => throw Exception());
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[BodyState(status: BodyStatus.failure)],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verifyNever(() => bodyRepository.getWeightList());
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when bodyRepository getWeightList throw exception',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[BodyState(status: BodyStatus.failure)],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );
    });

    group('updateWeight', () {
      blocTest<BodyCubit, BodyState>(
        'emits successful status',
        setUp: () {
          when(() => bodyRepository.addWeight(50)).thenAnswer((_) async => {});
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateWeight(50),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(
            status: BodyStatus.success,
            weightList: mockWeightList,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.addWeight(50)).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits loading status during updateWeight',
        setUp: () {
          when(() => bodyRepository.addWeight(50)).thenAnswer((_) async => {});
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateWeight(50),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(
            status: BodyStatus.success,
            weightList: mockWeightList,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.addWeight(50)).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );
    });

    group('updateBody', () {
      blocTest<BodyCubit, BodyState>(
        'emits successful status',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => {});
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateBody('30', '30', '30', '30'),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(
            status: BodyStatus.success,
            body: bodyCubit.state.body,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
          verify(() => bodyRepository.getBodyLatest()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits successful status when 0 data',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => {});
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateBody('0', '0', '0', '0'),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(
            status: BodyStatus.success,
            body: bodyCubit.state.body,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
          verify(() => bodyRepository.getBodyLatest()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits loading status during update body',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => {});
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateBody('30', '30', '30', '30'),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(
            status: BodyStatus.success,
            body: bodyCubit.state.body,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
          verify(() => bodyRepository.getBodyLatest()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when updateBody throw exception',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => throw Exception());
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateBody('30', '30', '30', '30'),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(status: BodyStatus.failure)
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
          verifyNever(() => bodyRepository.getBodyLatest());
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when getBodyLatest throw exception',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => {});
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateBody('30', '30', '30', '30'),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(status: BodyStatus.failure)
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
          verify(() => bodyRepository.getBodyLatest()).called(1);
        },
      );
    });
  });
}
