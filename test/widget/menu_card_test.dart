import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/theme.dart';
import 'package:foodandbody/widget/menu_card.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

abstract class MockWithExpandedToString extends Mock {
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug});
}

class MockFunction extends MockWithExpandedToString implements MenuCard {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}

void main() {
  const menuCardListViewKey = Key('menu_card_listview');

  group("MenuCardInfo Class", () {
    test("contain data correctly", () {
      final MenuCardInfo menu = MenuCardInfo(
          "https://img.kapook.com/u/surauch/movie2/garlic-fried-rice.jpg",
          "ข้าวผัดกระเทียม",
          644);
      expect(menu.image,
          "https://img.kapook.com/u/surauch/movie2/garlic-fried-rice.jpg");
      expect(Uri.parse(menu.image).isAbsolute, true);
      expect(menu.name, "ข้าวผัดกระเทียม");
      expect(menu.calories, 644);
    }); //test "contain data"
  }); //group "MenuCardInfo Class"

  group("Menu Card ListView", () {
    late MenuCard mockMenu;
    setUp(() {
      mockMenu = MockFunction();
    });
    testWidgets("can render", (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(
            body: MenuCard(),
          ),
        ));
      });
      expect(find.byKey(menuCardListViewKey), findsOneWidget);
    }); //"can render"

    testWidgets("when pressed menu card", (tester) async {
      final menuCardWidgetRender = MenuCard();
      when(() => mockMenu.getMenuInfo()).thenAnswer((invocation) => [
            MenuCardInfo(
                "https://img.kapook.com/u/surauch/movie2/garlic-fried-rice.jpg",
                "ข้าวผัดกระเทียม",
                644)
          ]);
      menuCardWidgetRender.menu = mockMenu.getMenuInfo();
      await mockNetworkImages(() async {
        await tester.pumpWidget(MaterialApp(
          theme: AppTheme.themeData,
          home: Scaffold(body: menuCardWidgetRender),
        ));
      });
      var cardFinder = find.byType(Card);
      expect(cardFinder, findsWidgets);
      await tester.tap(cardFinder.first);
      await tester.pumpAndSettle();
      var menuDetailFinder = find.byType(Menu);
      expect(menuDetailFinder, findsOneWidget);
      expect(find.text("ข้าวผัดกระเทียม"), findsOneWidget);
    }); //"when pressed menu card"
  }); //group "Menu Card ListView"
}
