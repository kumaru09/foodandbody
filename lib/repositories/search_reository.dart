import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:foodandbody/models/search_result.dart';

class SearchRepository {
  const SearchRepository(this.cache, this.client);

  final SearchCache cache;
  final SearchClient client;

  Future<List<SearchResultItem>> search(String term) async {
    final cachedResult = cache.get(term);
    if (cachedResult != null) {
      return cachedResult;
    }
    final result = await client.search(term);
    cache.set(term, result);
    return result;
  }
}

class SearchCache {
  final _cache = <String, List<SearchResultItem>>{};

  List<SearchResultItem>? get(String term) => _cache[term];

  void set(String term, List<SearchResultItem> result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);
}

class SearchClient {
  SearchClient({
    http.Client? httpClient,
    this.baseUrl = "https://foodandbody-api.azurewebsites.net/api/menu/name/",
  }) : this.httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client httpClient;

  Future<List<SearchResultItem>> search(String term) async {
    final response = await httpClient.get(Uri.parse("$baseUrl$term"));
    final results = json.decode(response.body) as List;
    if (response.statusCode == 200) {
      return  results.map((dynamic json) {
        return SearchResultItem(
          name: json['name'] as String,
          calory: json['calories'] as int,
        );
      }).toList();
    } else {
      throw SearchResultError.fromJson(results);
    }
  }
}