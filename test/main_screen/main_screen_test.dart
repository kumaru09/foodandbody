import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/initial_info/initial_info.dart';
import 'package:foodandbody/screens/main_screen/bloc/info_bloc.dart';
import 'package:foodandbody/screens/main_screen/main_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
// import 'package:mocktail_image_network/mocktail_image_network.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthenRepository extends Mock implements AuthenRepository {}

class MockInfoBloc extends MockBloc<InfoEvent, InfoState> implements InfoBloc {}

class FakeInfoEvent extends Fake implements InfoEvent {}

class FakeInfoState extends Fake implements InfoState {}

void main() {
  const bottomAppBarKey = Key('bottom_app_bar');
  const cameraButtonKey = Key('camera_floating_button');

  const Nutrient mockNutrient = Nutrient(protein: 100, carb: 100, fat: 100);
  final Info mockInfo = Info(
      name: 'user',
      goal: 1600,
      weight: 50,
      height: 160,
      gender: 'F',
      goalNutrient: mockNutrient);
  late UserRepository userRepository;
  late AuthenRepository authenRepository;
  late InfoBloc infoBloc;

  setUpAll(() {
    registerFallbackValue<InfoEvent>(FakeInfoEvent());
    registerFallbackValue<InfoState>(FakeInfoState());
  });

  setUp(() {
    infoBloc = MockInfoBloc();
    userRepository = MockUserRepository();
    authenRepository = MockAuthenRepository();
    when(() => infoBloc.state)
        .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
    when(() => userRepository.getInfo(any())).thenAnswer((_) async => mockInfo);
  });

  group("MainScreen", () {
    test("has a page", () {
      expect(MainScreen.page(), isA<MaterialPage>());
    });

    testWidgets("render MainScreen when status is success and have info",
        (tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: infoBloc,
                child: MainScreenPage(index: 4),
              ),
            ),
          ),
        );
        expect(find.byType(WillPopScope), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byKey(cameraButtonKey), findsOneWidget);
        expect(find.byKey(bottomAppBarKey), findsOneWidget);
      });
    });

    testWidgets("render InitialInfo when status is success but not have info",
        (tester) async {
     mockNetworkImagesFor(() async {
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.success, info: null));
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: infoBloc,
                child: MainScreenPage(index: 4),
              ),
            ),
          ),
        );
        expect(find.byType(InitialInfo), findsOneWidget);
      });
    });

    testWidgets("render failure widget when status is failure",
        (tester) async {
     mockNetworkImagesFor(() async {
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.failure));
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: infoBloc,
                child: MainScreenPage(index: 4),
              ),
            ),
          ),
        );
        expect(find.byType(Image), findsOneWidget);
        expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
        expect(find.text('ลองอีกครั้ง'), findsOneWidget);
      });
    });

    testWidgets("call LoadInfo when pressed try again in failure status",
        (tester) async {
     mockNetworkImagesFor(() async {
        when(() => infoBloc.state)
            .thenReturn(InfoState(status: InfoStatus.failure));
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: authenRepository),
              RepositoryProvider.value(value: userRepository),
            ],
            child: MaterialApp(
              home: BlocProvider.value(
                value: infoBloc,
                child: MainScreenPage(index: 4),
              ),
            ),
          ),
        );
        expect(find.text('ลองอีกครั้ง'), findsOneWidget);
        await tester.tap(find.text('ลองอีกครั้ง'));
        await tester.pump();
        verify(()=> infoBloc.add(LoadInfo())).called(1);
      });
    });
  });
}
