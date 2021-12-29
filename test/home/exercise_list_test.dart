import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/home/exercise_list.dart';

void main() {
  const homeExerciseListKey = Key('home_exercise_list');

  group('Exercise List', () {
    testWidgets('can render', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ExerciseList(),
      ));
      expect(find.byKey(homeExerciseListKey), findsOneWidget);
    });
  });
}
