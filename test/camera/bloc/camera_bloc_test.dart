import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/models/depth.dart';
import 'package:foodandbody/models/food_calory.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyRepository extends Mock implements BodyRepository {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockCameraRepository extends Mock implements CameraRepository {}

class FakeBody extends Fake implements Body {}

void main() {
  group('CameraBloc', () {
    final xFile = XFile('path');
    final depth = Depth(depth: 'depth', fovW: 'fovW', fovH: 'fovH');
    final isFlat = 1;
    final hasPlane = true;
    final value = 'value';
    final predict =
        Predict(name: 'name', calory: 30, carb: 30, fat: 30, protein: 30);
    final predictList = [predict];
    final bodyPredict =
        BodyPredict(shoulder: 30, chest: 30, waist: 30, hip: 30);
    final image = [xFile];
    final height = 30;

    late CameraBloc cameraBloc;
    late CameraRepository cameraRepository;
    late BodyRepository bodyRepository;
    late PlanRepository planRepository;

    setUpAll(() {
      registerFallbackValue<Body>(FakeBody());
    });

    setUp(() {
      cameraRepository = MockCameraRepository();
      bodyRepository = MockBodyRepository();
      planRepository = MockPlanRepository();
      cameraBloc = CameraBloc(
        cameraRepository: cameraRepository,
        bodyRepository: bodyRepository,
        planRepository: planRepository,
      );
    });

    test('initial state is CameraState()', () {
      expect(cameraBloc.state, CameraState());
    });

    group('GetPredictonWithDepth', () {
      blocTest<CameraBloc, CameraState>(
        'emits successful status when getPredictionFoodWithDepth passed',
        setUp: () => when(
                () => cameraRepository.getPredictionFoodWithDepth(xFile, depth))
            .thenAnswer((_) async => predictList),
        build: () => cameraBloc,
        act: (bloc) =>
            bloc.add(GetPredictonWithDepth(file: xFile, depth: depth)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading, predicts: []),
          CameraState(status: CameraStatus.success, predicts: predictList)
        ],
        verify: (_) {
          verify(() =>
                  cameraRepository.getPredictionFoodWithDepth(xFile, depth))
              .called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits loading status during getPredictionFoodWithDepth process',
        setUp: () => when(
                () => cameraRepository.getPredictionFoodWithDepth(xFile, depth))
            .thenAnswer((_) async => predictList),
        build: () => cameraBloc,
        act: (bloc) =>
            bloc.add(GetPredictonWithDepth(file: xFile, depth: depth)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading, predicts: []),
          CameraState(status: CameraStatus.success, predicts: predictList)
        ],
        verify: (_) {
          verify(() =>
                  cameraRepository.getPredictionFoodWithDepth(xFile, depth))
              .called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits failure status when getPredictionFoodWithDepth throw Exception',
        setUp: () => when(
                () => cameraRepository.getPredictionFoodWithDepth(xFile, depth))
            .thenAnswer((_) => throw Exception()),
        build: () => cameraBloc,
        act: (bloc) =>
            bloc.add(GetPredictonWithDepth(file: xFile, depth: depth)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading, predicts: []),
          CameraState(status: CameraStatus.failure)
        ],
        verify: (_) {
          verify(() =>
                  cameraRepository.getPredictionFoodWithDepth(xFile, depth))
              .called(1);
        },
      );
    });

    group('GetBodyPredict', () {
      blocTest<CameraBloc, CameraState>(
        'emits successful status when getPredictBody passed',
        setUp: () => when(() =>
                cameraRepository.getPredictBody(image: image, height: height))
            .thenAnswer((_) async => bodyPredict),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(GetBodyPredict(image: image, height: height)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading, results: null),
          CameraState(status: CameraStatus.success, results: bodyPredict)
        ],
        verify: (_) {
          verify(() =>
                  cameraRepository.getPredictBody(image: image, height: height))
              .called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits loading status during getPredictBody process',
        setUp: () => when(() =>
                cameraRepository.getPredictBody(image: image, height: height))
            .thenAnswer((_) async => bodyPredict),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(GetBodyPredict(image: image, height: height)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading, results: null),
          CameraState(status: CameraStatus.success, results: bodyPredict)
        ],
        verify: (_) {
          verify(() =>
                  cameraRepository.getPredictBody(image: image, height: height))
              .called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits failure status when getPredictBody throw Exception',
        setUp: () => when(() =>
                cameraRepository.getPredictBody(image: image, height: height))
            .thenAnswer((_) => throw Exception()),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(GetBodyPredict(image: image, height: height)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading, results: null),
          CameraState(status: CameraStatus.failure)
        ],
        verify: (_) {
          verify(() =>
                  cameraRepository.getPredictBody(image: image, height: height))
              .called(1);
        },
      );
    });

    group('AddPlanCamera', () {
      blocTest<CameraBloc, CameraState>(
        'emits successful status when addPlanCamera passed',
        setUp: () => when(() => planRepository.addPlanCamera(predict))
            .thenAnswer((_) async {}),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(AddPlanCamera(predicts: predictList)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading),
          CameraState(status: CameraStatus.success, predicts: [])
        ],
        verify: (_) {
          verify(() => planRepository.addPlanCamera(predict)).called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits loading status during addPlanCamera process',
        setUp: () => when(() => planRepository.addPlanCamera(predict))
            .thenAnswer((_) async {}),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(AddPlanCamera(predicts: predictList)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading),
          CameraState(status: CameraStatus.success, predicts: [])
        ],
        verify: (_) {
          verify(() => planRepository.addPlanCamera(predict)).called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits failure status when addPlanCamera throw Exception',
        setUp: () => when(() => planRepository.addPlanCamera(predict))
            .thenAnswer((_) => throw Exception()),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(AddPlanCamera(predicts: predictList)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading),
          CameraState(status: CameraStatus.failure)
        ],
        verify: (_) {
          verify(() => planRepository.addPlanCamera(predict)).called(1);
        },
      );
    });

    group('AddBodyCamera', () {
      blocTest<CameraBloc, CameraState>(
        'emits successful status when updateBody passed',
        setUp: () => when(() => bodyRepository.updateBody(any()))
            .thenAnswer((_) async {}),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(AddBodyCamera(bodyPredict: bodyPredict)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading),
          CameraState(status: CameraStatus.success, results: null)
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits loading status during updateBody process',
        setUp: () => when(() => bodyRepository.updateBody(any()))
            .thenAnswer((_) async {}),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(AddBodyCamera(bodyPredict: bodyPredict)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading),
          CameraState(status: CameraStatus.success, results: null)
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
        },
      );

      blocTest<CameraBloc, CameraState>(
        'emits failure status when updateBody throw Exception',
        setUp: () => when(() => bodyRepository.updateBody(any()))
            .thenAnswer((_) => throw Exception()),
        build: () => cameraBloc,
        act: (bloc) => bloc.add(AddBodyCamera(bodyPredict: bodyPredict)),
        expect: () => <CameraState>[
          CameraState(status: CameraStatus.loading),
          CameraState(status: CameraStatus.failure)
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
        },
      );
    });

    group('CalChanged', () {
      blocTest<CameraBloc, CameraState>(
        'emits cal when cal changed',
        build: () => cameraBloc,
        act: (bloc) => bloc.add(CalChanged(value: value)),
        expect: () => <CameraState>[CameraState(cal: FoodCalory.dirty(value))],
      );
    });

    group('SetIsFlat', () {
      blocTest<CameraBloc, CameraState>(
        'emits isFlat when set isFlat',
        build: () => cameraBloc,
        act: (bloc) => bloc.add(SetIsFlat(isFlat: isFlat)),
        expect: () => <CameraState>[CameraState(isFlat: isFlat)],
      );
    });

    group('SetHasPlane', () {
      blocTest<CameraBloc, CameraState>(
        'emits hasPlane when set hasPlane',
        build: () => cameraBloc,
        act: (bloc) => bloc.add(SetHasPlane(hasPlane: hasPlane)),
        expect: () => <CameraState>[CameraState(hasPlane: hasPlane)],
      );
    });
  });
}
