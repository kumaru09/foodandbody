import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart' as model;
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/body/body_figure_info.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/body/weight_and_height_info.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockInfoBloc extends MockBloc<InfoEvent, InfoState> implements InfoBloc {}

class FakeInfoEvent extends Fake implements InfoEvent {}

class FakeInfoState extends Fake implements InfoState {}

class MockBodyCubit extends MockCubit<BodyState> implements BodyCubit {}

class FakeBodyState extends Fake implements BodyState {}

class MockBodyRepository extends Mock implements BodyRepository {}

void main() {
  group('Body Page', () {
    const failureWidget = Key('body_failure_widget');

    final model.Body mockBody = model.Body(
        date: Timestamp.now(), shoulder: 30, chest: 30, waist: 30, hip: 30);
    final List<WeightList> mockWeightList = [
      WeightList(weight: 50, date: Timestamp.now())
    ];
    final Info mockInfo =
        Info(name: 'user1', goal: 2000, height: 160, weight: 50);

    late InfoBloc infoBloc;
    late BodyCubit bodyCubit;
    late BodyRepository bodyRepository;

    setUpAll(() {
      registerFallbackValue<InfoEvent>(FakeInfoEvent());
      registerFallbackValue<InfoState>(FakeInfoState());
      registerFallbackValue<BodyState>(FakeBodyState());
    });

    setUp(() {
      bodyCubit = MockBodyCubit();
      infoBloc = MockInfoBloc();
      bodyRepository = MockBodyRepository();
      // bodyCubit = BodyCubit(bodyRepository);
    });

    group("render", () {
      testWidgets("correct widget when success status", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            body: mockBody,
            weightList: mockWeightList));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
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
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
            child: Body(),
          ),
        ));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets("CircularProgressIndicator when InfoStatus is initial status",
          (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            body: mockBody,
            weightList: mockWeightList));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.initial));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
            child: Body(),
          ),
        ));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets("CircularProgressIndicator when BodyStatus is loading status",
          (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(status: BodyStatus.loading));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
            child: Body(),
          ),
        ));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets("CircularProgressIndicator when InfoStatus is loading status",
          (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            body: mockBody,
            weightList: mockWeightList));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.loading));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
            child: Body(),
          ),
        ));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets("failure widget when BodyStatus is failure", (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(status: BodyStatus.failure));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
            child: Body(),
          ),
        ));
        expect(find.byKey(failureWidget), findsOneWidget);
      });

      testWidgets("failure widget when InfoStatus is failure", (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            body: mockBody,
            weightList: mockWeightList));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.failure));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
            child: Body(),
          ),
        ));
        expect(find.byKey(failureWidget), findsOneWidget);
      });
    });

    group('call', () {
      testWidgets("body cubit when pressed try again in failure BodyStatus",
          (tester) async {
        when(() => bodyCubit.state)
            .thenReturn(BodyState(status: BodyStatus.failure));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
        when(() => bodyCubit.fetchBody()).thenAnswer((_) async {});
        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: bodyCubit),
                BlocProvider.value(value: infoBloc),
              ],
              child: Body(),
            ),
          ),
        );
        expect(find.byKey(failureWidget), findsOneWidget);
        await tester.tap(find.text('ลองอีกครั้ง'));
        await tester.pump();
        verify(() => bodyCubit.fetchBody()).called(1);
      });

      testWidgets("info bloc when pressed try again in failure InfoStatus",
          (tester) async {
        when(() => bodyCubit.state).thenReturn(BodyState(
            status: BodyStatus.success,
            body: mockBody,
            weightList: mockWeightList));
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.failure));
        await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bodyCubit),
              BlocProvider.value(value: infoBloc),
            ],
            child: Body(),
          ),
        ));
        expect(find.byKey(failureWidget), findsOneWidget);
        await tester.tap(find.text('ลองอีกครั้ง'));
        await tester.pump();
        verify(() => infoBloc.add(LoadInfo())).called(1);
      });
    });
  });
}
