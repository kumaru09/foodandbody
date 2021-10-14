import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';
import 'package:foodandbody/widget/menu_card/menu_card_list.dart';

void main() {
  group('MenuCard', () {
    testWidgets('renders MenuCardList', (tester) async {
      await tester.pumpWidget(MaterialApp(home: MenuCard(path: '/api/menu')));
      await tester.pumpAndSettle();
      expect(find.byType(MenuCardList), findsOneWidget);
    });
  });
}