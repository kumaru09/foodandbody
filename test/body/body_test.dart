import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';
import 'package:foodandbody/screens/main_screen/bloc/info_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyCubit extends MockCubit<BodyState> implements BodyCubit {}

class FakeBodyState extends Fake implements BodyState {}

class MockBodyRepository extends Mock implements BodyRepository {}

void main() {
  group('Body Page', () {
    const failureWidget = Key('body_failure_widget');

    const validShoulderString = '10';
    const validShoulder = BodyFigure.dirty(validShoulderString);

    const validChestString = '20';
    const validChest = BodyFigure.dirty(validChestString);

    const validWaistString = '30';
    const validWaist = BodyFigure.dirty(validWaistString);

    const validHipString = '40';
    const validHip = BodyFigure.dirty(validHipString);

    const validHeightString = '150';
    const validHeight = Height.dirty(validHeightString);

    final Timestamp mockDate = Timestamp.now();
    final List<WeightList> mockWeightList = [
      WeightList(weight: 50, date: Timestamp.now())
    ];

    late BodyCubit bodyCubit;
    late BodyRepository bodyRepository;

    setUpAll(() {
      registerFallbackValue<BodyState>(FakeBodyState());
    });

    setUp(() {
      bodyCubit = MockBodyCubit();
      bodyRepository = MockBodyRepository();
      when(() => bodyCubit.state).thenReturn(BodyState(
        status: BodyStatus.success,
        shoulder: validShoulder,
        chest: validChest,
        waist: validWaist,
        hip: validHip,
        bodyDate: mockDate,
        weightList: mockWeightList,
        height: validHeight,
      ));
    });

    group("render", () {
      testWidgets("correct widget when success status", (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: Body(),
          ),
        ));
        expect(find.byType(WeightAndHeightInfo), findsOneWidget);
        expect(find.text('สัดส่วน'), findsOneWidget);
        expect(find.byType(BodyFigureInfo), findsOneWidget);
      });

      testWidgets("CircularProgressIndicator when BodyStatus is initial status",
          (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(status: BodyStatus.initial));
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: Body(),
          ),
        ));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets("CircularProgressIndicator when BodyStatus is loading status",
          (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(status: BodyStatus.loading));
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: Body(),
          ),
        ));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets("failure widget when BodyStatus is failure", (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(status: BodyStatus.failure));
        await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
            value: bodyCubit,
            child: Body(),
          ),
        ));
        expect(find.byKey(failureWidget), findsOneWidget);
      });
    });

    group('call', () {
      testWidgets("body cubit fetchBody when pressed try again in failure BodyStatus",
          (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(status: BodyStatus.failure));
        when(() => bodyCubit.fetchBody()).thenAnswer((_) async {});
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: bodyCubit,
              child: Body(),
            ),
          ),
        );
        expect(find.byKey(failureWidget), findsOneWidget);
        await tester.tap(find.text('ลองอีกครั้ง'));
        await tester.pump();
        verify(() => bodyCubit.fetchBody()).called(1);
      });
    });
  });
}
