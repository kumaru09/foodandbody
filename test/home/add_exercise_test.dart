import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/home/add_exercise.dart';

void main() {
  const homeAddExerciseButtonKey = Key('home_add_exercise_button');
  const homeAddExerciseDialogKey = Key("home_add_exercise_dialog");
  const activityDropdownKey = Key("activity_select_dropdown");
  const timeTextFiledKey = Key("time_text_field");
  const addExerciseDialogOkButtonKey = Key("add_exercise_dialog_ok_button");
  const addExerciseDialogCancelButtonKey =
      Key("add_exercise_dialog_cancel_button");

  group('Add Exercise Button', () {
    testWidgets("can render", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddExerciseButton(),
      ));
      expect(find.byKey(homeAddExerciseButtonKey), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text("เพิ่มการออกกำลังกาย"), findsOneWidget);
    }); //"can render"

    testWidgets("when press เพิ่มการออกกำลังกาย button", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddExerciseButton(),
      ));
      await tester.tap(find.byKey(homeAddExerciseButtonKey));
      await tester.pumpAndSettle();
      expect(find.byKey(homeAddExerciseDialogKey), findsOneWidget);
      expect(find.byKey(activityDropdownKey), findsOneWidget);
      expect(find.byKey(timeTextFiledKey), findsOneWidget);
      expect(find.byKey(addExerciseDialogOkButtonKey), findsOneWidget);
      expect(find.byKey(addExerciseDialogCancelButtonKey), findsOneWidget);
    }); //"when press เพิ่มการออกกำลังกาย button"

    testWidgets("when press ยกเลิก button", (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddExerciseButton()));
      await tester.tap(find.byKey(homeAddExerciseButtonKey));
      await tester.pumpAndSettle();
      expect(find.byKey(homeAddExerciseDialogKey), findsOneWidget);
      await tester.tap(find.byKey(addExerciseDialogCancelButtonKey));
      await tester.pumpAndSettle();
      expect(find.byKey(homeAddExerciseDialogKey), findsNothing);
    });
  });
}
