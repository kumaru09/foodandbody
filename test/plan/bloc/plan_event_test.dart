import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';

void main() {
  group('PlanEvent', () {
    test('LoadPlan supports value comparisons',
        () => {expect(LoadPlan(), LoadPlan())});
  });
}
