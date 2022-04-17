import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/screens/main_screen/bloc/info_bloc.dart';

void main() {
  group('InfoState', () {
    const Nutrient mockNutrient = Nutrient(protein: 100, carb: 100, fat: 100);
    final Info mockInfo = Info(
        name: 'user',
        goal: 1600,
        weight: 50,
        height: 160,
        gender: 'F',
        goalNutrient: mockNutrient);

    InfoState createSubject({
      InfoStatus status = InfoStatus.initial,
      Info? info,
    }) {
      return InfoState(
        status: status,
        info: mockInfo,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(InfoState(), InfoState());
      expect(
        InfoState().toString(),
        InfoState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: InfoStatus.initial,
          info: mockInfo,
        ).props,
        equals(<Object?>[
          InfoStatus.initial,
          mockInfo,
        ]),
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
            info: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: InfoStatus.success,
            info: mockInfo,
          ),
          equals(
            createSubject(
              status: InfoStatus.success,
              info: mockInfo,
            ),
          ),
        );
      });
    });
  });
}
