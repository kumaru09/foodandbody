import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/near_restaurant.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:google_place/google_place.dart' as google_place;
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockGooglePlace extends Mock implements google_place.GooglePlace {}

class MockNearBySearchResponse extends Mock implements google_place.NearBySearchResponse {}

class MockDio extends Mock implements Dio {}

class MockLocation extends Mock implements Location {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

class FakeMenuState extends Fake implements MenuState {}

class FakeMenuEvent extends Fake implements MenuEvent {}

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

Uri _menuUrl({required String path}) {
  return Uri.https('foodandbody-api.azurewebsites.net', '/api/menu/$path');
}

void main() {
  group('MenuBloc', () {
    const List<NearRestaurant> mockNearRestaurant = [
      NearRestaurant(name: 'ร้านอาหาร1')
    ];
    const mockPath = 'กุ้งเผา';
    const mockMenu = MenuShow(
        name: "กุ้งเผา",
        calory: 96,
        protein: 18.7,
        carb: 0.3,
        fat: 0,
        serve: 100,
        unit: "กรัม",
        imageUrl: "https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg");
    const Map<String, dynamic> locationData = {
      "latitude": 13.723345,
      "longitude": 100.59974,
    };

    // const google_place.NearBySearchResponse mockNearBySearchResponse = google_place.NearBySearchResponse.parseNearBySearchResult(responseBody)

    late http.Client httpClient;
    late google_place.GooglePlace googlePlace;
    late Location location;
    late Dio dio;
    late PlanRepository planRepository;
    late FavoriteRepository favoriteRepository;
    late MenuBloc menuBloc;
    late google_place.NearBySearchResponse nearBySearchResponse; 

    setUpAll(() {
      registerFallbackValue(Uri());
      registerFallbackValue<MenuState>(FakeMenuState());
      registerFallbackValue<MenuEvent>(FakeMenuEvent());
    });

    setUp(() {
      httpClient = MockClient();
      googlePlace = MockGooglePlace();
      location = MockLocation();
      dio = MockDio();
      planRepository = MockPlanRepository();
      favoriteRepository = MockFavoriteRepository();
      nearBySearchResponse = MockNearBySearchResponse();
      menuBloc = MenuBloc(
        httpClient: httpClient,
        path: 'กุ้งเผา',
        planRepository: planRepository,
        favoriteRepository: favoriteRepository,
        location: location,
        dio: dio,
      );
      when(() => httpClient.get(any())).thenAnswer((_) async {
        return http.Response(
          '{"name":"กุ้งเผา","calories":96,"protein":18.7,"carb":0.3,"fat":0,"serve":100,"unit":"กรัม","imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"}',
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        );
      });
      when(() => location.serviceEnabled()).thenAnswer((_) async {
        return false;
      });
      when(() => location.requestService()).thenAnswer((_) async {
        return false;
      });
      // when(() => location.hasPermission()).thenAnswer((_) async {
      //   return PermissionStatus.granted;
      // });
      // when(() => location.getLocation()).thenAnswer((_) async {
      //   return LocationData.fromMap(locationData);
      // });
      // when(() => googlePlace.search.getNearBySearch(
      //       any(), 2000, type: "restaurant", keyword: mockPath,
      //     )).thenAnswer((_) async {
      //   return nearBySearchResponse;
      // });

      // nearBySearchResponse api doc มี json
      // https://developers.google.com/maps/documentation/places/web-service/search-nearby#json
    });

    test('initial state is MenuState()', () {
      expect(
          MenuBloc(
            httpClient: httpClient,
            path: 'กุ้งเผา',
            planRepository: MockPlanRepository(),
            favoriteRepository: MockFavoriteRepository(),
          ).state,
          MenuState());
    });

    group('MenuFetched', () {
      blocTest<MenuBloc, MenuState>(
        'emits successful status when http fetches initial menu',
        build: () => menuBloc,
        act: (bloc) => bloc.add(MenuFetched()),
        expect: () => <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
            nearRestaurant: [],
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'drops new events when processing current event',
        build: () => menuBloc,
        act: (bloc) => bloc
          ..add(MenuFetched())
          ..add(MenuFetched()),
        expect: () => <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
            nearRestaurant: [],
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'throttles events',
        build: () => menuBloc,
        act: (bloc) async {
          bloc.add(MenuFetched());
          await Future<void>.delayed(Duration.zero);
          bloc.add(MenuFetched());
        },
        expect: () => <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
            nearRestaurant: [],
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
        build: () => menuBloc,
        act: (bloc) => bloc.add(MenuFetched()),
        expect: () => <MenuState>[MenuState(status: MenuStatus.failure)],
        verify: (_) {
          verify(() => httpClient.get(_menuUrl(path: 'กุ้งเผา'))).called(1);
        },
      );
    });

    blocTest<MenuBloc, MenuState>(
      'addMenu can call planRepository',
      build: () => menuBloc,
      act: (bloc) =>
          bloc.addMenu(name: 'กุ้งเผา', isEatNow: false, volumn: 1.0),
      verify: (_) {
        verify(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, false))
            .called(1);
      },
    );
  });
}
