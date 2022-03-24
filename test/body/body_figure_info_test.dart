import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/edit_body_figure.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyCubit extends Mock implements BodyCubit {}

class FakeBodyState extends Fake implements BodyState {}

class MockBodyRepository extends Mock implements BodyRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const validShoulderString = '10';
  const validShoulder = BodyFigure.dirty(validShoulderString);

  const validChestString = '20';
  const validChest = BodyFigure.dirty(validChestString);

  const validWaistString = '30';
  const validWaist = BodyFigure.dirty(validWaistString);

  const validHipString = '40';
  const validHip = BodyFigure.dirty(validHipString);

  Timestamp mockDate = Timestamp.now();

  const bodyFigureImageKey = Key('body_figure_image');
  const bodyShoulderPointerKey = Key('body_shoulder_pointer');
  const bodyChestPointerKey = Key('body_chest_pointer');
  const bodyWaistPointerKey = Key('body_waist_pointer');
  const bodyHipPointerKey = Key('body_hip_pointer');
  const bodyFigureInfoEditButtonKey = Key("body_figure_info_edit_button");

  group("Body Figure Info", () {
    late BodyCubit bodyCubit;

    setUpAll(() {
      registerFallbackValue<BodyState>(FakeBodyState());
    });

    setUpAll(() {
      bodyCubit = MockBodyCubit();
      when(() => bodyCubit.state).thenReturn(BodyState(
        status: BodyStatus.success,
        shoulder: validShoulder,
        chest: validChest,
        waist: validWaist,
        hip: validHip,
        bodyDate: mockDate,
      ));
    });

    group("can render", () {
      testWidgets("figure image", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: SingleChildScrollView(
              child: BodyFigureInfo(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
                date: DateFormat("dd/MM/yyyy HH:mm").format(mockDate.toDate()),
              ),
            ),
          ),
        ));
        expect(find.byKey(bodyFigureImageKey), findsOneWidget);
      });

      testWidgets("line and pointer", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: SingleChildScrollView(
              child: BodyFigureInfo(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
                date: DateFormat("dd/MM/yyyy HH:mm").format(mockDate.toDate()),
              ),
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
          home: BlocProvider.value(
            value: bodyCubit,
            child: SingleChildScrollView(
              child: BodyFigureInfo(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
                date: DateFormat("dd/MM/yyyy HH:mm").format(mockDate.toDate()),
              ),
            ),
          ),
        ));
        expect(find.text("ไหล่"), findsOneWidget);
        expect(find.text("รอบอก"), findsOneWidget);
        expect(find.text("รอบเอว"), findsOneWidget);
        expect(find.text("รอบสะโพก"), findsOneWidget);
        expect(find.text(validShoulderString), findsOneWidget);
        expect(find.text(validChestString), findsOneWidget);
        expect(find.text(validWaistString), findsOneWidget);
        expect(find.text(validHipString), findsOneWidget);
        expect(find.text("เซนติเมตร"), findsNWidgets(4));
      });

      testWidgets("date", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: SingleChildScrollView(
              child: BodyFigureInfo(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
                date: DateFormat("dd/MM/yyyy HH:mm").format(mockDate.toDate()),
              ),
            ),
          ),
        ));
        expect(
            find.text("วันที่ " +
                DateFormat("dd/MM/yyyy HH:mm").format(mockDate.toDate())),
            findsOneWidget);
      });

      testWidgets("แก้ไข button", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: SingleChildScrollView(
              child: BodyFigureInfo(
                shoulder: int.parse(validShoulderString),
                chest: int.parse(validChestString),
                waist: int.parse(validWaistString),
                hip: int.parse(validHipString),
                date: DateFormat("dd/MM/yyyy HH:mm").format(mockDate.toDate()),
              ),
            ),
          ),
        ));
        expect(find.byKey(bodyFigureInfoEditButtonKey), findsOneWidget);
      });
    });

    testWidgets("when not have body figure info", (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider.value(
          value: bodyCubit,
          child: SingleChildScrollView(
            child: BodyFigureInfo(
              shoulder: 0,
              chest: 0,
              waist: 0,
              hip: 0,
              date: '',
            ),
          ),
        ),
      ));
      expect(find.text("-"), findsNWidgets(4));
      expect(find.text("เซนติเมตร"), findsNWidgets(4));
      // expect(
      //     find.text("วันที่ " +
      //         DateFormat("dd/MM/yyyy HH:mm").format(body.date.toDate())),
      //     findsOneWidget);
    });

    testWidgets("when tap แก้ไข button", (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<BodyRepository>(
          create: (_) => MockBodyRepository(),
          child: RepositoryProvider<UserRepository>(
            create: (_) => MockUserRepository(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: bodyCubit,
                child: SingleChildScrollView(
                  child: BodyFigureInfo(
                    shoulder: int.parse(validShoulderString),
                    chest: int.parse(validChestString),
                    waist: int.parse(validWaistString),
                    hip: int.parse(validHipString),
                    date: DateFormat("dd/MM/yyyy HH:mm")
                        .format(mockDate.toDate()),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.dragFrom(Offset(0, 300), Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(bodyFigureInfoEditButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(EditBodyFigure), findsOneWidget);
    });
  });
}
