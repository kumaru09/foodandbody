import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyCubit extends MockCubit<BodyState> implements BodyCubit {}

class FakeBodyState extends Fake implements BodyState {}

class MockBodyRepository extends Mock implements BodyRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  final mockWeightList = [
    WeightList(weight: 55, date: Timestamp.now()),
    WeightList(weight: 56, date: Timestamp.now()),
    WeightList(weight: 57, date: Timestamp.now()),
    WeightList(weight: 56, date: Timestamp.now()),
    WeightList(weight: 54, date: Timestamp.now()),
  ];

  const int height = 164;
  const Height mockHeight = Height.dirty('164');
  const Weight mockWeight = Weight.dirty('55');

  const testWeight = '55';
  const testHeight = '164';

  const bodyWeightCardKey = Key("body_weight_card");
  const bodyWeightGraphKey = Key("body_weight_graph");
  const bodyEditWeightButtonKey = Key("body_edit_weight_button");
  const bodyHeightCardKey = Key("body_height_card");
  const bodyEditHeightButtonKey = Key("body_edit_height_button");
  const bodyBmiCardKey = Key("body_bmi_card");

  const bodyEditWeightDialogKey = Key("body_edit_weight_dialog");
  const bodyEditWeightDialogTextFieldKey =
      Key("body_edit_weight_dialog_text_field");
  const bodyEditWeightDialogSaveButtonKey =
      Key("body_edit_weight_dialog_save_button");
  const bodyEditWeightDialogCancelButtonKey =
      Key("body_edit_weight_dialog_cancel_button");

  const bodyEditHeightDialogKey = Key("body_edit_height_dialog");
  const bodyEditHeightDialogTextFieldKey =
      Key("body_edit_height_dialog_text_field");
  const bodyEditHeightDialogSaveButtonKey =
      Key("body_edit_height_dialog_save_button");
  const bodyEditHeightDialogCancelButtonKey =
      Key("body_edit_height_dialog_cancel_button");

  group("Weight and Height Info", () {
    late BodyCubit bodyCubit;

    setUpAll(() {
      registerFallbackValue<BodyState>(FakeBodyState());
    });

    setUp(() {
      bodyCubit = MockBodyCubit();
    });

    group("can render", () {
      testWidgets("weight card", (tester) async {
        when(() => bodyCubit.state).thenReturn(
            BodyState(status: BodyStatus.success, weightList: mockWeightList));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: WeightAndHeightInfo(height, mockWeightList),
              ),
            ),
          ),
        );
        expect(find.byKey(bodyWeightCardKey), findsOneWidget);
        expect(
            find.text(mockWeightList.first.weight.toString()), findsOneWidget);
        expect(
            find.text(
                "วันที่ " + DateFormat("dd/MM/yyyy").format(DateTime.now())),
            findsOneWidget);
        expect(find.byKey(bodyWeightGraphKey), findsOneWidget);
        expect(find.byKey(bodyEditWeightButtonKey), findsOneWidget);
      });

      testWidgets("height card", (tester) async {
        when(() => bodyCubit.state).thenReturn(
            BodyState(status: BodyStatus.success, height: mockHeight));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: WeightAndHeightInfo(height, mockWeightList),
              ),
            ),
          ),
        );
        expect(find.byKey(bodyHeightCardKey), findsOneWidget);
        expect(find.text(height.toString()), findsOneWidget);
        expect(find.byKey(bodyEditHeightButtonKey), findsOneWidget);
      });

      testWidgets("BMI card", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            weightList: mockWeightList,
            height: mockHeight));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: WeightAndHeightInfo(height, mockWeightList),
              ),
            ),
          ),
        );
        final double expectBMI = double.parse(
            (mockWeightList.first.weight / pow(height / 100, 2))
                .toStringAsFixed(2));
        expect(find.byKey(bodyBmiCardKey), findsOneWidget);
        expect(find.text(expectBMI.toString()), findsOneWidget);
      });

      testWidgets(
          "CircularProgressIndicator when weightStatus is submissionInProgress",
          (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            weightStatus: FormzStatus.submissionInProgress,
            weightList: mockWeightList,
            height: mockHeight));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: WeightAndHeightInfo(height, mockWeightList),
              ),
            ),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets(
          "CircularProgressIndicator when heightStatus is submissionInProgress",
          (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            heightStatus: FormzStatus.submissionInProgress,
            weightList: mockWeightList,
            height: mockHeight));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: WeightAndHeightInfo(height, mockWeightList),
              ),
            ),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group("when press", () {
      testWidgets("แก้ไข button in weight card", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            weightList: mockWeightList,
            height: mockHeight));
        await tester.pumpWidget(
          RepositoryProvider<BodyRepository>(
            create: (_) => MockBodyRepository(),
            child: RepositoryProvider<UserRepository>(
              create: (_) => MockUserRepository(),
              child: MaterialApp(
                home: Scaffold(
                  body: BlocProvider.value(
                    value: bodyCubit,
                    child: WeightAndHeightInfo(height, mockWeightList),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(bodyEditWeightButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditWeightDialogKey), findsOneWidget);
        expect(find.text("แก้ไขน้ำหนัก"), findsOneWidget);
        expect(find.byKey(bodyEditWeightDialogTextFieldKey), findsOneWidget);
        expect(find.byKey(bodyEditWeightDialogSaveButtonKey), findsOneWidget);
        expect(find.byKey(bodyEditWeightDialogCancelButtonKey), findsOneWidget);
        await tester.tap(find.byKey(bodyEditWeightDialogCancelButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditWeightDialogKey), findsNothing);
      });

      testWidgets("แก้ไข button in height card", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            weightList: mockWeightList,
            height: mockHeight));
        await tester.pumpWidget(
          RepositoryProvider<BodyRepository>(
            create: (_) => MockBodyRepository(),
            child: RepositoryProvider<UserRepository>(
              create: (_) => MockUserRepository(),
              child: MaterialApp(
                home: Scaffold(
                  body: BlocProvider.value(
                    value: bodyCubit,
                    child: WeightAndHeightInfo(height, mockWeightList),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(bodyEditHeightButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditHeightDialogKey), findsOneWidget);
        expect(find.text("แก้ไขส่วนสูง"), findsOneWidget);
        expect(find.byKey(bodyEditHeightDialogTextFieldKey), findsOneWidget);
        expect(find.byKey(bodyEditHeightDialogSaveButtonKey), findsOneWidget);
        expect(find.byKey(bodyEditHeightDialogCancelButtonKey), findsOneWidget);
        await tester.tap(find.byKey(bodyEditHeightDialogCancelButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(bodyEditHeightDialogKey), findsNothing);
      });
    });

    group("EditWeightDialog", () {
      testWidgets("can render", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState());
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditWeightDialog(),
              ),
            ),
          ),
        );
        expect(find.byType(EditWeightDialog), findsOneWidget);
        expect(find.text('แก้ไขน้ำหนัก'), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets("call weightChanged when weight change", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
          weightList: mockWeightList,
          weight: mockWeight,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditWeightDialog(),
              ),
            ),
          ),
        );
        await tester.enterText(
            find.byKey(bodyEditWeightDialogTextFieldKey), testWeight);
        verify(() => bodyCubit.weightChanged(testWeight)).called(1);
      });

      testWidgets("disabled save button when weightStatus is not validated", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
          weightStatus: FormzStatus.invalid
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditWeightDialog(),
              ),
            ),
          ),
        );
        final weightOkButton = tester.widget<TextButton>(
          find.byKey(bodyEditWeightDialogSaveButtonKey),
        );
        expect(weightOkButton.enabled, isFalse);
      });

      testWidgets("enabled save button when weightStatus is validated", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
          weightStatus: FormzStatus.valid,
          weightList: mockWeightList,
          weight: mockWeight,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditWeightDialog(),
              ),
            ),
          ),
        );
        final weightOkButton = tester.widget<TextButton>(
          find.byKey(bodyEditWeightDialogSaveButtonKey),
        );
        expect(weightOkButton.enabled, isTrue);
      });
    });

    group("EditHeightDialog", () {
      testWidgets("can render", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState());
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditHeightDialog(),
              ),
            ),
          ),
        );
        expect(find.byType(EditHeightDialog), findsOneWidget);
        expect(find.text('แก้ไขส่วนสูง'), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets("call heightChanged when height change", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
          height: mockHeight,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditHeightDialog(),
              ),
            ),
          ),
        );
        await tester.enterText(
            find.byKey(bodyEditHeightDialogTextFieldKey), testHeight);
        verify(() => bodyCubit.heightChanged(testHeight)).called(1);
      });

      testWidgets("disabled save button when heightStatus is not validated", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
          heightStatus: FormzStatus.invalid
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditHeightDialog(),
              ),
            ),
          ),
        );
        final heightOkButton = tester.widget<TextButton>(
          find.byKey(bodyEditHeightDialogSaveButtonKey),
        );
        expect(heightOkButton.enabled, isFalse);
      });

      testWidgets("enabled save button when weightStatus is validated", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
          heightStatus: FormzStatus.valid,
          height: mockHeight,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: bodyCubit,
                child: EditHeightDialog(),
              ),
            ),
          ),
        );
        final heightOkButton = tester.widget<TextButton>(
          find.byKey(bodyEditHeightDialogSaveButtonKey),
        );
        expect(heightOkButton.enabled, isTrue);
      });
    });
  });
}
