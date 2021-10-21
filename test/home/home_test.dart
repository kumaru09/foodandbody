import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/search/search.dart';
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

class MockPlanBloc extends MockBloc<PlanEvent, PlanState> implements PlanBloc {}

class FakePlanEvent extends Fake implements PlanEvent {}

class FakePlanState extends Fake implements PlanState {}

class MockPlan extends Mock implements History {}

void main() {
  //button
  const settingButtonKey = Key('setting_button');
  const menuAllButtonKey = Key('menu_all_button');
  const removeWaterButtonKey = Key('remove_water_button');
  const addWaterButtonKey = Key('add_water_button');

  //widget
  const circularIndicatorKey = Key('calories_circular_indicator');
  const proteinLinearIndicatorKey = Key('protein_linear_indicator');
  const carbLinearIndicatorKey = Key('carb_linear_indicator');
  const fatLinearIndicatorKey = Key('fat_linear_indicator');
  const menuCardListViewKey = const Key('menu_card_listview');
  const dailyWaterCardKey = Key('daily_water_card');
  const dailyWaterDisplayKey = Key('daily_water_display');

  group('Home Page', () {
    late AppBloc appBloc;
    late User user;
    late PlanBloc planBloc;
    late History plan;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<PlanEvent>(FakePlanEvent());
      registerFallbackValue<PlanState>(FakePlanState());
    });

    setUp(() {
      planBloc = MockPlanBloc();
      appBloc = MockAppBloc();
      plan = MockPlan();
      user = MockUser();
      when(() => planBloc.state).thenReturn(PlanLoaded(plan));
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      when(() => plan.totalNutrientList)
          .thenReturn(Nutrient().copyWith(protein: 120, carb: 80, fat: 30));
      when(() => user.info).thenReturn(Info(
          goalNutrient: Nutrient().copyWith(protein: 180, carb: 145, fat: 75),
          goal: 2200));
      when(() => plan.totalCal).thenReturn(1000);
    });

    // group("calls", () {
    //   testWidgets("AppLogoutRequested when logout out is pressed",
    //       (tester) async {
    //     await mockNetworkImages(() async {
    //       await tester.pumpWidget(BlocProvider.value(
    //         value: appBloc,
    //         child: const MaterialApp(
    //           home: Home(),
    //         ),
    //       ));
    //       await tester.tap(find.byKey(logoutButtonKey));
    //       verify(() => appBloc.add(AppLogoutRequested())).called(1);
    //     });
    //   }); //"AppLogoutRequested when logout out is pressed"
    // }); //group "calls"

    group("render", () {
      testWidgets("calories circular progress", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.pumpAndSettle(const Duration(seconds: 5));
          expect(find.byKey(circularIndicatorKey), findsOneWidget);
        });
      }); //"calories circular progress"

      group("nutrient linear progress", () {
        testWidgets("protein", (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: planBloc),
                  BlocProvider.value(value: appBloc),
                ],
                child: Home(),
              ),
            ));
            await tester.pumpAndSettle();
            expect(find.byKey(proteinLinearIndicatorKey), findsOneWidget);
          });
        }); //"protein"

        testWidgets("carb", (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: planBloc),
                  BlocProvider.value(value: appBloc),
                ],
                child: Home(),
              ),
            ));
            await tester.pumpAndSettle();
            expect(find.byKey(carbLinearIndicatorKey), findsOneWidget);
          });
        }); //"carb"

        testWidgets("fat", (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: planBloc),
                  BlocProvider.value(value: appBloc),
                ],
                child: Home(),
              ),
            ));
            await tester.pumpAndSettle();
            expect(find.byKey(fatLinearIndicatorKey), findsOneWidget);
          });
        }); //"fat"
      }); //group "nutrient linear progress"

      testWidgets("menu card ListView", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.pumpAndSettle(const Duration(seconds: 5));
          expect(find.byKey(menuCardListViewKey), findsOneWidget);
        });
      }); //"menu card ListView"

      testWidgets("daily water card", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
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
      }); //"daily water card"
    }); //group "render"

    group("action", () {
      testWidgets("when pressed setting icon", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.tap(find.byKey(settingButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(Setting), findsOneWidget);
        });
      }); //"when pressed setting icon"

      testWidgets("when pressed ดูทั้งหมด button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.tap(find.byKey(menuAllButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(Search), findsOneWidget);
        });
      }); //"when pressed ดูทั้งหมด button"

      testWidgets("when pressed remove button", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
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
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
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
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: appBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byKey(addWaterButtonKey));
          await tester.tap(find.byKey(addWaterButtonKey));
          await tester.pumpAndSettle();
          expect(find.text("1"), findsOneWidget);
          await tester.ensureVisible(find.byKey(removeWaterButtonKey));
          await tester.tap(find.byKey(removeWaterButtonKey));
          await tester.pumpAndSettle();
          expect(find.text("0"), findsOneWidget);
        });
      }); //"when pressed add and remove button"
    }); //group "action"
  }); //group "Home Page"
} //main
