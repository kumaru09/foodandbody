import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockPlan extends Mock implements History {}

void main() {
  group('PlanState', () {
    group('PlanInitial', () {
      test('get correct value', () {
        final state = PlanInitial();
        expect(state.props, []);
      });
    });

    group('PlanLoading', () {
      test('get correct value', () {
        final state = PlanLoading();
        expect(state.props, []);
      });
    });

    group('PlanLoaded', () {
      test('get correct value', () {
        final plan = MockPlan();
        final state = PlanLoaded(plan);
        expect(state.plan, plan);
      });
    });

    group('PlanError', () {
      test('get correct value', () {
        final state = PlanError();
        expect(state.props, []);
      });
    });
  });
}
