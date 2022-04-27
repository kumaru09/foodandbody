import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_food_result.dart';
import 'package:mocktail/mocktail.dart';

class MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {}

class FakeCameraEvent extends Fake implements CameraEvent {}

class FakeCameraState extends Fake implements CameraState {}

void main() {
  group('ShowFoodResult', () {
    late CameraBloc cameraBloc;

    setUpAll(() {
      registerFallbackValue<CameraEvent>(FakeCameraEvent());
      registerFallbackValue<CameraState>(FakeCameraState());
    });

    setUp(() {
      cameraBloc = MockCameraBloc();
    });

    testWidgets('render FoodResult widget when status is success',
        (tester) async {
      when(() => cameraBloc.state)
          .thenReturn(CameraState(status: CameraStatus.success));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cameraBloc,
            child: ShowFoodResult(),
          ),
        ),
      );
      expect(find.byType(FoodResult), findsOneWidget);
    });

    testWidgets('render CircularProgressIndicator when status is loading',
        (tester) async {
      when(() => cameraBloc.state)
          .thenReturn(CameraState(status: CameraStatus.loading));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cameraBloc,
            child: ShowFoodResult(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('render failure widget when status is failure', (tester) async {
      when(() => cameraBloc.state)
          .thenReturn(CameraState(status: CameraStatus.failure));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cameraBloc,
            child: ShowFoodResult(),
          ),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
      expect(find.text('ลองอีกครั้ง'), findsOneWidget);
    });
  });

  group('FoodResult', () {
    final actionButton = Key('foodResult_elevatedButton');
    final List<Predict> mockAllResult = [
      Predict(name: 'อาหาร1', calory: 100, carb: 10, fat: 20, protein: 30),
      Predict(name: 'อาหาร2', calory: 100, carb: 10, fat: 20, protein: 30),
      Predict(name: 'อาหาร3', calory: 100, carb: 10, fat: 20, protein: 30),
    ];

    group('render', () {
      testWidgets('no result widget when have empty result list',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: FoodResult(allresult: [])),
        );
        expect(find.text('ไม่พบผลลัพธ์ที่ตรงกัน'), findsOneWidget);
        expect(find.text('กรุณาถ่ายใหม่'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('ถ่ายใหม่'), findsOneWidget);
      });

      testWidgets('food result when have result', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: FoodResult(allresult: mockAllResult)),
        );
        expect(find.text('3 ผลลัพธ์ที่ตรงกัน'), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(CheckboxListTile), findsNWidgets(3));
        expect(find.text('อาหาร1'), findsOneWidget);
        expect(find.text('อาหาร2'), findsOneWidget);
        expect(find.text('อาหาร3'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('ตกลง'), findsOneWidget);
      });

      testWidgets('disble ok button when no select food', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: FoodResult(allresult: mockAllResult)),
        );
        final button = tester.widget<ElevatedButton>(find.byKey(actionButton));
        expect(button.enabled, isFalse);
      });

      testWidgets('enable ok button when have select food', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: FoodResult(allresult: mockAllResult)),
        );
        await tester.tap(find.text('อาหาร1'));
        await tester.pump();
        final button = tester.widget<ElevatedButton>(find.byKey(actionButton));
        expect(button.enabled, isTrue);
      });
    });
  });
}
