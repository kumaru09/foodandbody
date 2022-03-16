import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:formz/formz.dart';

void main() {
  const mockShoulder = BodyFigure.dirty('10');
  const mockChest = BodyFigure.dirty('20');
  const mockWaist = BodyFigure.dirty('30');
  const mockHip = BodyFigure.dirty('40');
  final mockDate = Timestamp.now();
  final List<WeightList> mockWeightList = [
    WeightList(weight: 50, date: Timestamp.now())
  ];
  group('BodyState', () {
    BodyState createSubject({
      BodyStatus status = BodyStatus.initial,
      List<WeightList>? weightList,
      FormzStatus editBodyStatus = FormzStatus.pure,
      BodyFigure? shoulder,
      BodyFigure? chest,
      BodyFigure? waist,
      BodyFigure? hip,
      Timestamp? bodyDate,
    }) {
      return BodyState(
        status: status,
        weightList: weightList ?? mockWeightList,
        editBodyStatus: editBodyStatus,
        shoulder: shoulder ?? mockShoulder,
        chest: chest ?? mockChest,
        waist: waist ?? mockWaist,
        hip: hip ?? mockHip,
        bodyDate: bodyDate ?? mockDate,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(BodyState(), BodyState());
      expect(
        BodyState().toString(),
        BodyState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: BodyStatus.initial,
          weightList: mockWeightList,
          editBodyStatus: FormzStatus.pure,
          shoulder: mockShoulder,
          chest: mockChest,
          waist: mockWaist,
          hip: mockHip,
        ).props,
        equals(<Object?>[
          BodyStatus.initial,
          mockWeightList,
          FormzStatus.pure,
          mockShoulder,
          mockChest,
          mockWaist,
          mockHip,
        ]),
      );
    });

    test('returns object with updated editBodyStatus when editBodyStatus is passed', () {
      expect(
        BodyState().copyWith(editBodyStatus: FormzStatus.pure),
        BodyState(),
      );
    });

    test('returns object with updated shoulder when shoulder is passed', () {
      expect(
        BodyState().copyWith(shoulder: mockShoulder),
        BodyState(shoulder: mockShoulder),
      );
    });

    test('returns object with updated chest when chest is passed', () {
      expect(
        BodyState().copyWith(chest: mockChest),
        BodyState(chest: mockChest),
      );
    });

    test('returns object with updated waist when waist is passed', () {
      expect(
        BodyState().copyWith(waist: mockWaist),
        BodyState(waist: mockWaist),
      );
    });

    test('returns object with updated hip when hip is passed', () {
      expect(
        BodyState().copyWith(hip: mockHip),
        BodyState(hip: mockHip),
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
            weightList: null,
            editBodyStatus: null,
            shoulder: null,
            chest: null,
            waist: null,
            hip: null,
            bodyDate: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: BodyStatus.failure,
            weightList: [],
            editBodyStatus: FormzStatus.submissionFailure,
            shoulder: BodyFigure.pure(),
            chest: BodyFigure.pure(),
            waist: BodyFigure.pure(),
            hip: BodyFigure.pure(),
            bodyDate: Timestamp.now(),
          ),
          equals(
            createSubject(
              status: BodyStatus.failure,
              weightList: [],
              editBodyStatus: FormzStatus.submissionFailure,
              shoulder: BodyFigure.pure(),
              chest: BodyFigure.pure(),
              waist: BodyFigure.pure(),
              hip: BodyFigure.pure(),
              bodyDate: Timestamp.now(),
            ),
          ),
        );
      });
    });
  });
}
