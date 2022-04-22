import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body_predict.dart';
import 'package:foodandbody/models/depth.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';

void main() {
  final xFile = XFile('path');
  final depth = Depth(depth: 'depth', fovW: 'fovW', fovH: 'fovH');
  final isFat = 1;
  final hasPlan = true;
  final value = 'value';
  final predict = [
    Predict(name: 'name', calory: 30, carb: 30, fat: 30, protein: 30)
  ];
  final bodyPredict = BodyPredict(shoulder: 30, chest: 30, waist: 30, hip: 30);
  final image = [xFile];
  final height = 30;

  group('CameraEvent', () {
    group('GetPredicton', () {
      test('supports value equality', () {
        expect(
          GetPredicton(file: xFile),
          equals(GetPredicton(file: xFile)),
        );
      });

      test('props are correct', () {
        expect(
          GetPredicton(file: xFile).props,
          equals(<Object?>[]),
        );
      });
    });

    group('GetPredictonWithDepth', () {
      test('supports value equality', () {
        expect(
          GetPredictonWithDepth(file: xFile, depth: depth),
          equals(
            GetPredictonWithDepth(file: xFile, depth: depth),
          ),
        );
      });

      test('props are correct', () {
        expect(
          GetPredictonWithDepth(file: xFile, depth: depth).props,
          equals(<Object?>[]),
        );
      });
    });

    group('SetHasPlane', () {
      test('supports value equality', () {
        expect(
          SetHasPlane(hasPlane: hasPlan),
          equals(SetHasPlane(hasPlane: hasPlan)),
        );
      });

      test('props are correct', () {
        expect(
          SetHasPlane(hasPlane: hasPlan).props,
          equals(<Object?>[]),
        );
      });
    });

    group('SetIsFlat', () {
      test('supports value equality', () {
        expect(
          SetIsFlat(isFlat: isFat),
          equals(SetIsFlat(isFlat: isFat)),
        );
      });

      test('props are correct', () {
        expect(
          SetIsFlat(isFlat: isFat).props,
          equals(<Object?>[]),
        );
      });
    });

    group('CalChanged', () {
      test('supports value equality', () {
        expect(
          CalChanged(value: value),
          equals(CalChanged(value: value)),
        );
      });

      test('props are correct', () {
        expect(
          CalChanged(value: value).props,
          equals(<Object?>[]),
        );
      });
    });

    group('AddPlanCamera', () {
      test('supports value equality', () {
        expect(
          AddPlanCamera(predicts: predict),
          equals(AddPlanCamera(predicts: predict)),
        );
      });

      test('props are correct', () {
        expect(
          AddPlanCamera(predicts: predict).props,
          equals(<Object?>[]),
        );
      });
    });

    group('AddBodyCamera', () {
      test('supports value equality', () {
        expect(
          AddBodyCamera(bodyPredict: bodyPredict),
          equals(AddBodyCamera(bodyPredict: bodyPredict)),
        );
      });

      test('props are correct', () {
        expect(
          AddBodyCamera(bodyPredict: bodyPredict).props,
          equals(<Object?>[]),
        );
      });
    });

    group('GetBodyPredict', () {
      test('supports value equality', () {
        expect(
          GetBodyPredict(image: image, height: height),
          equals(GetBodyPredict(image: image, height: height)),
        );
      });

      test('props are correct', () {
        expect(
          GetBodyPredict(image: image, height: height).props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
