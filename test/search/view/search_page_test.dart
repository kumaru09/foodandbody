import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:foodandbody/screens/search/search.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';
import 'package:mocktail/mocktail.dart';

class MockMenuCardRepository extends Mock implements MenuCardRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  const searchAppBar = Key('searchpage_appbar');

  group('SearchPage', () {
    test('has a page', () {
      expect(SearchPage.page(), isA<MaterialPage>());
    });

    testWidgets('renders two MenuCard', (tester) async {
      await tester.pumpWidget(RepositoryProvider<MenuCardRepository>(
        create: (_) => MockMenuCardRepository(),
        child: MaterialApp(home: SearchPage()),
      ));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('เมนูยอดนิยม'), findsOneWidget);
      expect(find.text('เมนูที่กินบ่อย'), findsOneWidget);
      expect(find.byType(MenuCard), findsNWidgets(2));
    });

    testWidgets("reder refresh progress indecator when drag screen down", (tester) async {
      await tester.pumpWidget(RepositoryProvider<MenuCardRepository>(
        create: (_) => MockMenuCardRepository(),
        child: MaterialApp(
          home: SearchPage(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(RefreshProgressIndicator), findsNothing);
      await tester.dragFrom(Offset(0, 500), Offset(0, 100));
      await tester.pump(Duration(seconds: 2));
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(RefreshProgressIndicator), findsNothing);
    });

    testWidgets('navigate to Search when pressed search icon', (tester) async {
      await tester.pumpWidget(RepositoryProvider<MenuCardRepository>(
        create: (_) => MockMenuCardRepository(),
        child: RepositoryProvider<SearchRepository>(
          create: (_) => MockSearchRepository(),
          child: MaterialApp(home: SearchPage()),
        ),
      ));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.byType(Search), findsOneWidget);
    });

    testWidgets('navigate to back when pressed arrow icon', (tester) async {
      await tester.pumpWidget(RepositoryProvider<MenuCardRepository>(
        create: (_) => MockMenuCardRepository(),
        child: MaterialApp(home: SearchPage()),
      ));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byKey(searchAppBar), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byKey(searchAppBar), findsNothing);
    });
  });
}
