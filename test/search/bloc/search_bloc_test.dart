import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:foodandbody/screens/search/bloc/search_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  group('SearchBloc', () {
    const List<SearchResultItem> mockSearch1 = [
      SearchResultItem(name: 'อาหาร1', calory: 600),
      SearchResultItem(name: 'อาหาร2', calory: 600),
      SearchResultItem(name: 'อาหาร3', calory: 600),
      SearchResultItem(name: 'อาหาร4', calory: 600),
      SearchResultItem(name: 'อาหาร5', calory: 600),
      SearchResultItem(name: 'อาหาร6', calory: 600),
      SearchResultItem(name: 'อาหาร7', calory: 600),
      SearchResultItem(name: 'อาหาร8', calory: 600),
      SearchResultItem(name: 'อาหาร9', calory: 600),
      SearchResultItem(name: 'อาหาร10', calory: 600),
    ];
    const List<SearchResultItem> mockSearch2 = [
      SearchResultItem(name: 'อาหาร11', calory: 450),
      SearchResultItem(name: 'อาหาร12', calory: 500),
      SearchResultItem(name: 'อาหาร13', calory: 550),
    ];
    final String mockText = 'อาหาร';
    final List<String> mockFilter = ['ทอด'];
    final String mockKeySearch =
        'c=ทอด&name=อาหาร&querypage=1'; // c=ทอด&name=ก&querypage=1

    late SearchRepository searchRepository;
    late SearchBloc searchBloc;

    setUp(() {
      searchRepository = MockSearchRepository();
      searchBloc = SearchBloc(searchRepository: searchRepository);
      searchBloc.keySearch = 'c=ทอด&name=อาหาร&';
    });

    test('initial state is SearchState()', () {
      expect(SearchBloc(searchRepository: searchRepository).state,
          const SearchState());
    });

    group('TextChanged', () {
      blocTest<SearchBloc, SearchState>(
        'emits successful status when fetches initial search',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => mockSearch1);
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) =>
            bloc.add(TextChanged(text: mockText, selectFilter: mockFilter)),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: mockSearch1,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => mockSearch1);
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) => bloc
          ..add(TextChanged(text: mockText, selectFilter: mockFilter))
          ..add(TextChanged(text: mockText, selectFilter: mockFilter)),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: mockSearch1,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'throttles events',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => mockSearch1);
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) async {
          bloc.add(TextChanged(text: mockText, selectFilter: mockFilter));
          await Future<void>.delayed(Duration.zero);
          bloc.add(TextChanged(text: mockText, selectFilter: mockFilter));
        },
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: mockSearch1,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits failure status when fetches search and throw exception',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => throw Exception());
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) =>
            bloc.add(TextChanged(text: mockText, selectFilter: mockFilter)),
        wait: const Duration(milliseconds: 300),
        expect: () => <SearchState>[
          const SearchState(status: SearchStatus.loading),
          const SearchState(status: SearchStatus.failure)
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits successful status when '
        '0 additional search are fetched',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => []);
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) =>
            bloc.add(TextChanged(text: mockText, selectFilter: mockFilter)),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: [],
            hasReachedMax: true,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits successful status and hasReachMax true when '
        'search result less than 10',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => mockSearch2);
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) =>
            bloc.add(TextChanged(text: mockText, selectFilter: mockFilter)),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: mockSearch2,
            hasReachedMax: true,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits loading status when during search',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => mockSearch2);
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) =>
            bloc.add(TextChanged(text: mockText, selectFilter: mockFilter)),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: mockSearch2,
            hasReachedMax: true,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits initial status when clear search text and no filter',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => []);
        },
        build: () => SearchBloc(searchRepository: searchRepository),
        act: (bloc) => bloc.add(TextChanged(text: '', selectFilter: [])),
        wait: const Duration(milliseconds: 300),
        expect: () =>
            const <SearchState>[SearchState(status: SearchStatus.initial)],
        verify: (_) {
          verifyNever(() => searchRepository.search(mockKeySearch)).called(0);
        },
      );
    });

    group('ReFetched', () {

      blocTest<SearchBloc, SearchState>(
        'emits success status when refetch event success',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => mockSearch1);
        },
        build: () => searchBloc,
        act: (bloc) => bloc.add(ReFetched()),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: mockSearch1,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits loading status when during refetch event',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => mockSearch1);
        },
        build: () => searchBloc,
        act: (bloc) => bloc.add(ReFetched()),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(
            status: SearchStatus.success,
            result: mockSearch1,
          )
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'emits failure status when refetch event fail',
        setUp: () {
          when(() => searchRepository.search(mockKeySearch))
              .thenAnswer((_) async => throw Exception());
        },
        build: () => searchBloc,
        act: (bloc) => bloc.add(ReFetched()),
        wait: const Duration(milliseconds: 300),
        expect: () => const <SearchState>[
          SearchState(status: SearchStatus.loading),
          SearchState(status: SearchStatus.failure)
        ],
        verify: (_) {
          verify(() => searchRepository.search(mockKeySearch)).called(1);
        },
      );
    });
  });
}
