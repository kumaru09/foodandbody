import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPlan extends Mock implements History {}

class MockPlanRepository extends Mock implements PlanRepository {}

void main() {
  group('PlanBloc', () {
    final History plan = MockPlan();
    late PlanRepository planRepository;

    setUp(() {
      planRepository = MockPlanRepository();
    });

    blocTest<PlanBloc, PlanState>('emit PlanLoaded when into home page',
        build: () {
          when(() => planRepository.getPlanById())
              .thenAnswer((_) => Future(() => plan));
          return PlanBloc(planRepository: planRepository);
        },
        seed: () => PlanLoading(),
        act: (bloc) => bloc.add(LoadPlan()),
        expect: () => [PlanLoaded(plan)]);

    blocTest<PlanBloc, PlanState>('emit PlanError when catch exception',
        build: () {
          return PlanBloc(planRepository: planRepository);
        },
        seed: () => PlanLoading(),
        act: (bloc) => bloc.add(LoadPlan()),
        expect: () => [PlanError()]);
  });
}
