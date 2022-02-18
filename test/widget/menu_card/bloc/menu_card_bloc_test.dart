import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockMenuCardRepository extends Mock implements MenuCardRepository {}

void main() {
  group('MenuCardBloc', () {
    const mockMenuCard = [
      MenuList(name: 'menuName1', calory: 405, imageUrl: 'testUrl1')
    ];

    late MenuCardRepository menuCardRepository;

    setUp(() {
      menuCardRepository = MockMenuCardRepository();
    });

    test('initial state is MenuCardState()', () {
      expect(MenuCardBloc(menuCardRepository: menuCardRepository).state,
          const MenuCardState());
    });

    group('FetchedFavMenuCard', () {
      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when  fetches initial menuCard',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: true)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(FetchedFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: true)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc
          ..add(FetchedFavMenuCard())
          ..add(FetchedFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'throttles events',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: true)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) async {
          bloc.add(FetchedFavMenuCard());
          await Future<void>.delayed(Duration.zero);
          bloc.add(FetchedFavMenuCard());
        },
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits failure status when fetches menuCard and throw exception',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: true)).thenAnswer((_) async => throw Exception());
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(FetchedFavMenuCard()),
        expect: () => <MenuCardState>[const MenuCardState(status: MenuCardStatus.failure)],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when '
        '0 additional menuCard are fetched',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: true)).thenAnswer((_) async => []);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(FetchedFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: [],
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: true)).called(1);
        },
      );
    });

    group('FetchedMyFavMenuCard', () {
      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when  fetches initial menuCard',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: true)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(FetchedMyFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: true)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc
          ..add(FetchedMyFavMenuCard())
          ..add(FetchedMyFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'throttles events',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: true)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) async {
          bloc.add(FetchedMyFavMenuCard());
          await Future<void>.delayed(Duration.zero);
          bloc.add(FetchedMyFavMenuCard());
        },
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits failure status when fetches menuCard and throw exception',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: true)).thenAnswer((_) async => throw Exception());
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(FetchedMyFavMenuCard()),
        expect: () => <MenuCardState>[const MenuCardState(status: MenuCardStatus.failure)],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: true)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when '
        '0 additional menuCard are fetched',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: true)).thenAnswer((_) async => []);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(FetchedMyFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: [],
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: true)).called(1);
        },
      );
    });

    group('ReFetchedFavMenuCard', () {
      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when refetches menuCard',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: false)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(ReFetchedFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: false)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc
          ..add(ReFetchedFavMenuCard())
          ..add(ReFetchedFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'throttles events',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: false)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) async {
          bloc.add(ReFetchedFavMenuCard());
          await Future<void>.delayed(Duration.zero);
          bloc.add(ReFetchedFavMenuCard());
        },
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits failure status when fetches menuCard and throw exception',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: false)).thenAnswer((_) async => throw Exception());
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(ReFetchedFavMenuCard()),
        expect: () => <MenuCardState>[const MenuCardState(status: MenuCardStatus.failure)],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when '
        '0 additional menuCard are fetched',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: false,
              checkCache: false)).thenAnswer((_) async => []);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(ReFetchedFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            fav: [],
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: false, checkCache: false)).called(1);
        },
      );
    });

    group('ReFetchedMyFavMenuCard', () {
      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when refetches menuCard',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: false)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(ReFetchedMyFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: false)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc
          ..add(ReFetchedMyFavMenuCard())
          ..add(ReFetchedMyFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'throttles events',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: false)).thenAnswer((_) async => mockMenuCard);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) async {
          bloc.add(ReFetchedMyFavMenuCard());
          await Future<void>.delayed(Duration.zero);
          bloc.add(ReFetchedMyFavMenuCard());
        },
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: mockMenuCard,
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits failure status when fetches menuCard and throw exception',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: false)).thenAnswer((_) async => throw Exception());
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(ReFetchedMyFavMenuCard()),
        expect: () => <MenuCardState>[const MenuCardState(status: MenuCardStatus.failure)],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: false)).called(1);
        },
      );

      blocTest<MenuCardBloc, MenuCardState>(
        'emits successful status when '
        '0 additional menuCard are fetched',
        setUp: () {
          when(() => menuCardRepository.getMenuList(
              isMyFav: true,
              checkCache: false)).thenAnswer((_) async => []);
        },
        build: () => MenuCardBloc(menuCardRepository: menuCardRepository),
        act: (bloc) => bloc.add(ReFetchedMyFavMenuCard()),
        expect: () => const <MenuCardState>[
          MenuCardState(
            status: MenuCardStatus.success,
            myFav: [],
          )
        ],
        verify: (_) {
          verify(() => menuCardRepository.getMenuList(
              isMyFav: true, checkCache: false)).called(1);
        },
      );
    });
  });
}
