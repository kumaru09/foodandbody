import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/edit_body_figure.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyCubit extends Mock implements BodyCubit {}

class FakeBodyState extends Fake implements BodyState {}

class MockBody extends Mock implements Body {}

void main() {
  const bodyFigureImageKey = Key('body_figure_image');
  const bodyShoulderPointerKey = Key('body_shoulder_pointer');
  const bodyChestPointerKey = Key('body_chest_pointer');
  const bodyWaistPointerKey = Key('body_waist_pointer');
  const bodyHipPointerKey = Key('body_hip_pointer');
  const bodyFigureInfoEditButtonKey = Key("body_figure_info_edit_button");

  group("Body Figure Info", () {
    late BodyCubit bodyCubit;
    late Body body;

    setUpAll(() {
      registerFallbackValue<BodyState>(FakeBodyState());
    });

    setUpAll(() {
      bodyCubit = MockBodyCubit();
      body = MockBody();
      when(() => body.shoulder).thenReturn(42);
      when(() => body.chest).thenReturn(79);
      when(() => body.waist).thenReturn(68);
      when(() => body.hip).thenReturn(89);
      when(() => body.date).thenReturn(Timestamp.fromDate(DateTime.now()));
      when(() => bodyCubit.state)
          .thenReturn(BodyState(status: BodyStatus.success, body: body));
    });

    group("can render", () {
      testWidgets("figure image", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [BlocProvider.value(value: bodyCubit)],
            child: SingleChildScrollView(
              child: BodyFigureInfo(body),
            ),
          ),
        ));
        expect(find.byKey(bodyFigureImageKey), findsOneWidget);
      });

      testWidgets("line and pointer", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [BlocProvider.value(value: bodyCubit)],
            child: SingleChildScrollView(
              child: BodyFigureInfo(body),
            ),
          ),
        ));
        expect(find.byKey(bodyShoulderPointerKey), findsOneWidget);
        expect(find.byKey(bodyChestPointerKey), findsOneWidget);
        expect(find.byKey(bodyWaistPointerKey), findsOneWidget);
        expect(find.byKey(bodyHipPointerKey), findsOneWidget);
      });

      testWidgets("body figure description", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [BlocProvider.value(value: bodyCubit)],
            child: SingleChildScrollView(
              child: BodyFigureInfo(body),
            ),
          ),
        ));
        expect(find.text("ไหล่"), findsOneWidget);
        expect(find.text("รอบอก"), findsOneWidget);
        expect(find.text("รอบเอว"), findsOneWidget);
        expect(find.text("รอบสะโพก"), findsOneWidget);
        expect(find.text(body.shoulder.toString()), findsOneWidget);
        expect(find.text(body.chest.toString()), findsOneWidget);
        expect(find.text(body.waist.toString()), findsOneWidget);
        expect(find.text(body.hip.toString()), findsOneWidget);
        expect(find.text("เซนติเมตร"), findsNWidgets(4));
      });

      testWidgets("date", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [BlocProvider.value(value: bodyCubit)],
            child: SingleChildScrollView(
              child: BodyFigureInfo(body),
            ),
          ),
        ));
        expect(
            find.text("วันที่ " +
                DateFormat("dd/MM/yyyy HH:mm").format(body.date.toDate())),
            findsOneWidget);
      });

      testWidgets("แก้ไข button", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [BlocProvider.value(value: bodyCubit)],
            child: SingleChildScrollView(
              child: BodyFigureInfo(body),
            ),
          ),
        ));
        expect(find.byKey(bodyFigureInfoEditButtonKey), findsOneWidget);
      });
    });

    testWidgets("when not have body figure info", (tester) async {
      when(() => body.shoulder).thenReturn(0);
      when(() => body.chest).thenReturn(0);
      when(() => body.waist).thenReturn(0);
      when(() => body.hip).thenReturn(0);
      await tester.pumpWidget(MaterialApp(
        home: MultiBlocProvider(
          providers: [BlocProvider.value(value: bodyCubit)],
          child: SingleChildScrollView(
            child: BodyFigureInfo(body),
          ),
        ),
      )); 
      expect(find.text("-"), findsNWidgets(4));
      expect(find.text("เซนติเมตร"), findsNWidgets(4));
      expect(
          find.text(
              "วันที่ " + DateFormat("dd/MM/yyyy HH:mm").format(body.date.toDate())),
          findsOneWidget);
    });

    testWidgets("when tap แก้ไข button", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MultiBlocProvider(
          providers: [BlocProvider.value(value: bodyCubit)],
          child: SingleChildScrollView(
            child: BodyFigureInfo(body),
          ),
        ),
      ));
      await tester.dragFrom(Offset(0, 300), Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(bodyFigureInfoEditButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(EditBodyFigure), findsOneWidget);
    });
  });
}