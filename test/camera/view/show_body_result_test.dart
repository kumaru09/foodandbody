import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/body/edit_body_figure.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_body_result.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mocktail/mocktail.dart';

class MockCameraBloc extends MockBloc<CameraEvent, CameraState>
    implements CameraBloc {}

class FakeCameraEvent extends Fake implements CameraEvent {}

class FakeCameraState extends Fake implements CameraState {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockCameraRepository extends Mock implements CameraRepository {}

class MockBodyRepository extends Mock implements BodyRepository {}

void main() {
  group('ShowBodyResult', () {
    final bodyPredict =
        BodyPredict(shoulder: 30, chest: 30, waist: 30, hip: 30);

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
            home: Scaffold(
              body: BlocProvider.value(
                value: cameraBloc,
                child: ShowBodyResult(results: bodyPredict),
              ),
            ),
          ),
        );
        expect(find.byType(LoaderOverlay), findsOneWidget);
        expect(find.byIcon(Icons.expand_more), findsOneWidget);
        expect(find.text('ผลลัพธ์'), findsOneWidget);
        expect(find.text('ไหล่'), findsOneWidget);
        expect(find.text('รอบอก'), findsOneWidget);
        expect(find.text('รอบเอว'), findsOneWidget);
        expect(find.text('รอบสะโพก'), findsOneWidget);
        expect(find.text('30 เซนติเมตร'), findsNWidgets(4));
        expect(find.text('บันทึก'), findsOneWidget);
        expect(find.text('แก้ไข'), findsOneWidget);
      });

      testWidgets('failure SnackBar when status is failure', (tester) async {
        when(() => cameraBloc.state)
            .thenReturn(CameraState(status: CameraStatus.failure));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: cameraBloc,
                child: ShowBodyResult(results: bodyPredict),
              ),
            ),
          ),
        );
        expect(find.byType(SnackBar), findsNothing);
        expect(find.text('บันทึกข้อมูลไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'),
            findsNothing);
      });
    });

    testWidgets('call AddPlanCamera when pressed ok button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: cameraBloc,
              child: ShowBodyResult(results: bodyPredict),
            ),
          ),
        ),
      );
      await tester.tap(find.text('บันทึก'));
      await tester.pump();
      verify(() => cameraBloc.add(AddBodyCamera(bodyPredict: bodyPredict)))
          .called(1);
    });
  });
}
