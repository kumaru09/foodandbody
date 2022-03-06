import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';

void main() {
  final Body mockBody =
      Body(date: Timestamp.now(), shoulder: 30, chest: 30, waist: 30, hip: 30);
  final List<WeightList> mockWeightList = [
    WeightList(weight: 50, date: Timestamp.now())
  ];
  group('BodyState', () {
    BodyState createSubject({
      BodyStatus status = BodyStatus.initial,
      Body? body,
      List<WeightList>? weightList,
    }) {
      return BodyState(
        status: status,
        body: body ?? mockBody,
        weightList: weightList ?? mockWeightList,
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
          body: mockBody,
          weightList: mockWeightList,
        ).props,
        equals(<Object?>[
          BodyStatus.initial, // status
          mockBody, // body
          mockWeightList, // weightList
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
            body: null,
            weightList: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: BodyStatus.success,
            body: Body.empty,
            weightList: [],
          ),
          equals(
            createSubject(
              status: BodyStatus.success,
              body: Body.empty,
              weightList: [],
            ),
          ),
        );
      });
    });
  });
}
