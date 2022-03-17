import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyRepository extends Mock implements BodyRepository {}

class FakeBody extends Fake implements Body {}

void main() {
  group('BodyCubit', () {
    const invalidShoulderString = '';
    const invalidShoulder = BodyFigure.dirty(invalidShoulderString);

    const validShoulderString = '30';
    const validShoulder = BodyFigure.dirty(validShoulderString);

    const invalidChestString = '';
    const invalidChest = BodyFigure.dirty(invalidChestString);

    const validChestString = '30';
    const validChest = BodyFigure.dirty(validChestString);

    const invalidWaistString = '';
    const invalidWaist = BodyFigure.dirty(invalidWaistString);

    const validWaistString = '30';
    const validWaist = BodyFigure.dirty(validWaistString);

    const invalidHipString = '';
    const invalidHip = BodyFigure.dirty(invalidHipString);

    const validHipString = '30';
    const validHip = BodyFigure.dirty(validHipString);

    final Timestamp mockDate = Timestamp.now();
    final Body mockBody =
        Body(date: mockDate, shoulder: 30, chest: 30, waist: 30, hip: 30);
    final List<WeightList> mockWeightList = [
      WeightList(weight: 50, date: mockDate)
    ];

    late BodyRepository bodyRepository;
    late BodyCubit bodyCubit;

    setUp(() {
      bodyRepository = MockBodyRepository();
      bodyCubit = BodyCubit(bodyRepository);
    });

    setUpAll(() {
      registerFallbackValue<Body>(FakeBody());
    });

    test('initial state is BodyState()', () {
      expect(BodyCubit(bodyRepository).state, BodyState());
    });

    group('fetchBody', () {
      blocTest<BodyCubit, BodyState>(
        'emits successful status when fetched initial body',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(
            status: BodyStatus.success,
            weightList: mockWeightList,
            shoulder: validShoulder,
            chest: validChest,
            waist: validWaist,
            hip: validHip,
            bodyDate: mockDate,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits successful status when fetched empty data',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => Body.empty);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => []);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(
            status: BodyStatus.success,
            weightList: [],
            shoulder: BodyFigure.dirty('0'),
            chest: BodyFigure.dirty('0'),
            waist: BodyFigure.dirty('0'),
            hip: BodyFigure.dirty('0'),
            bodyDate: mockDate,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when bodyRepository getBodyLatest throw exception',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => throw Exception());
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(status: BodyStatus.failure)
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verifyNever(() => bodyRepository.getWeightList());
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when bodyRepository getWeightList throw exception',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.fetchBody(),
        expect: () => <BodyState>[
          BodyState(status: BodyStatus.loading),
          BodyState(status: BodyStatus.failure)
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );
    });

    group('updateWeight', () {
      blocTest<BodyCubit, BodyState>(
        'emits successful status',
        setUp: () {
          when(() => bodyRepository.addWeight(50)).thenAnswer((_) async => {});
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateWeight(50),
        expect: () => <BodyState>[
          BodyState(
            status: BodyStatus.success,
            weightList: mockWeightList,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.addWeight(50)).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      // blocTest<BodyCubit, BodyState>(
      //   'emits failure status when getWeightList throw Exception',
      //   setUp: () {
      //     when(() => bodyRepository.addWeight(50)).thenAnswer((_) async => {});
      //     when(() => bodyRepository.getWeightList())
      //         .thenAnswer((_) async => throw Exception());
      //   },
      //   build: () => bodyCubit,
      //   act: (bloc) => bloc.updateWeight(50),
      //   expect: () => <BodyState>[BodyState(status: BodyStatus.failure)],
      //   verify: (_) {
      //     verify(() => bodyRepository.addWeight(50)).called(1);
      //     verify(() => bodyRepository.getWeightList()).called(1);
      //   },
      // );
    });

    group('updateBody', () {
      blocTest<BodyCubit, BodyState>(
        'emits successful status',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => {});
        },
        build: () => bodyCubit,
        seed: () => BodyState(
          editBodyStatus: FormzStatus.valid,
          shoulder: validShoulder,
          chest: validChest,
          waist: validWaist,
          hip: validHip,
        ),
        act: (bloc) => bloc.updateBody(),
        expect: () => <BodyState>[
          BodyState(
            editBodyStatus: FormzStatus.submissionInProgress,
            shoulder: BodyFigure.dirty('30'),
            chest: BodyFigure.dirty('30'),
            waist: BodyFigure.dirty('30'),
            hip: BodyFigure.dirty('30'),
            bodyDate: mockDate,
          ),
          BodyState(
            editBodyStatus: FormzStatus.submissionSuccess,
            shoulder: BodyFigure.dirty('30'),
            chest: BodyFigure.dirty('30'),
            waist: BodyFigure.dirty('30'),
            hip: BodyFigure.dirty('30'),
            bodyDate: mockDate,
          ),
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits loading status during update body',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => {});
        },
        build: () => bodyCubit,
        seed: () => BodyState(
          editBodyStatus: FormzStatus.valid,
          shoulder: validShoulder,
          chest: validChest,
          waist: validWaist,
          hip: validHip,
        ),
        act: (bloc) => bloc.updateBody(),
        expect: () => <BodyState>[
          BodyState(
            editBodyStatus: FormzStatus.submissionInProgress,
            shoulder: BodyFigure.dirty('30'),
            chest: BodyFigure.dirty('30'),
            waist: BodyFigure.dirty('30'),
            hip: BodyFigure.dirty('30'),
            bodyDate: mockDate,
          ),
          BodyState(
            editBodyStatus: FormzStatus.submissionSuccess,
            shoulder: BodyFigure.dirty('30'),
            chest: BodyFigure.dirty('30'),
            waist: BodyFigure.dirty('30'),
            hip: BodyFigure.dirty('30'),
            bodyDate: mockDate,
          ),
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when updateBody throw exception',
        setUp: () {
          when(() => bodyRepository.updateBody(any()))
              .thenAnswer((_) async => throw Exception());
        },
        build: () => bodyCubit,
        seed: () => BodyState(
          editBodyStatus: FormzStatus.valid,
          shoulder: validShoulder,
          chest: validChest,
          waist: validWaist,
          hip: validHip,
        ),
        act: (bloc) => bloc.updateBody(),
        expect: () => <BodyState>[
          BodyState(
            editBodyStatus: FormzStatus.submissionInProgress,
            shoulder: BodyFigure.dirty('30'),
            chest: BodyFigure.dirty('30'),
            waist: BodyFigure.dirty('30'),
            hip: BodyFigure.dirty('30'),
            bodyDate: mockDate,
          ),
          BodyState(
            editBodyStatus: FormzStatus.submissionFailure,
            shoulder: BodyFigure.dirty('30'),
            chest: BodyFigure.dirty('30'),
            waist: BodyFigure.dirty('30'),
            hip: BodyFigure.dirty('30'),
            bodyDate: mockDate,
          ),
        ],
        verify: (_) {
          verify(() => bodyRepository.updateBody(any())).called(1);
        },
      );
    });

    group('editBodyFigure', () {
      blocTest<BodyCubit, BodyState>(
        'emits correct data when initial edit body figure',
        build: () => bodyCubit,
        act: (bloc) => bloc.editBodyFigure(
            shoulder: validShoulderString,
            chest: validChestString,
            waist: validWaistString,
            hip: validHipString),
        expect: () => <BodyState>[
          BodyState(
            shoulder: BodyFigure.dirty('30'),
            chest: BodyFigure.dirty('30'),
            waist: BodyFigure.dirty('30'),
            hip: BodyFigure.dirty('30'),
          ),
        ],
      );
    });

    group('shoulderChanged', () {
      blocTest<BodyCubit, BodyState>(
        'emits [invalid] when shoulder are invalid',
        build: () => bodyCubit,
        act: (cubit) => cubit.shoulderChanged(invalidShoulderString),
        expect: () => <BodyState>[
          BodyState(
            shoulder: invalidShoulder,
            editBodyStatus: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<BodyCubit, BodyState>(
        'emits [valid] when shoulder are valid',
        build: () => bodyCubit,
        seed: () => BodyState(
          chest: validChest,
          waist: validWaist,
          hip: validHip,
        ),
        act: (cubit) => cubit.shoulderChanged(validShoulderString),
        expect: () => <BodyState>[
          BodyState(
            editBodyStatus: FormzStatus.valid,
            shoulder: validShoulder,
            chest: validChest,
            waist: validWaist,
            hip: validHip,
          ),
        ],
      );
    });

    group('chestChanged', () {
      blocTest<BodyCubit, BodyState>(
        'emits [invalid] when chest are invalid',
        build: () => bodyCubit,
        act: (cubit) => cubit.chestChanged(invalidChestString),
        expect: () => <BodyState>[
          BodyState(
            chest: invalidChest,
            editBodyStatus: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<BodyCubit, BodyState>(
        'emits [valid] when chest are valid',
        build: () => bodyCubit,
        seed: () => BodyState(
          shoulder: validShoulder,
          waist: validWaist,
          hip: validHip,
        ),
        act: (cubit) => cubit.chestChanged(validChestString),
        expect: () => <BodyState>[
          BodyState(
            editBodyStatus: FormzStatus.valid,
            shoulder: validShoulder,
            chest: validChest,
            waist: validWaist,
            hip: validHip,
          ),
        ],
      );
    });

    group('waistChanged', () {
      blocTest<BodyCubit, BodyState>(
        'emits [invalid] when waist are invalid',
        build: () => bodyCubit,
        act: (cubit) => cubit.waistChanged(invalidWaistString),
        expect: () => <BodyState>[
          BodyState(
            waist: invalidWaist,
            editBodyStatus: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<BodyCubit, BodyState>(
        'emits [valid] when waist are valid',
        build: () => bodyCubit,
        seed: () => BodyState(
          shoulder: validShoulder,
          chest: validChest,
          hip: validHip,
        ),
        act: (cubit) => cubit.waistChanged(validWaistString),
        expect: () => <BodyState>[
          BodyState(
            editBodyStatus: FormzStatus.valid,
            shoulder: validShoulder,
            chest: validChest,
            waist: validWaist,
            hip: validHip,
          ),
        ],
      );
    });

    group('hipChanged', () {
      blocTest<BodyCubit, BodyState>(
        'emits [invalid] when hip are invalid',
        build: () => bodyCubit,
        act: (cubit) => cubit.hipChanged(invalidHipString),
        expect: () => <BodyState>[
          BodyState(
            hip: invalidHip,
            editBodyStatus: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<BodyCubit, BodyState>(
        'emits [valid] when hip are valid',
        build: () => bodyCubit,
        seed: () => BodyState(
          shoulder: validShoulder,
          chest: validChest,
          waist: validWaist,
        ),
        act: (cubit) => cubit.hipChanged(validHipString),
        expect: () => <BodyState>[
          BodyState(
            editBodyStatus: FormzStatus.valid,
            shoulder: validShoulder,
            chest: validChest,
            waist: validWaist,
            hip: validHip,
          ),
        ],
      );
    });
  });
}
