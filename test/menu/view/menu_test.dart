import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/screens/menu/menu_detail.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanRepository extends Mock implements PlanRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  group('Menu Page', () {
    test('has a page', () {
      expect(MenuPage.menu(menuName: 'menuName'), isA<MenuPage>());
    });

    testWidgets('renders a correct app bar title', (tester) async {
      await tester.pumpWidget(RepositoryProvider<PlanRepository>(
        create: (_) => MockPlanRepository(),
        child: RepositoryProvider<FavoriteRepository>(
          create: (_) => MockFavoriteRepository(),
          child: MaterialApp(home: MenuPage.menu(menuName: 'menuName')),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('menuName'), findsOneWidget);
    });

    testWidgets('renders a MenuDetail', (tester) async {
      await tester.pumpWidget(RepositoryProvider<PlanRepository>(
        create: (_) => MockPlanRepository(),
        child: RepositoryProvider<FavoriteRepository>(
          create: (_) => MockFavoriteRepository(),
          child: MaterialApp(home: MenuPage.menu(menuName: 'menuName')),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(MenuDetail), findsOneWidget);
    });
  });
}
