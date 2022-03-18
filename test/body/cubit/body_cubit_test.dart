import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/body.dart';
import 'package:foodandbody/models/body_figure.dart';
import 'package:foodandbody/models/height.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/weight.dart';
import 'package:foodandbody/models/weight_list.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockBodyRepository extends Mock implements BodyRepository {}

class MockUserRepository extends Mock implements UserRepository {}

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

    const invalidWeightString = '';
    const invalidWeight = Weight.dirty(invalidWeightString);

    const validWeightString = '50';
    const validWeight = Weight.dirty(validWeightString);

    const invalidHeightString = '';
    const invalidHeight = Height.dirty(invalidHeightString);

    const validHeightString = '150';
    const validHeight = Height.dirty(validHeightString);

    final Timestamp mockDate = Timestamp.now();
    final Body mockBody =
        Body(date: mockDate, shoulder: 30, chest: 30, waist: 30, hip: 30);
    final List<WeightList> mockWeightList = [
      WeightList(weight: 50, date: mockDate)
    ];
    final Info mockInfo = Info(name: 'user1', height: 150, weight: 50);

    late BodyRepository bodyRepository;
    late UserRepository userRepository;
    late BodyCubit bodyCubit;

    setUp(() {
      bodyRepository = MockBodyRepository();
      userRepository = MockUserRepository();
      bodyCubit = BodyCubit(
          bodyRepository: bodyRepository, userRepository: userRepository);
    });

    setUpAll(() {
      registerFallbackValue<Body>(FakeBody());
    });

    test('initial state is BodyState()', () {
      expect(
          BodyCubit(
                  bodyRepository: bodyRepository,
                  userRepository: userRepository)
              .state,
          BodyState());
    });

    group('fetchBody', () {
      blocTest<BodyCubit, BodyState>(
        'emits successful status when fetched initial body',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
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
            height: validHeight,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits successful status when fetched empty data',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => Body.empty);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => []);
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
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
            height: validHeight,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits loading status during process',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
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
            height: validHeight,
          )
        ],
        verify: (_) {
          verify(() => bodyRepository.getBodyLatest()).called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when bodyRepository getBodyLatest throw exception',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => throw Exception());
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
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
          verifyNever(() => userRepository.getInfo());
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when bodyRepository getWeightList throw exception',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => throw Exception());
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
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
          verifyNever(() => userRepository.getInfo());
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits failure status when userRepository getInfo throw exception',
        setUp: () {
          when(() => bodyRepository.getBodyLatest())
              .thenAnswer((_) async => mockBody);
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
          when(() => userRepository.getInfo())
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
          verify(() => userRepository.getInfo()).called(1);
        },
      );
    });

    group('updateWeight', () {
      blocTest<BodyCubit, BodyState>(
        'emits submissionSuccess status when updateWeight success',
        setUp: () {
          when(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .thenAnswer((_) async => {});
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateWeight(validWeightString),
        expect: () => <BodyState>[
          BodyState(
              weightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: true),
          BodyState(
            weightStatus: FormzStatus.submissionSuccess,
            weightList: mockWeightList,
          )
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits submissionInProgress FormzStatus during process',
        setUp: () {
          when(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .thenAnswer((_) async => {});
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => mockWeightList);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateWeight(validWeightString),
        expect: () => <BodyState>[
          BodyState(
              weightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: true),
          BodyState(
            weightStatus: FormzStatus.submissionSuccess,
            weightList: mockWeightList,
          )
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits submissionFailure status when updateWeightInfo throw Exception',
        setUp: () {
          when(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .thenAnswer((_) async => throw Exception());
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateWeight(validWeightString),
        expect: () => <BodyState>[
          BodyState(
              weightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: true),
          BodyState(weightStatus: FormzStatus.submissionFailure)
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .called(1);
          verifyNever(() => bodyRepository.getWeightList());
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits submissionFailure status when getWeightList throw Exception',
        setUp: () {
          when(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .thenAnswer((_) async => {});
          when(() => bodyRepository.getWeightList())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateWeight(validWeightString),
        expect: () => <BodyState>[
          BodyState(
              weightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: true),
          BodyState(weightStatus: FormzStatus.submissionFailure)
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateWeightInfo(int.parse(validWeightString)))
              .called(1);
          verify(() => bodyRepository.getWeightList()).called(1);
        },
      );
    });

    group('updateHeight', () {
      blocTest<BodyCubit, BodyState>(
        'emits submissionSuccess status when updateHeight success',
        setUp: () {
          when(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .thenAnswer((_) async => {});
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateHeight(validHeightString),
        expect: () => <BodyState>[
          BodyState(
              heightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: false),
          BodyState(
            heightStatus: FormzStatus.submissionSuccess,
            height: validHeight,
            isWeightUpdate: false,
          )
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits submissionInProgress status during process',
        setUp: () {
          when(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .thenAnswer((_) async => {});
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateHeight(validHeightString),
        expect: () => <BodyState>[
          BodyState(
              heightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: false),
          BodyState(
            heightStatus: FormzStatus.submissionSuccess,
            height: validHeight,
            isWeightUpdate: false,
          )
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits submissionFailure status when updateHeightInfo throw Exception',
        setUp: () {
          when(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .thenAnswer((_) async => throw Exception());
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateHeight(validHeightString),
        expect: () => <BodyState>[
          BodyState(
              heightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: false),
          BodyState(
            heightStatus: FormzStatus.submissionFailure,
            isWeightUpdate: false,
          )
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .called(1);
          verifyNever(() => userRepository.getInfo());
        },
      );

      blocTest<BodyCubit, BodyState>(
        'emits submissionFailure status when getInfo throw Exception',
        setUp: () {
          when(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .thenAnswer((_) async => {});
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => bodyCubit,
        act: (bloc) => bloc.updateHeight(validHeightString),
        expect: () => <BodyState>[
          BodyState(
              heightStatus: FormzStatus.submissionInProgress,
              isWeightUpdate: false),
          BodyState(
            heightStatus: FormzStatus.submissionFailure,
            isWeightUpdate: false,
          )
        ],
        verify: (_) {
          verify(() =>
                  userRepository.updateHeightInfo(int.parse(validHeightString)))
              .called(1);
          verify(() => userRepository.getInfo()).called(1);
        },
      );
    });

    group('updateBody', () {
      blocTest<BodyCubit, BodyState>(
        'emits submissionSuccess status when updateBody success',
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
        'emits submissionInProgress status during update body',
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
        'emits submissionFailure status when updateBody throw exception',
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

    group('initBodyFigure', () {
      blocTest<BodyCubit, BodyState>(
        'emits correct data when initial edit body figure',
        build: () => bodyCubit,
        act: (bloc) => bloc.initBodyFigure(
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

    group('weightChanged', () {
      blocTest<BodyCubit, BodyState>(
        'emits [invalid] when weight are invalid',
        build: () => bodyCubit,
        act: (cubit) => cubit.weightChanged(invalidWeightString),
        expect: () => <BodyState>[
          BodyState(
            weight: invalidWeight,
            weightStatus: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<BodyCubit, BodyState>(
        'emits [valid] when weight are valid',
        build: () => bodyCubit,
        act: (cubit) => cubit.weightChanged(validWeightString),
        expect: () => <BodyState>[
          BodyState(
            weightStatus: FormzStatus.valid,
            weight: validWeight,
          ),
        ],
      );
    });

    group('heightChanged', () {
      blocTest<BodyCubit, BodyState>(
        'emits [invalid] when height are invalid',
        build: () => bodyCubit,
        act: (cubit) => cubit.heightChanged(invalidHeightString),
        expect: () => <BodyState>[
          BodyState(
            height: invalidHeight,
            heightStatus: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<BodyCubit, BodyState>(
        'emits [valid] when height are valid',
        build: () => bodyCubit,
        act: (cubit) => cubit.heightChanged(validHeightString),
        expect: () => <BodyState>[
          BodyState(
            heightStatus: FormzStatus.valid,
            height: validHeight,
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