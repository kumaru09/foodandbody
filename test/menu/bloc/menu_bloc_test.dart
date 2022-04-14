import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/distance_matrix.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/near_restaurant.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:google_place/google_place.dart' as google_place;
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockDio extends Mock implements Dio {}

class MockLocation extends Mock implements Location {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

class FakeMenuState extends Fake implements MenuState {}

class FakeMenuEvent extends Fake implements MenuEvent {}

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

class MockGooglePlaceManager extends Mock implements GooglePlaceManager {}

Uri _menuUrl({required String path}) {
  return Uri.https('foodandbody-api.azurewebsites.net', '/api/menu/$path');
}

void main() {
  group('MenuBloc', () {
    const List<NearRestaurant> mockNearRestaurant = [
      NearRestaurant(
          name: 'ร้านอาหาร1',
          distance: '228 mi',
          rating: 5.0,
          open: '0900',
          close: '1700')
    ];
    const mockPath = "กุ้งเผา";
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

    late http.Client httpClient;
    late Location location;
    late Dio dio;
    late PlanRepository planRepository;
    late FavoriteRepository favoriteRepository;
    late MenuBloc menuBloc;
    late google_place.NearBySearchResponse nearBySearchResponse;
    late DioAdapter dioAdapter;
    late google_place.DetailsResponse detailsResponse;
    late GooglePlaceManager googlePlaceManager;

    setUpAll(() {
      registerFallbackValue(Uri());
      registerFallbackValue<MenuState>(FakeMenuState());
      registerFallbackValue<MenuEvent>(FakeMenuEvent());
    });

    setUp(() {
      httpClient = MockClient();
      location = MockLocation();
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
      planRepository = MockPlanRepository();
      favoriteRepository = MockFavoriteRepository();
      googlePlaceManager = MockGooglePlaceManager();
      detailsResponse = google_place.DetailsResponse.fromJson({
        "html_attributions": [],
        "result": {
          "geometry": {
            "location": {"lat": -33.866489, "lng": 151.1958561},
          },
          "name": "ร้านอาหาร1",
          "opening_hours": {
            "open_now": false,
            "periods": [
              {
                "close": {"day": 1, "time": "1700"},
                "open": {"day": 1, "time": "0900"},
              },
            ],
          },
          "place_id": "id",
          "rating": 5.0,
        },
        "status": "OK",
      });
      nearBySearchResponse = google_place.NearBySearchResponse(results: [
        google_place.SearchResult(
          name: 'ร้านอาหาร1',
          placeId: "id",
          geometry: google_place.Geometry(
              location: google_place.Location(lat: 1, lng: 1)),
          rating: 5.0,
          openingHours: google_place.OpeningHours(periods: [
            google_place.Period(
                open: google_place.Open(time: '12.00'),
                close: google_place.Close(time: '20.00'))
          ]),
        )
      ]);
      menuBloc = MenuBloc(
          httpClient: httpClient,
          path: 'กุ้งเผา',
          planRepository: planRepository,
          favoriteRepository: favoriteRepository,
          location: location,
          dio: dio,
          googlePlaceManager: googlePlaceManager);
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
        return true;
      });
      // when(() => location.requestService()).thenAnswer((_) async {
      //   return false;
      // });
      when(() => location.hasPermission()).thenAnswer((_) async {
        return PermissionStatus.granted;
      });
      when(() => location.getLocation()).thenAnswer((_) async {
        return LocationData.fromMap(locationData);
      });
      when(() => googlePlaceManager.getNearBySearch(
              LocationData.fromMap(locationData), mockPath))
          .thenAnswer((invocation) async => nearBySearchResponse);
      dioAdapter.onGet(
          "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=1.0,1.0&origins=13.723345,100.59974&key=AIzaSyAAw4dLXy4iLB73faed51VGnNumwkU7mFY",
          (server) {
        server.reply(200, {
          "rows": [
            {
              "elements": [
                {
                  "distance": {"text": "228 mi", "value": 367439},
                  "duration": {"text": "3 hours 53 mins", "value": 14003},
                  "status": "OK",
                },
              ]
            }
          ]
        });
      });
      when(() => googlePlaceManager.get(any()))
          .thenAnswer((invocation) async => detailsResponse);

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
        wait: const Duration(milliseconds: 1000),
        expect: () => <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
            nearRestaurant: mockNearRestaurant,
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
        wait: const Duration(milliseconds: 1000),
        expect: () => <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
            nearRestaurant: mockNearRestaurant,
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
        wait: const Duration(milliseconds: 1000),
        expect: () => <MenuState>[
          MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
            nearRestaurant: mockNearRestaurant,
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

    group('AddMenu', () {
      blocTest<MenuBloc, MenuState>(
        'can call planRepository',
        setUp: () {
          when(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuById('กุ้งเผา'))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuAll('กุ้งเผา'))
              .thenAnswer((_) async {});
        },
        build: () => menuBloc,
        act: (bloc) =>
            bloc.add(AddMenu(name: 'กุ้งเผา', isEatNow: true, volumn: 1.0)),
        verify: (_) {
          verify(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .called(1);
          verify(() => favoriteRepository.addFavMenuById('กุ้งเผา')).called(1);
          verify(() => favoriteRepository.addFavMenuAll('กุ้งเผา')).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'emits success addMenuStatus when add menu success',
        setUp: () {
          when(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuById('กุ้งเผา'))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuAll('กุ้งเผา'))
              .thenAnswer((_) async {});
        },
        build: () => menuBloc,
        act: (bloc) =>
            bloc.add(AddMenu(name: 'กุ้งเผา', isEatNow: true, volumn: 1.0)),
        expect: () => <MenuState>[
          MenuState(addMenuStatus: AddMenuStatus.initial),
          MenuState(addMenuStatus: AddMenuStatus.success)
        ],
        verify: (_) {
          verify(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .called(1);
          verify(() => favoriteRepository.addFavMenuById('กุ้งเผา')).called(1);
          verify(() => favoriteRepository.addFavMenuAll('กุ้งเผา')).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'emits initial addMenuStatus when during process',
        setUp: () {
          when(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuById('กุ้งเผา'))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuAll('กุ้งเผา'))
              .thenAnswer((_) async {});
        },
        build: () => menuBloc,
        act: (bloc) =>
            bloc.add(AddMenu(name: 'กุ้งเผา', isEatNow: true, volumn: 1.0)),
        expect: () => <MenuState>[
          MenuState(addMenuStatus: AddMenuStatus.initial),
          MenuState(addMenuStatus: AddMenuStatus.success)
        ],
        verify: (_) {
          verify(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .called(1);
          verify(() => favoriteRepository.addFavMenuById('กุ้งเผา')).called(1);
          verify(() => favoriteRepository.addFavMenuAll('กุ้งเผา')).called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'emits failure addMenuStatus when addPlanMenu throw exception',
        setUp: () =>
            when(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, false))
                .thenAnswer((_) => throw Exception()),
        build: () => menuBloc,
        act: (bloc) =>
            bloc.add(AddMenu(name: 'กุ้งเผา', isEatNow: false, volumn: 1.0)),
        expect: () => <MenuState>[
          MenuState(addMenuStatus: AddMenuStatus.initial),
          MenuState(addMenuStatus: AddMenuStatus.failure)
        ],
        verify: (_) {
          verify(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, false))
              .called(1);
        },
      );

      blocTest<MenuBloc, MenuState>(
        'emits failure addMenuStatus when addFavMenuById throw exception',
        setUp: () {
          when(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuById('กุ้งเผา'))
              .thenAnswer((_) => throw Exception());
          when(() => favoriteRepository.addFavMenuAll('กุ้งเผา'))
              .thenAnswer((_) async {});
        },
        build: () => menuBloc,
        act: (bloc) =>
            bloc.add(AddMenu(name: 'กุ้งเผา', isEatNow: true, volumn: 1.0)),
        expect: () => <MenuState>[
          MenuState(addMenuStatus: AddMenuStatus.initial),
          MenuState(addMenuStatus: AddMenuStatus.failure)
        ],
        verify: (_) {
          verify(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .called(1);
          verify(() => favoriteRepository.addFavMenuById('กุ้งเผา')).called(1);
          verifyNever(() => favoriteRepository.addFavMenuAll('กุ้งเผา'));
        },
      );

      blocTest<MenuBloc, MenuState>(
        'emits failure addMenuStatus when addFavMenuAll throw exception',
        setUp: () {
          when(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuById('กุ้งเผา'))
              .thenAnswer((_) async {});
          when(() => favoriteRepository.addFavMenuAll('กุ้งเผา'))
              .thenAnswer((_) => throw Exception());
        },
        build: () => menuBloc,
        act: (bloc) =>
            bloc.add(AddMenu(name: 'กุ้งเผา', isEatNow: true, volumn: 1.0)),
        expect: () => <MenuState>[
          MenuState(addMenuStatus: AddMenuStatus.initial),
          MenuState(addMenuStatus: AddMenuStatus.failure)
        ],
        verify: (_) {
          verify(() => planRepository.addPlanMenu('กุ้งเผา', null, 1.0, true))
              .called(1);
          verify(() => favoriteRepository.addFavMenuById('กุ้งเผา')).called(1);
          verify(() => favoriteRepository.addFavMenuAll('กุ้งเผา')).called(1);
        },
      );
    });
  });
}
