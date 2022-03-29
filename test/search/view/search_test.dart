import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:foodandbody/screens/search/bloc/search_bloc.dart';
import 'package:foodandbody/screens/search/search.dart';
import 'package:mocktail/mocktail.dart';

class FakeSearchState extends Fake implements SearchState {}

class FakeSearchEvent extends Fake implements SearchEvent {}

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockSearchRepository extends Mock implements SearchRepository {}

extension on WidgetTester {
  Future<void> pumpSearch(SearchBloc searchBloc, Widget? widget) {
    return pumpWidget(
      RepositoryProvider<SearchRepository>(
        create: (_) => MockSearchRepository(),
        child: MaterialApp(
          home: BlocProvider.value(
            value: searchBloc,
            child: widget,
          ),
        ),
      ),
    );
  }
}

void main() {
  const searchAppBarTextFeild = Key('search_appbar_textfield');

  const String mockText = 'ก';
  const List<String> mockFilter = ['ทอด'];

  const List<SearchResultItem> mockSearchResult = [
    SearchResultItem(name: 'menuName1', calory: 150),
    SearchResultItem(name: 'menuName2', calory: 250),
    SearchResultItem(name: 'menuName3', calory: 350),
    SearchResultItem(name: 'menuName4', calory: 450),
    SearchResultItem(name: 'menuName5', calory: 550),
  ];

  late SearchBloc searchBloc;

  setUpAll(() {
    registerFallbackValue<SearchState>(FakeSearchState());
    registerFallbackValue<SearchEvent>(FakeSearchEvent());
  });

  setUp(() {
    searchBloc = MockSearchBloc();
  });

  group('Search', () {
    testWidgets('render SearchAppBar', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<SearchRepository>(
          create: (_) => MockSearchRepository(),
          child: MaterialApp(home: Search()),
        ),
      );
      expect(find.byType(SearchAppBar), findsOneWidget);
    });

    testWidgets('render SearchBody', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<SearchRepository>(
          create: (_) => MockSearchRepository(),
          child: MaterialApp(home: Search()),
        ),
      );
      expect(find.byType(SearchBody), findsOneWidget);
    });

    testWidgets('navigate back when pressed arrow icon', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<SearchRepository>(
          create: (_) => MockSearchRepository(),
          child: MaterialApp(home: Search()),
        ),
      );
      expect(find.byType(Search), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(Search), findsNothing);
    });
  });

  group('SearchAppBar', () {
    testWidgets('TextChanged when text changes', (tester) async {
      await tester.pumpSearch(searchBloc, SearchAppBar());
      expect(find.byKey(searchAppBarTextFeild), findsOneWidget);
      await tester.enterText(find.byKey(searchAppBarTextFeild), mockText);
      await tester.pumpAndSettle();
      expect(find.text(mockText), findsOneWidget);
      verify(() =>
              searchBloc.add(TextChanged(text: mockText, selectFilter: [])))
          .called(1);
    });

    testWidgets('clear text when icon clear is pressed', (tester) async {
      await tester.pumpSearch(searchBloc, SearchAppBar());
      expect(find.byKey(searchAppBarTextFeild), findsOneWidget);
      await tester.enterText(find.byKey(searchAppBarTextFeild), mockText);
      await tester.pumpAndSettle();
      expect(find.text(mockText), findsOneWidget);
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.text(mockText), findsNothing);
      verify(() => searchBloc.add(TextChanged(text: '', selectFilter: [])))
          .called(1);
    });

    testWidgets('TextChanged when filter changes', (tester) async {
      await tester.pumpSearch(searchBloc, SearchAppBar());
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ทอด'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ค้นหา'));
      await tester.pumpAndSettle();
      verify(() =>
              searchBloc.add(TextChanged(text: '', selectFilter: mockFilter)))
          .called(1);
    });
  });

  group('SearchBody', () {
    testWidgets(
        'renders initial UI '
        'when search status is initial', (tester) async {
      when(() => searchBloc.state).thenReturn(const SearchState(
        status: SearchStatus.initial,
      ));
      await tester.pumpSearch(searchBloc, SearchBody());
      expect(find.text('กรุณาใส่ชื่อเมนูเพื่อค้นหา'), findsOneWidget);
    });

    testWidgets(
        'renders CircularProgressIndicator '
        'when search status is loading', (tester) async {
      when(() => searchBloc.state).thenReturn(const SearchState(
        status: SearchStatus.loading,
      ));
      await tester.pumpSearch(searchBloc, SearchBody());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders no searchs result '
        'when search status is success but with 0 result', (tester) async {
      when(() => searchBloc.state).thenReturn(const SearchState(
        status: SearchStatus.success,
        result: [],
        hasReachedMax: true,
      ));
      await tester.pumpSearch(searchBloc, SearchBody());
      expect(find.text('ไม่พบผลลัพธ์ที่ตรงกัน'), findsOneWidget);
    });

    testWidgets(
        'renders searchs result '
        'when search status is success and result not empty', (tester) async {
      when(() => searchBloc.state).thenReturn(const SearchState(
        status: SearchStatus.success,
        result: mockSearchResult,
        hasReachedMax: true,
      ));
      await tester.pumpSearch(searchBloc, SearchBody());
      expect(find.text('menuName1'), findsOneWidget);
      expect(find.text('menuName2'), findsOneWidget);
      expect(find.text('menuName3'), findsOneWidget);
      expect(find.text('menuName4'), findsOneWidget);
      expect(find.text('menuName5'), findsOneWidget);
    });

    testWidgets(
        'renders fetched fail '
        'when search status is failure', (tester) async {
      when(() => searchBloc.state)
          .thenReturn(const SearchState(status: SearchStatus.failure));
      await tester.pumpSearch(searchBloc, SearchBody());
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
      expect(find.text('ลองอีกครั้ง'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('refresh when pressed try again', (tester) async {
      when(() => searchBloc.state)
          .thenReturn(const SearchState(status: SearchStatus.failure));
      await tester.pumpSearch(searchBloc, SearchBody());
      await tester.tap(find.text('ลองอีกครั้ง'));
      await tester.pumpAndSettle();
      verify(() => searchBloc.add(ReFetched())).called(1);
    });

    // testWidgets('go to menu when pressed menu card', (tester) async {
    //   mockNetworkImagesFor(() async {
    //     when(() => searchBloc.state).thenReturn(const SearchState(
    //     status: SearchStatus.success,
    //     result: mockSearchResult,
    //     hasReachedMax: true,
    //     ));
    //   await tester.pumpWidget(
    //     RepositoryProvider<SearchRepository>(
    //       create: (_) => MockSearchRepository(),
    //       child: MaterialApp(
    //         home: BlocProvider.value(
    //           value: searchBloc,
    //           child: SearchBody(),
    //         ),
    //       ),
    //     ),
    //   );
    //     expect(find.byType(MenuPage), findsNothing);
    //     await tester.tap(find.text('menuName1'));
    //     await tester.pumpAndSettle();
    //     expect(find.byType(MenuPage), findsOneWidget);
    //   });
    // });
  });
}
