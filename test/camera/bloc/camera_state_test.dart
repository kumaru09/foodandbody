import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/models/food_calory.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';

void main() {
  final mockResults = BodyPredict(shoulder: 30, chest: 30, waist: 30, hip: 30);
  final mockPredict = [
    Predict(name: 'name', calory: 30, carb: 30, fat: 30, protein: 30)
  ];
  final mockIsFlat = 30;
  final mockHasPlane = true;
  final mockIsSupportAR = true;
  final mockCal = FoodCalory.pure();

  group('CameraState', () {
    CameraState createSubject({
      CameraStatus status = CameraStatus.initial,
      BodyPredict? results,
      List<Predict>? predicts,
      bool? hasPlane,
      bool? isSupportAR,
      FoodCalory? cal,
      int? isFlat,
    }) {
      return CameraState(
        status: status,
        results: results ?? mockResults,
        predicts: predicts ?? mockPredict,
        hasPlane: hasPlane ?? mockHasPlane,
        isSupportAR: isSupportAR ?? mockIsSupportAR,
        cal: cal ?? mockCal,
        isFlat: isFlat ?? mockIsFlat,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(CameraState(), CameraState());
      expect(
        CameraState().toString(),
        CameraState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: CameraStatus.initial,
          results: mockResults,
          predicts: mockPredict,
          isFlat: mockIsFlat,
          hasPlane: mockHasPlane,
          isSupportAR: mockIsSupportAR,
          cal: mockCal,
        ).props,
        equals(<Object?>[
          CameraStatus.initial,
          mockResults,
          mockPredict,
          mockIsFlat,
          mockHasPlane,
          mockIsSupportAR,
          mockCal,
        ]),
      );
    });

    test('returns object with updated status when status is passed', () {
      expect(
        CameraState().copyWith(status: CameraStatus.success),
        CameraState(status: CameraStatus.success),
      );
    });

    test('returns object with updated results when results is passed', () {
      expect(
        CameraState().copyWith(results: mockResults),
        CameraState(results: mockResults),
      );
    });

    test('returns object with updated predicts when predicts is passed', () {
      expect(
        CameraState().copyWith(predicts: mockPredict),
        CameraState(predicts: mockPredict),
      );
    });

    test('returns object with updated hasPlane when hasPlane is passed', () {
      expect(
        CameraState().copyWith(hasPlane: mockHasPlane),
        CameraState(hasPlane: mockHasPlane),
      );
    });

    test('returns object with updated isSupportAR when isSupportAR is passed',
        () {
      expect(
        CameraState().copyWith(isSupportAR: mockIsSupportAR),
        CameraState(isSupportAR: mockIsSupportAR),
      );
    });

    test('returns object with updated cal when cal is passed', () {
      expect(
        CameraState().copyWith(cal: mockCal),
        CameraState(cal: mockCal),
      );
    });

    test('returns object with updated isFlat when isFlat is passed', () {
      expect(
        CameraState().copyWith(isFlat: mockIsFlat),
        CameraState(isFlat: mockIsFlat),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            results: null,
            predicts: null,
            hasPlane: null,
            cal: null,
            isFlat: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: CameraStatus.failure,
            results: mockResults,
            predicts: mockPredict,
            hasPlane: mockHasPlane,
            isSupportAR: mockIsSupportAR,
            cal: mockCal,
            isFlat: mockIsFlat,
          ),
          equals(
            createSubject(
              status: CameraStatus.failure,
              results: mockResults,
              predicts: mockPredict,
              hasPlane: mockHasPlane,
              isSupportAR: mockIsSupportAR,
              cal: mockCal,
              isFlat: mockIsFlat,
            ),
          ),
        );
      });
    });
  });
}
