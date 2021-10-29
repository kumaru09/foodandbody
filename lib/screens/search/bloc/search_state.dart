part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.result = const <SearchResultItem>[],
    this.hasReachedMax = false,
  });

  final SearchStatus status;
  final List<SearchResultItem> result;
  final bool hasReachedMax;

  SearchState copyWith({
    SearchStatus? status,
    List<SearchResultItem>? result,
    bool? hasReachedMax,
  }) {
    return SearchState(
      status: status ?? this.status,
      result: result ?? this.result,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''SearchState { status: $status, result: ${result.length}, hasReachedMax: $hasReachedMax }''';
  }

  @override
  List<Object> get props => [status, result, hasReachedMax];
}