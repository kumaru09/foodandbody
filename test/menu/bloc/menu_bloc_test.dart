import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockPlanRepository extends Mock implements PlanRepository {}

Uri _menuUrl({required String path}) {
  return Uri.https('foodandbody-api.azurewebsites.net', '/api/menu/$path');
}

void main() {

  // late MockPlanRepository mockPlanRepository;

  // setUp(() {
  //   mockPlanRepository = MockPlanRepository();
  // });

  group('MenuBloc', () {
    const mockMenu = MenuShow(
        name: "กุ้งเผา",
        calory: 96,
        protein: 18.7,
        carb: 0.3,
        fat: 0,
        serve: 100,
        unit: "กรัม",
        imageUrl: "https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg");

    late http.Client httpClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockClient();
    });

    test('initial state is MenuState()', () {
      expect(
          MenuBloc(
                  httpClient: httpClient,
                  path: 'กุ้งเผา',
                  planRepository: MockPlanRepository())
              .state,
          const MenuState());
    });

    group('MenuFetched', () {
      blocTest<MenuBloc, MenuState>(
        'emits successful status when http fetches initial menu',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
                '{"name":"กุ้งเผา","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                },);
          });
        },
        build: () => MenuBloc(
            httpClient: httpClient,
            path: 'กุ้งเผา',
            planRepository: MockPlanRepository()),
        act: (bloc) => bloc.add(MenuFetched()),
        expect: () => const <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
                '{"name":"กุ้งเผา","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                });
          });
        },
        build: () => MenuBloc(
            httpClient: httpClient,
            path: 'กุ้งเผา',
            planRepository: MockPlanRepository()),
        act: (bloc) => bloc..add(MenuFetched())..add(MenuFetched()),
        expect: () => const <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'throttles events',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
                '{"name":"กุ้งเผา","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
                200,
                headers: {
                  HttpHeaders.contentTypeHeader:
                      'application/json; charset=utf-8',
                });
          });
        },
        build: () => MenuBloc(
            httpClient: httpClient,
            path: 'กุ้งเผา',
            planRepository: MockPlanRepository()),
        act: (bloc) async {
          bloc.add(MenuFetched());
          await Future<void>.delayed(Duration.zero);
          bloc.add(MenuFetched());
        },
        expect: () => const <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'emits failure status when http fetches menu and throw exception',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('', 500),
          );
        },
        build: () => MenuBloc(
            httpClient: httpClient,
            path: 'กุ้งเผา',
            planRepository: MockPlanRepository()),
        act: (bloc) => bloc.add(MenuFetched()),
        expect: () => <MenuState>[const MenuState(status: MenuStatus.failure)],
        verify: (_) {
          verify(() => httpClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        },
      );
    });

    // blocTest<MenuBloc, MenuState>(
    //     'addMenu can call planRepository',
    //     build: () => MenuBloc(
    //         httpClient: httpClient,
    //         path: 'กุ้งเผา',
    //         planRepository: MockPlanRepository()),
    //     act: (bloc) => bloc.addMenu(name: 'กุ้งเผา', isEatNow: false, volumn: 1.0),
    //     verify: (_) {
    //       verify(() => mockPlanRepository.addPlanMenu('กุ้งเผา', 1.0, false)).called(1);
    //     },
    //   );
  });
}
