import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/widget/menu_card/menu_card_item.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group("MenuCardItem Class", () {
    final menu = MenuList(
        name: 'กุ้งเผา',
        calory: 96,
        imageUrl: 'https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg');
    testWidgets("show data correctly", (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: MenuCardItem(
                menu: menu,
              ),
            ),
          ),
        ));
        expect(find.text('กุ้งเผา'), findsOneWidget);
        expect(find.text(' 96'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });
  });
}
