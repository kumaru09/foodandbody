import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

Uri _menuCardUrl({required String path}) {
  return Uri.https('foodandbody-api.azurewebsites.net', path);
}

void main() {
  group('MenuCardBloc', () {
    const mockMenuCard = [MenuList(name: 'menuName1', calory: 405, imageUrl: 'testUrl1')];

    late http.Client httpClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockClient();
    });

    test('initial state is MenuCardState()', () {
      expect(MenuCardBloc(httpClient: httpClient, path: '/api/menu').state, const MenuCardState());
    });

    group('MenuCardFetched', () {

      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when http fetches initial menuCard',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{"name": "menuName1","calories":405,"imageUrl": "testUrl1"}]',
              200,
            );
          });
        },
        build: () => MenuCardBloc(httpClient: httpClient, path: '/api/menu'),
        act: (bloc) => bloc.add(MenuCardFetched()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            menu: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_menuCardUrl(path: '/api/menu'))).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "name": "menuName1", "calories": 405, "imageUrl": "testUrl1" }]',
              200,
            );
          });
        },
        build: () => MenuCardBloc(httpClient: httpClient, path: '/api/menu'),
        act: (bloc) => bloc
          ..add(MenuCardFetched())
          ..add(MenuCardFetched()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            menu: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'throttles events',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "name": "menuName1", "calories": 405, "imageUrl": "testUrl1" }]',
              200,
            );
          });
        },
        build: () => MenuCardBloc(httpClient: httpClient, path: '/api/menu'),
        act: (bloc) async {
          bloc.add(MenuCardFetched());
          await Future<void>.delayed(Duration.zero);
          bloc.add(MenuCardFetched());
        },
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            menu: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits failure status when http fetches menuCard and throw exception',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('', 500),
          );
        },
        build: () => MenuCardBloc(httpClient: httpClient, path: '/api/menu'),
        act: (bloc) => bloc.add(MenuCardFetched()),
        expect: () => <MenuCardState>[const MenuCardState(status: MenuCardStatus.failure)],
        verify: (_) {
          verify(() => httpClient.get(_menuCardUrl(path: '/api/menu'))).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when '
        '0 additional menuCard are fetched',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('[]', 200),
          );
        },
        build: () => MenuCardBloc(httpClient: httpClient, path: '/api/menu'),
        act: (bloc) => bloc.add(MenuCardFetched()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            menu: [],
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_menuCardUrl(path: '/api/menu'))).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status'
        'when additional menuCard are fetched',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "name": "menuName1", "calories": 405, "imageUrl": "testUrl1" }]',
              200,
            );
          });
        },
        build: () => MenuCardBloc(httpClient: httpClient, path: '/api/menu'),
        act: (bloc) => bloc.add(MenuCardFetched()),
        expect: () => <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            menu: [...mockMenuCard],
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_menuCardUrl(path: '/api/menu'))).called(1);
        },
      );
    });
  });
}