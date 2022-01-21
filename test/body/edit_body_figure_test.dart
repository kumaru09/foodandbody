import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/screens/body/edit_body_figure.dart';
import 'package:mocktail/mocktail.dart';

class MockBody extends Mock implements Body {}
void main() {
  const bodyCloseButtonKey = Key("body_close_button");
  const bodySaveButtonKey = Key("body_save_button");

  const bodyEditShoulderTextFieldKey = Key("body_edit_shoulder_text_filed");
  const bodyEditChestTextFieldKey = Key("body_edit_chest_text_filed");
  const bodyEditWaistTextFieldKey = Key("body_edit_waist_text_filed");
  const bodyEditHipTextFieldKey = Key("body_edit_hip_text_filed");

  group("Edit Body Figure Page", () {
    late Body body;

    setUp(() {
      body = MockBody();
      when(() => body.shoulder).thenReturn(42);
      when(() => body.chest).thenReturn(79);
      when(() => body.waist).thenReturn(68);
      when(() => body.hip).thenReturn(86);
    });
    group("can render", () { 
      testWidgets("บันทึก button and close button", (tester) async {
        await tester.pumpWidget(MaterialApp(home: EditBodyFigure(body: body)));
        expect(find.byKey(bodyCloseButtonKey), findsOneWidget);
        expect(find.byKey(bodySaveButtonKey), findsOneWidget);
      });

      testWidgets("edit shoulder text filed", (tester) async {
        await tester.pumpWidget(MaterialApp(home: EditBodyFigure(body: body)));
        final TextFormField findTextField = tester.widget(find.byKey(bodyEditShoulderTextFieldKey));
        expect(find.byKey(bodyEditShoulderTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, body.shoulder.toString());
      });

      testWidgets("edit chest text filed", (tester) async {
        await tester.pumpWidget(MaterialApp(home: EditBodyFigure(body: body)));
        final TextFormField findTextField = tester.widget(find.byKey(bodyEditChestTextFieldKey));
        expect(find.byKey(bodyEditChestTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, body.chest.toString());
      });

      testWidgets("edit waist text filed", (tester) async {
        await tester.pumpWidget(MaterialApp(home: EditBodyFigure(body: body)));
        final TextFormField findTextField = tester.widget(find.byKey(bodyEditWaistTextFieldKey));
        expect(find.byKey(bodyEditWaistTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, body.waist.toString());
      });

      testWidgets("edit hip text filed", (tester) async {
        await tester.pumpWidget(MaterialApp(home: EditBodyFigure(body: body)));
        final TextFormField findTextField = tester.widget(find.byKey(bodyEditHipTextFieldKey));
        expect(find.byKey(bodyEditHipTextFieldKey), findsOneWidget);
        expect(findTextField.initialValue, body.hip.toString());
      });
    });
  });
}