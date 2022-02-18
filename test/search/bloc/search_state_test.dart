import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/screens/search/bloc/search_bloc.dart';

void main() {
  final List<SearchResultItem> mockSearchItems = [SearchResultItem(name: 'menuName1', calory: 450)];
  group('SearchState', () {

    SearchState createSubject({
      SearchStatus status = SearchStatus.initial,
      List<SearchResultItem>? result,
      bool? hasReachedMax,
    }) {
      return SearchState(
        status: status,
        result: result ?? mockSearchItems,
        hasReachedMax: hasReachedMax ?? false,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(SearchState(), SearchState());
      expect(
        SearchState().toString(),
        SearchState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: SearchStatus.initial,
          result: mockSearchItems,
          hasReachedMax: false,
        ).props,
        equals(<Object?>[
          SearchStatus.initial, // status
          mockSearchItems, // result
          false, // hasReachedMax
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            result: null,
            hasReachedMax: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: SearchStatus.success,
            result: [],
            hasReachedMax: true,
          ),
          equals(
            createSubject(
              status: SearchStatus.success,
              result: [],
              hasReachedMax: true,
            ),
          ),
        );
      });
    });
  });
}