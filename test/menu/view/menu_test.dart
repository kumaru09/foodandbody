import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/screens/menu/menu_detail.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanRepository extends Mock implements PlanRepository {}

void main() {
  group('Menu Page', () {

    test('has a page', () {
      expect(const MenuPage(menuName: 'menuName', isPlanMenu: false), isA<MenuPage>());
    });

    testWidgets('renders a correct app bar title', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<PlanRepository>(
            create: (_) => MockPlanRepository(),
            child: const MaterialApp(
                home: MenuPage(menuName: 'menuName', isPlanMenu: false)),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('menuName'), findsOneWidget);
    });

    testWidgets('renders a MenuDetail', (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<PlanRepository>(
            create: (_) => MockPlanRepository(),
            child: const MaterialApp(
                home: MenuPage(menuName: 'menuName', isPlanMenu: false)),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MenuDetail), findsOneWidget);
    });
  });
}
