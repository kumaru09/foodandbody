class SearchResultItem {
  const SearchResultItem({
    required this.name, 
    required this.calory,
  });
  final String name;
  final int calory;
}

class SearchResultError {
  const SearchResultError({required this.message});

  final String message;

  static SearchResultError fromJson(dynamic json) {
    return SearchResultError(
      message: json['message'] as String,
    );
  }
}