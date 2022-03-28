import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/edit_body_figure.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockBody extends Mock implements Body {}

class MockBodyCubit extends MockCubit<BodyState> implements BodyCubit {}

class FakeBodyState extends Fake implements BodyState {}

class MockBodyFigure extends Mock implements BodyFigure {}

void main() {
  const validShoulderString = '30';
  const validShoulder = BodyFigure.dirty(validShoulderString);

  const validChestString = '30';
  const validChest = BodyFigure.dirty(validChestString);

  const validWaistString = '30';
  const validWaist = BodyFigure.dirty(validWaistString);

  const validHipString = '30';
  const validHip = BodyFigure.dirty(validHipString);

  const bodyCloseButtonKey = Key("body_close_button");
  const bodySaveButtonKey = Key("body_save_button");

  const bodyEditShoulderTextFieldKey = Key("body_edit_shoulder_text_filed");
  const bodyEditChestTextFieldKey = Key("body_edit_chest_text_filed");
  const bodyEditWaistTextFieldKey = Key("body_edit_waist_text_filed");
  const bodyEditHipTextFieldKey = Key("body_edit_hip_text_filed");

  group("Edit Body Figure Page", () {
    late BodyCubit bodyCubit;

    setUpAll(() {
      registerFallbackValue<BodyState>(FakeBodyState());
    });

    setUp(() {
      bodyCubit = MockBodyCubit();
      when(() => bodyCubit.state).thenReturn(BodyState(
          shoulder: validShoulder,
          chest: validChest,
          waist: validWaist,
          hip: validHip));
    });
    group("renders", () {
      testWidgets("close button and save button with disable when initial",
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        expect(find.byKey(bodyCloseButtonKey), findsOneWidget);
        expect(find.byKey(bodySaveButtonKey), findsOneWidget);
        final TextButton saveButton =
            tester.widget(find.byKey(bodySaveButtonKey));
        expect(saveButton.enabled, isFalse);
      });

      testWidgets("edit shoulder text filed when initial", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        final TextFormField findTextField =
            tester.widget(find.byKey(bodyEditShoulderTextFieldKey));
        expect(find.byKey(bodyEditShoulderTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, validShoulderString);
      });

      testWidgets("edit chest text filed when initial", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        final TextFormField findTextField =
            tester.widget(find.byKey(bodyEditChestTextFieldKey));
        expect(find.byKey(bodyEditChestTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, validChestString);
      });

      testWidgets("edit waist text filed when initial", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        final TextFormField findTextField =
            tester.widget(find.byKey(bodyEditWaistTextFieldKey));
        expect(find.byKey(bodyEditWaistTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, validWaistString);
      });

      testWidgets("edit hip text filed when initial", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        final TextFormField findTextField =
            tester.widget(find.byKey(bodyEditHipTextFieldKey));
        expect(find.byKey(bodyEditHipTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, validHipString);
      });

      testWidgets('invalid shoulder error text when shoulder is invalid',
          (tester) async {
        final shoulder = MockBodyFigure();
        when(() => shoulder.invalid).thenReturn(true);
        when(() => bodyCubit.state).thenReturn(BodyState(shoulder: shoulder));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditBodyFigure(
                  shoulder: int.parse(validShoulderString),
                  chest: int.parse(validChestString),
                  waist: int.parse(validWaistString),
                  hip: int.parse(validHipString),
                ),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุไหล่ให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets('invalid chest error text when chest is invalid',
          (tester) async {
        final chest = MockBodyFigure();
        when(() => chest.invalid).thenReturn(true);
        when(() => bodyCubit.state).thenReturn(BodyState(chest: chest));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditBodyFigure(
                  shoulder: int.parse(validShoulderString),
                  chest: int.parse(validChestString),
                  waist: int.parse(validWaistString),
                  hip: int.parse(validHipString),
                ),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุรอบอกให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets('invalid waist error text when waist is invalid',
          (tester) async {
        final waist = MockBodyFigure();
        when(() => waist.invalid).thenReturn(true);
        when(() => bodyCubit.state).thenReturn(BodyState(waist: waist));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditBodyFigure(
                  shoulder: int.parse(validShoulderString),
                  chest: int.parse(validChestString),
                  waist: int.parse(validWaistString),
                  hip: int.parse(validHipString),
                ),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุรอบเอวให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets('invalid hip error text when hip is invalid', (tester) async {
        final hip = MockBodyFigure();
        when(() => hip.invalid).thenReturn(true);
        when(() => bodyCubit.state).thenReturn(BodyState(hip: hip));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditBodyFigure(
                  shoulder: int.parse(validShoulderString),
                  chest: int.parse(validChestString),
                  waist: int.parse(validWaistString),
                  hip: int.parse(validHipString),
                ),
              ),
            ),
          ),
        );
        expect(find.text('กรุณาระบุรอบสะโพกให้ถูกต้อง'), findsOneWidget);
      });

      testWidgets("disabled save button when status is not validated",
          (tester) async {
        when(() => bodyCubit.state).thenReturn(
          BodyState(editBodyStatus: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        final TextButton saveButton =
            tester.widget(find.byKey(bodySaveButtonKey));
        expect(saveButton.enabled, isTrue);
      });

      testWidgets("enabled save button when status is validated",
          (tester) async {
        when(() => bodyCubit.state).thenReturn(
          BodyState(editBodyStatus: FormzStatus.valid),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        final TextButton saveButton =
            tester.widget(find.byKey(bodySaveButtonKey));
        expect(saveButton.enabled, isTrue);
      });

      // testWidgets("failure Dialog when submission fails",
      //     (tester) async {
      //       when(() => bodyCubit.state).thenReturn(
      //     BodyState(editBodyStatus: FormzStatus.submissionFailure),
      //   );
      //   await tester.pumpWidget(
      //     MaterialApp(
      //       home: BlocProvider.value(
      //         value: bodyCubit,
      //         child: EditBodyFigure(
      //           shoulder: int.parse(validShoulderString),
      //           chest: int.parse(validChestString),
      //           waist: int.parse(validWaistString),
      //           hip: int.parse(validHipString),
      //         ),
      //       ),
      //     ),
      //   );
      //   await tester.pumpAndSettle();
      //   expect(find.byType(AlertDialog), findsOneWidget);
      //   expect(find.text('กรอกข้อมูลไม่สำเร็จ'), findsOneWidget);
      //   expect(find.text('กรุณาลองอีกครั้ง'), findsOneWidget);
      // });
    });

    group('calls', () {
      testWidgets("shoulderChanged when shoulder changes", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(bodyEditShoulderTextFieldKey), '50');
        verify(() => bodyCubit.shoulderChanged('50')).called(1);
      });

      testWidgets("chestChanged when chest changes", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(bodyEditChestTextFieldKey), '50');
        verify(() => bodyCubit.chestChanged('50')).called(1);
      });

      testWidgets("waistChanged when waist changes", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(bodyEditWaistTextFieldKey), '50');
        verify(() => bodyCubit.waistChanged('50')).called(1);
      });

      testWidgets("hipChanged when hip changes", (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(bodyEditHipTextFieldKey), '50');
        verify(() => bodyCubit.hipChanged('50')).called(1);
      });

      testWidgets('updateBody when save button is pressed', (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(editBodyStatus: FormzStatus.valid));
        when(() => bodyCubit.updateBody()).thenAnswer((_) async {});
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: EditBodyFigure(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(bodySaveButtonKey));
        verify(() => bodyCubit.updateBody()).called(1);
      });
    });
  });
}
