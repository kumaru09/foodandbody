import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/body/body.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/history/history.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/screens/plan/plan.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class MockUser extends Mock implements User {}

void main() {
  //button
  const logoutButtonKey = Key('homePage_logout_iconButton');
  const settingButtonKey = Key('setting_button');
  const menuAllButtonKey = Key('menu_all_button');
  const removeWaterButtonKey = Key('remove_water_button');
  const addWaterButtonKey = Key('add_water_button');
  const homeButtonKey = Key('home_button');
  const planButtonKey = Key('plan_button');
  const bodyButtonKey = Key('body_button');
  const historyButtonKey = Key('history_button');
  const cameraButtonKey = Key('camera_floating_button');

  //widget
  const circularIndicatorKey = Key('calories_circular_indicator');
  const proteinLinearIndicatorKey = Key('protein_linear_indicator');
  const carbLinearIndicatorKey = Key('carb_linear_indicator');
  const fatLinearIndicatorKey = Key('fat_linear_indicator');
  const menuCardListViewKey = const Key('menu_card_listview');
  const dailyWaterCardKey = Key('daily_water_card');
  const dailyWaterDisplayKey = Key('daily_water_display');
  const bottomAppBarKey = Key('bottom_app_bar');

  group('Home Page', () {
    late AppBloc appBloc;
    late User user;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
    });

    setUp(() {
      appBloc = MockAppBloc();
      user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    test("has a page", () {
      expect(Home.page(), isA<MaterialPage>());
    }); //"has a page"

    group("calls", () {
      testWidgets("AppLogoutRequested when logout out is pressed",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(logoutButtonKey));
          verify(() => appBloc.add(AppLogoutRequested())).called(1);
        });
      }); //"AppLogoutRequested when logout out is pressed"
    }); //group "calls"

    group("render", () {
      testWidgets("calories circular progress", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          expect(find.byKey(circularIndicatorKey), findsOneWidget);
        });
      }); //"calories circular progress"

      group("nutrient linear progress", () {
        testWidgets("protein", (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(BlocProvider.value(
              value: appBloc,
              child: const MaterialApp(
                home: Home(),
              ),
            ));
            expect(find.byKey(proteinLinearIndicatorKey), findsOneWidget);
          });
        }); //"protein"

        testWidgets("carb", (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(BlocProvider.value(
              value: appBloc,
              child: const MaterialApp(
                home: Home(),
              ),
            ));
            expect(find.byKey(carbLinearIndicatorKey), findsOneWidget);
          });
        }); //"carb"

        testWidgets("fat", (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(BlocProvider.value(
              value: appBloc,
              child: const MaterialApp(
                home: Home(),
              ),
            ));
            expect(find.byKey(fatLinearIndicatorKey), findsOneWidget);
          });
        }); //"fat"
      }); //group "nutrient linear progress"

      testWidgets("menu card ListView", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          expect(find.byKey(menuCardListViewKey), findsOneWidget);
        });
      }); //"menu card ListView"

      testWidgets("daily water card", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          expect(find.byKey(bottomAppBarKey), findsOneWidget);
        });
      }); //"daily water card"

      testWidgets("bottom app bar", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.pumpAndSettle();
          expect(find.byKey(dailyWaterCardKey), findsOneWidget);
          await tester.pumpAndSettle();
          expect(find.byKey(removeWaterButtonKey), findsOneWidget);
          expect(find.byKey(dailyWaterDisplayKey), findsOneWidget);
          expect(find.byKey(addWaterButtonKey), findsOneWidget);
        });
      }); //"bottom app bar"
    }); //group "render"

    group("action", () {
      testWidgets("when pressed setting icon", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(settingButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(Setting), findsOneWidget);
        });
      }); //"when pressed setting icon"

      testWidgets("when pressed ดูทั้งหมด button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(menuAllButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(SearchPage), findsOneWidget);
        });
      }); //"when pressed ดูทั้งหมด button"

      testWidgets("when pressed remove button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byKey(removeWaterButtonKey));
          await tester.tap(find.byKey(removeWaterButtonKey));
          await tester.pumpAndSettle();
          expect(find.text("0"), findsOneWidget);
        });
      }); //"when pressed remove button"

      testWidgets("when pressed add button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byKey(addWaterButtonKey));
          await tester.tap(find.byKey(addWaterButtonKey));
          await tester.pumpAndSettle();
          expect(find.text("1"), findsOneWidget);
        });
      }); //"when pressed add button"

      testWidgets("when pressed add and remove button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.pump();
          await tester.ensureVisible(find.byKey(addWaterButtonKey));
          await tester.tap(find.byKey(addWaterButtonKey));
          await tester.pump();
          expect(find.text("1"), findsOneWidget);
          await tester.ensureVisible(find.byKey(removeWaterButtonKey));
          await tester.tap(find.byKey(removeWaterButtonKey));
          await tester.pump();
          expect(find.text("0"), findsOneWidget);
        });
      }); //"when pressed add and remove button"
    }); //group "action"

    group("bottom app bar", () {
      testWidgets("when pressed home icon", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(homeButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(Home), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          Widget icon = button.children[0];
          Widget text = button.children[1];
          expect(icon.toString(), contains("Color(0xffffffff)"));
          expect(text.toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
        });
      }); //"when pressed home icon"

      testWidgets("when pressed plan icon", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(planButtonKey));
          await tester.pump();
          expect(find.byType(Plan), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          Widget icon = button.children[0];
          Widget text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0xffffffff)"));
          expect(text.toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
        });
      }); //"when pressed home icon"

      testWidgets("when pressed body icon", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(bodyButtonKey));
          await tester.pump();
          expect(find.byType(Body), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          Widget icon = button.children[0];
          Widget text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0xffffffff)"));
          expect(text.toString(), contains("Color(0xffffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
        });
      }); //"when pressed body icon"

      testWidgets("when pressed history icon", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(historyButtonKey));
          await tester.pump();
          expect(find.byType(History), findsOneWidget);
          Column button = tester.firstWidget(find.byKey(homeButtonKey));
          Widget icon = button.children[0];
          Widget text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(planButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(bodyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0x80ffffff)"));
          expect(text.toString(), contains("Color(0x80ffffff)"));
          button = tester.firstWidget(find.byKey(historyButtonKey));
          icon = button.children[0];
          text = button.children[1];
          expect(icon.toString(), contains("Color(0xffffffff)"));
          expect(text.toString(), contains("Color(0xffffffff)"));
        });
      }); //"when pressed history icon"

      testWidgets("camera button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(
              home: Home(),
            ),
          ));
          await tester.tap(find.byKey(cameraButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(Camera), findsOneWidget);
          expect(find.byKey(bottomAppBarKey), findsNothing);
        });
      }); //"camera button"
    }); //group "pressed"
  }); //group "Home Page"
} //main
