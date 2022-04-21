import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/food_calory.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_food_calory.dart';
import 'package:mocktail/mocktail.dart';

class MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {}

class FakeCameraEvent extends Fake implements CameraEvent {}

class FakeCameraState extends Fake implements CameraState {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockCameraRepository extends Mock implements CameraRepository {}

class MockBodyRepository extends Mock implements BodyRepository {}

class MockFoodCalory extends Mock implements FoodCalory {}

void main() {
  const editCalInput = Key("edit_cal_textFormField");
  const editCalSaveButton = Key("edit_cal_dialog_save_button");
  const editCalCancelButton = Key("edit_cal_dialog_cancel_button");
  
  group('ShowFoodCalory', () {
    final List<Predict> mockSelectResult = [
      Predict(name: 'อาหาร1', calory: 100, carb: 10, fat: 20, protein: 30),
      Predict(name: 'อาหาร2', calory: 100, carb: 10, fat: 20, protein: 30),
      Predict(name: 'อาหาร3', calory: 100, carb: 10, fat: 20, protein: 30),
    ];

    late CameraBloc cameraBloc;
    late CameraRepository cameraRepository;
    late PlanRepository planRepository;
    late BodyRepository bodyRepository;

    setUpAll(() {
      registerFallbackValue<CameraEvent>(FakeCameraEvent());
      registerFallbackValue<CameraState>(FakeCameraState());
    });

    setUp(() {
      cameraBloc = MockCameraBloc();
      cameraRepository = MockCameraRepository();
      planRepository = MockPlanRepository();
      bodyRepository = MockBodyRepository();
      when(() => cameraBloc.state).thenReturn(CameraState());
    });

    group('render', () {
      testWidgets('all widget correct at initial', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: cameraBloc,
              child: ShowFoodCalory(selectResult: mockSelectResult),
            ),
          ),
        );
        expect(find.text('แคลอรี'), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsNWidgets(3));
        expect(find.text('อาหาร1'), findsOneWidget);
        expect(find.text('อาหาร2'), findsOneWidget);
        expect(find.text('อาหาร3'), findsOneWidget);
        expect(find.text('แคลอรีรวม'), findsOneWidget);
        expect(find.text('300'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('ตกลง'), findsOneWidget);
      });

      testWidgets('EditCalDialog when pressed edit icon', (tester) async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: planRepository),
              RepositoryProvider.value(value: cameraRepository),
              RepositoryProvider.value(value: bodyRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: cameraBloc,
                child: ShowFoodCalory(selectResult: mockSelectResult),
              ),
            ),
          ),
        );
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();
        expect(find.byType(EditCalDialog), findsOneWidget);
      });

      testWidgets('close EditCalDialog when pressed close dialog button',
          (tester) async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: planRepository),
              RepositoryProvider.value(value: cameraRepository),
              RepositoryProvider.value(value: bodyRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: cameraBloc,
                child: ShowFoodCalory(selectResult: mockSelectResult),
              ),
            ),
          ),
        );
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();
        expect(find.byType(EditCalDialog), findsOneWidget);
        await tester.tap(find.text('ยกเลิก'));
        await tester.pumpAndSettle();
        expect(find.byType(EditCalDialog), findsNothing);
      });

      testWidgets('new total calory when edit cal', (tester) async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: planRepository),
              RepositoryProvider.value(value: cameraRepository),
              RepositoryProvider.value(value: bodyRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: cameraBloc,
                child: ShowFoodCalory(selectResult: mockSelectResult),
              ),
            ),
          ),
        );
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();
        expect(find.byType(EditCalDialog), findsOneWidget);
        await tester.enterText(find.byKey(editCalInput), '200');
        await tester.pump();
        await tester.tap(find.byKey(editCalSaveButton));
        await tester.pumpAndSettle();
        expect(find.byType(EditCalDialog), findsNothing);
        expect(find.text('300'), findsNothing);
        expect(find.text('400'), findsOneWidget);
      });

      testWidgets('failure SnackBar when status is failure', (tester) async {
        when(()=> cameraBloc.state).thenReturn(CameraState(status: CameraStatus.failure));
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: planRepository),
              RepositoryProvider.value(value: cameraRepository),
              RepositoryProvider.value(value: bodyRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: cameraBloc,
                child: ShowFoodCalory(selectResult: mockSelectResult),
              ),
            ),
          ),
        );
        expect(find.byType(SnackBar), findsNothing);
        expect(find.text('บันทึกข้อมูลไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'), findsNothing);
      });

      testWidgets('success SnackBar when status is success', (tester) async {
        when(()=> cameraBloc.state).thenReturn(CameraState(status: CameraStatus.success));
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: planRepository),
              RepositoryProvider.value(value: cameraRepository),
              RepositoryProvider.value(value: bodyRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: cameraBloc,
                child: ShowFoodCalory(selectResult: mockSelectResult),
              ),
            ),
          ),
        );
        expect(find.byType(SnackBar), findsNothing);
        expect(find.text('บันทึกข้อมูลสำเร็จ'), findsNothing);
      });
    });

    testWidgets('call AddPlanCamera when pressed ok button', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: bodyRepository),
          ],
          child: MaterialApp(
            home: BlocProvider.value(
              value: cameraBloc,
              child: ShowFoodCalory(selectResult: mockSelectResult),
            ),
          ),
        ),
      );
      await tester.tap(find.text('ตกลง'));
      await tester.pump();
      verify(() => cameraBloc.add(AddPlanCamera(predicts: mockSelectResult)))
          .called(1);
    });
  });

  group('EditCalDialog', () {
    late CameraBloc cameraBloc;
    late CameraRepository cameraRepository;
    late PlanRepository planRepository;
    late BodyRepository bodyRepository;

    final String mockCal = '100';
    final mockFoodCal = FoodCalory.dirty(mockCal);

    setUpAll(() {
      registerFallbackValue<CameraEvent>(FakeCameraEvent());
      registerFallbackValue<CameraState>(FakeCameraState());
    });

    setUp(() {
      cameraBloc = MockCameraBloc();
      cameraRepository = MockCameraRepository();
      planRepository = MockPlanRepository();
      bodyRepository = MockBodyRepository();
      when(() => cameraBloc.state).thenReturn(CameraState());
    });

    testWidgets('render all widget correct at initial', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: bodyRepository),
          ],
          child: MaterialApp(
            home: BlocProvider.value(
              value: cameraBloc,
              child: EditCalDialog(value: mockCal),
            ),
          ),
        ),
      );
      expect(find.byType(EditCalDialog), findsOneWidget);
      expect(find.text('แก้ไขแคลอรี'), findsOneWidget);
      expect(find.text(mockCal), findsOneWidget);
      expect(find.byKey(editCalInput), findsOneWidget);
      expect(find.byKey(editCalSaveButton), findsOneWidget);
      expect(find.byKey(editCalCancelButton), findsOneWidget);
    });

    testWidgets('render invalid error text when cal is invalid',
        (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: bodyRepository),
          ],
          child: MaterialApp(
            home: BlocProvider.value(
              value: cameraBloc,
              child: EditCalDialog(value: '0'),
            ),
          ),
        ),
      );
      expect(find.text('กรุณาระบุแคลอรีให้ถูกต้อง'), findsNothing);
    });

    testWidgets('render enable when cal is valid', (tester) async {
      when(() => cameraBloc.state).thenReturn(CameraState(cal: mockFoodCal));
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: bodyRepository),
          ],
          child: MaterialApp(
            home: BlocProvider.value(
              value: cameraBloc,
              child: EditCalDialog(value: mockCal),
            ),
          ),
        ),
      );
      final button = tester.widget<TextButton>(find.byKey(editCalSaveButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('render disable when cal is invalid', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: bodyRepository),
          ],
          child: MaterialApp(
            home: BlocProvider.value(
              value: cameraBloc,
              child: EditCalDialog(value: mockCal),
            ),
          ),
        ),
      );
      await tester.enterText(find.byKey(editCalInput), '0');
      await tester.pump();
      final button = tester.widget<TextButton>(find.byKey(editCalSaveButton));
      expect(button.enabled, isFalse);
    });
    testWidgets('call CalChanged when cal changed', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: planRepository),
            RepositoryProvider.value(value: cameraRepository),
            RepositoryProvider.value(value: bodyRepository),
          ],
          child: MaterialApp(
            home: BlocProvider.value(
              value: cameraBloc,
              child: EditCalDialog(value: mockCal),
            ),
          ),
        ),
      );
      await tester.enterText(find.byKey(editCalInput), '0');
      await tester.pump();
      verify(() => cameraBloc.add(CalChanged(value: '0'))).called(1);
    });
  });
}
