import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanRepository extends Mock implements PlanRepository {}

void main() {
  group('HomeBloc', () {
    late PlanRepository planRepository;
    late HomeBloc homeBloc;

    setUp(() {
      planRepository = MockPlanRepository();
      homeBloc = HomeBloc(planRepository: planRepository);
    });

    test('initial state is HomeState()', () {
      expect(homeBloc.state, HomeState());
    });

    blocTest<HomeBloc, HomeState>(
      'IncreaseWaterEvent emits water increase 1 times',
      build: () => homeBloc,
      act: (bloc) => bloc.add(IncreaseWaterEvent()),
      expect: () => <HomeState>[HomeState(water: 1)],
    );

    blocTest<HomeBloc, HomeState>(
      'IncreaseWaterEvent 2 times emits water increase 2 times',
      build: () => homeBloc,
      act: (bloc) => bloc
        ..add(IncreaseWaterEvent())
        ..add(IncreaseWaterEvent()),
      expect: () => <HomeState>[HomeState(water: 1), HomeState(water: 2)],
    );

    blocTest<HomeBloc, HomeState>(
      'DecreaseWaterEvent emits water decrease 1 times',
      seed: () => HomeState(water: 1),
      build: () => homeBloc,
      act: (bloc) => bloc.add(DecreaseWaterEvent()),
      expect: () => <HomeState>[HomeState(water: 0)],
    );

    blocTest<HomeBloc, HomeState>(
      'DecreaseWaterEvent 2 times emits water decrease 2 times',
      seed: () => HomeState(water: 2),
      build: () => homeBloc,
      act: (bloc) => bloc
        ..add(DecreaseWaterEvent())
        ..add(DecreaseWaterEvent()),
      expect: () => <HomeState>[HomeState(water: 1), HomeState(water: 0)],
    );

    blocTest<HomeBloc, HomeState>(
      'DecreaseWaterEvent 2 times and current water is 1 emits water decrease 1 times',
      seed: () => HomeState(water: 1),
      build: () => homeBloc,
      act: (bloc) => bloc
        ..add(DecreaseWaterEvent())
        ..add(DecreaseWaterEvent()),
      expect: () => <HomeState>[HomeState(water: 0)],
    );

    blocTest<HomeBloc, HomeState>(
      'DecreaseWaterEvent emits nothing when current water is 0',
      seed: () => HomeState(water: 0),
      build: () => homeBloc,
      act: (bloc) => bloc.add(DecreaseWaterEvent()),
      expect: () => <HomeState>[],
    );

    blocTest<HomeBloc, HomeState>(
      'LoadWater emits success status when initial load water',
      setUp: () {
        when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
      },
      build: () => homeBloc,
      act: (bloc) => bloc.add(LoadWater()),
      expect: () => <HomeState>[
        HomeState(status: HomeStatus.loading),
        HomeState(
          status: HomeStatus.success,
          water: 1,
        )
      ],
      verify: (_) {
        verify(() => planRepository.getWaterPlan()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'LoadWater emits loading status during load',
      setUp: () {
        when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
      },
      build: () => homeBloc,
      act: (bloc) => bloc.add(LoadWater()),
      expect: () => <HomeState>[
        HomeState(status: HomeStatus.loading),
        HomeState(
          status: HomeStatus.success,
          water: 1,
        )
      ],
      verify: (_) {
        verify(() => planRepository.getWaterPlan()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      "LoadWater don't emits loading status during load when isRefresh is true",
      setUp: () {
        when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
      },
      build: () => homeBloc,
      act: (bloc) => bloc.add(LoadWater(isRefresh: true)),
      expect: () => <HomeState>[
        HomeState(
          status: HomeStatus.success,
          water: 1,
        )
      ],
      verify: (_) {
        verify(() => planRepository.getWaterPlan()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'LoadWater emits failure status when load water fail',
      setUp: () {
        when(() => planRepository.getWaterPlan())
            .thenAnswer((_) async => throw Exception());
      },
      build: () => homeBloc,
      act: (bloc) => bloc.add(LoadWater()),
      expect: () => <HomeState>[
        HomeState(status: HomeStatus.loading),
        HomeState(status: HomeStatus.failure)
      ],
      verify: (_) {
        verify(() => planRepository.getWaterPlan()).called(1);
      },
    );

    group('WaterChanged', () {
      blocTest<HomeBloc, HomeState>(
        'emits successful status when water change',
        setUp: () {
          when(() => planRepository.addWaterPlan(1)).thenAnswer((_) async {});
          when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
        },
        build: () => homeBloc,
        act: (bloc) => bloc.add(WaterChanged(water: 1)),
        wait: const Duration(milliseconds: 1000),
        expect: () => <HomeState>[
          HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            water: 1,
          )
        ],
        verify: (_) {
          verify(() => planRepository.addWaterPlan(1)).called(1);
          verify(() => planRepository.getWaterPlan()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => planRepository.addWaterPlan(1)).thenAnswer((_) async {});
          when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
        },
        build: () => homeBloc,
        act: (bloc) => bloc
          ..add(WaterChanged(water: 1))
          ..add(WaterChanged(water: 1)),
        wait: const Duration(milliseconds: 1000),
        expect: () => <HomeState>[
          HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            water: 1,
          )
        ],
        verify: (_) {
          verify(() => planRepository.addWaterPlan(1)).called(1);
          verify(() => planRepository.getWaterPlan()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'throttles events',
        setUp: () {
          when(() => planRepository.addWaterPlan(1)).thenAnswer((_) async {});
          when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
        },
        build: () => homeBloc,
        act: (bloc) async {
          bloc.add(WaterChanged(water: 1));
          await Future<void>.delayed(Duration.zero);
          bloc.add(WaterChanged(water: 1));
        },
        wait: const Duration(milliseconds: 1000),
        expect: () => <HomeState>[
          HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            water: 1,
          )
        ],
        verify: (_) {
          verify(() => planRepository.addWaterPlan(1)).called(1);
          verify(() => planRepository.getWaterPlan()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits failure status when addWaterPlan throw exception',
        setUp: () {
          when(() => planRepository.addWaterPlan(1)).thenAnswer((_) async => throw Exception());
          when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
        },
        build: () => homeBloc,
        act: (bloc) => bloc.add(WaterChanged(water: 1)),
        wait: const Duration(milliseconds: 1000),
        expect: () => <HomeState>[
          HomeState(status: HomeStatus.loading),
          HomeState(status: HomeStatus.failure)
        ],
        verify: (_) {
          verify(() => planRepository.addWaterPlan(1)).called(1);
          verifyNever(() => planRepository.getWaterPlan());
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits failure status when getWaterPlan throw exception',
        setUp: () {
          when(() => planRepository.addWaterPlan(1)).thenAnswer((_) async {});
          when(() => planRepository.getWaterPlan()).thenAnswer((_) async => throw Exception());
        },
        build: () => homeBloc,
        act: (bloc) => bloc.add(WaterChanged(water: 1)),
        wait: const Duration(milliseconds: 1000),
        expect: () => <HomeState>[
          HomeState(status: HomeStatus.loading),
          HomeState(status: HomeStatus.failure)
        ],
        verify: (_) {
          verify(() => planRepository.addWaterPlan(1)).called(1);
          verify(() => planRepository.getWaterPlan()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits loading status when during process',
        setUp: () {
          when(() => planRepository.addWaterPlan(1)).thenAnswer((_) async {});
          when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
        },
        build: () => homeBloc,
        act: (bloc) => bloc.add(WaterChanged(water: 1)),
        wait: const Duration(milliseconds: 1000),
        expect: () => <HomeState>[
          HomeState(status: HomeStatus.loading),
          HomeState(
            status: HomeStatus.success,
            water: 1,
          )
        ],
        verify: (_) {
          verify(() => planRepository.addWaterPlan(1)).called(1);
          verify(() => planRepository.getWaterPlan()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'debounce 1000 milliseconds',
        setUp: () {
          when(() => planRepository.addWaterPlan(1)).thenAnswer((_) async {});
          when(() => planRepository.getWaterPlan()).thenAnswer((_) async => 1);
        },
        build: () => homeBloc,
        act: (bloc) => bloc.add(WaterChanged(water: 1)),
        wait: const Duration(milliseconds: 900),
        expect: () => <HomeState>[],
        verify: (_) {
          verifyNever(() => planRepository.addWaterPlan(1));
          verifyNever(() => planRepository.getWaterPlan());
        },
      );
    });
  });
}
