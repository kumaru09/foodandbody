import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart' as http;

class MockSearchRepository extends Mock implements SearchRepository {}

class MockSearchClient extends Mock implements SearchClient {}

class MockSearchCache extends Mock implements SearchCache {}

class MockClient extends Mock implements http.Client {}

Uri _searchUrl({required String path}) {
  return Uri.parse(
      'https://foodandbody-api.azurewebsites.net/api/menu/name?$path');
}

String _keySearch(String key, [int page = 1]) => '${key}querypage=$page';

void main() {
  final mockClient = MockClient();
  late SearchRepository searchRepository;
  late SearchClient searchClient;
  late SearchCache searchCache;

  const List<SearchResultItem> searchResult = [
    SearchResultItem(name: 'ไก่ทอด', calory: 100),
    SearchResultItem(name: 'ไก่ย่าง', calory: 100),
    SearchResultItem(name: 'ไก่อบ', calory: 100),
  ];

  setUpAll(() {
    registerFallbackValue(Uri());
    when(() => mockClient.get(
        _searchUrl(
            path: _keySearch('กุ้ง')))).thenAnswer((invocation) async =>
        http.Response(
            '[{"id":"61548bdfb35f22394eca62ee","name":"กุ้งเผา","calories":96,"category":null,"imageUrl":"https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg"},{"id":"61548e229863bea73b84c5c6","name":"กุ้งอบวุ้นเส้น","calories":591,"category":null,"imageUrl":"https://bnn.blob.core.windows.net/food/kung-ob-woonsen.jpg"},{"id":"617aae335f375d952c9bc11b","name":"ข้าวผัดกุ้ง","calories":538,"category":["อาหารจานดียว"],"imageUrl":"https://bnn.blob.core.windows.net/food/shrimp-fried-rice.jpg"}]',
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            }));
    when(() => mockClient.get(_searchUrl(path: _keySearch('ฟ'))))
        .thenAnswer((invocation) async => http.Response('[]', 200, headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            }));
  });

  setUp(() async {
    searchClient = SearchClient(httpClient: mockClient);
    searchCache = MockSearchCache();
    when(() => searchCache.get(_keySearch('ไก่'))).thenReturn(searchResult);
    searchRepository = SearchRepository(searchCache, searchClient);
  });

  group('SearchRepository', () {
    group('return', () {
      test('empty menu list when not have menu yet', () async {
        final menuList = await searchRepository.search(_keySearch('ฟ'));
        expect(menuList.isEmpty, equals(true));
        verify(() => mockClient.get(_searchUrl(path: _keySearch('ฟ'))))
            .called(1);
      });

      test('search menu list when have menu', () async {
        final menuList = await searchRepository.search(_keySearch('กุ้ง'));
        expect(menuList[0].name, equals('กุ้งเผา'));
        expect(menuList[1].name, equals('กุ้งอบวุ้นเส้น'));
        expect(menuList[2].name, equals('ข้าวผัดกุ้ง'));
        verify(() => mockClient.get(_searchUrl(path: _keySearch('กุ้ง'))))
            .called(1);
      });

      test('search cache menu list when have cache', () async {
        final menuList = await searchRepository.search(_keySearch('ไก่'));
        expect(menuList[0].name, equals('ไก่ทอด'));
        expect(menuList[1].name, equals('ไก่ย่าง'));
        expect(menuList[2].name, equals('ไก่อบ'));
        verify(() => searchCache.get(_keySearch('ไก่'))).called(1);
        verifyNever(() => mockClient.get(_searchUrl(path: _keySearch('ไก่'))));
      });
    });

    group('call', () {
      test('cache get when have cache', () async {
        await searchRepository.search(_keySearch('ไก่'));
        verify(() => searchCache.get(_keySearch('ไก่'))).called(1);
      });

      test('cache set when not have cache yet', () async {
        final result = await searchRepository.search(_keySearch('กุ้ง'));
        verify(() => searchCache.get(_keySearch('กุ้ง'))).called(1);
        verify(() => searchCache.set(_keySearch('กุ้ง'), result)).called(1);
        verify(() => mockClient.get(_searchUrl(path: _keySearch('กุ้ง'))))
            .called(1);
      });

      test('httpClient get when have menu', () async {
        await searchRepository.search(_keySearch('กุ้ง'));
        verify(() => searchCache.get(_keySearch('กุ้ง'))).called(1);
        verify(() => mockClient.get(_searchUrl(path: _keySearch('กุ้ง'))))
            .called(1);
      });
    });
  });
}
