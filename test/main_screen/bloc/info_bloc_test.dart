import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/main_screen/bloc/info_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const Nutrient mockNutrient = Nutrient(protein: 100, carb: 100, fat: 100);
  final Info mockInfo = Info(
      name: 'user',
      goal: 1600,
      weight: 50,
      height: 160,
      gender: 'F',
      goalNutrient: mockNutrient);

  group('InfoBloc', () {
    late UserRepository userRepository;
    late InfoBloc infoBloc;

    setUp(() {
      userRepository = MockUserRepository();
      infoBloc = InfoBloc(userRepository: userRepository);
    });

    group('LoadInfo', () {
      blocTest<InfoBloc, InfoState>(
        'emits success status when fetched initial info',
        setUp: () {
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => infoBloc,
        act: (bloc) => bloc.add(LoadInfo()),
        expect: () => <InfoState>[
          InfoState(status: InfoStatus.loading),
          InfoState(
            status: InfoStatus.success,
            info: mockInfo,
          )
        ],
        verify: (_) {
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<InfoBloc, InfoState>(
        'emits loading status during process',
        setUp: () {
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => mockInfo);
        },
        build: () => infoBloc,
        act: (bloc) => bloc.add(LoadInfo()),
        expect: () => <InfoState>[
          InfoState(status: InfoStatus.loading),
          InfoState(
            status: InfoStatus.success,
            info: mockInfo,
          )
        ],
        verify: (_) {
          verify(() => userRepository.getInfo()).called(1);
        },
      );

      blocTest<InfoBloc, InfoState>(
        'emits failure status when userRepository getInfo throw exception',
        setUp: () {
          when(() => userRepository.getInfo())
              .thenAnswer((_) async => throw Exception());
        },
        build: () => infoBloc,
        act: (bloc) => bloc.add(LoadInfo()),
        expect: () => <InfoState>[
          InfoState(status: InfoStatus.loading),
          InfoState(status: InfoStatus.failure),
        ],
        verify: (_) {
          verify(() => userRepository.getInfo()).called(1);
        },
      );
    });
  });
}
