part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class TextChanged extends SearchEvent {
  const TextChanged({required this.text, required this.selectFilter});

  final String text;
  final List<String> selectFilter;

  @override
  List<Object> get props => [text, selectFilter];

  @override
  String toString() => 'TextChanged { text: $text, selectFilter: $selectFilter }';
}