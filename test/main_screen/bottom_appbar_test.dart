import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/main_screen/bottom_appbar.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  const bottomAppBarKey = Key('bottom_app_bar');
  const homeButtonKey = Key('home_button');
  const planButtonKey = Key('plan_button');
  const bodyButtonKey = Key('body_button');
  const historyButtonKey = Key('history_button');

  void mockFunction(int index) {}

  group("BottomNavigation", () {
    testWidgets("render BottomNavigation correct", (tester) async {
     mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: BottomNavigation(
                index: 0,
                onChangedTab: mockFunction,
              ),
            ),
          ),
        );
        expect(find.byKey(bottomAppBarKey), findsOneWidget);
        expect(find.byKey(homeButtonKey), findsOneWidget);
        expect(find.byKey(planButtonKey), findsOneWidget);
        expect(find.byKey(bodyButtonKey), findsOneWidget);
        expect(find.byKey(historyButtonKey), findsOneWidget);
      });
    });

    group("render white button at", () {
      testWidgets("home button", (tester) async {
       mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                bottomNavigationBar: BottomNavigation(
                  index: 0,
                  onChangedTab: mockFunction,
                ),
              ),
            ),
          );
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
        });
      });

      testWidgets("plan button", (tester) async {
       mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                bottomNavigationBar: BottomNavigation(
                  index: 1,
                  onChangedTab: mockFunction,
                ),
              ),
            ),
          );
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
        });
      });

      testWidgets("body button", (tester) async {
       mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                bottomNavigationBar: BottomNavigation(
                  index: 2,
                  onChangedTab: mockFunction,
                ),
              ),
            ),
          );
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
        });
      });

      testWidgets("history button", (tester) async {
       mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                bottomNavigationBar: BottomNavigation(
                  index: 3,
                  onChangedTab: mockFunction,
                ),
              ),
            ),
          );
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          expect(button.children[0].toString(), contains("Color(0x80ffffff)"));
          expect(button.children[1].toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          expect(button.children[0].toString(), contains("Color(0xffffffff)"));
          expect(button.children[1].toString(), contains("Color(0xffffffff)"));
        });
      });
    });
  });
}
