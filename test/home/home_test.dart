import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';
import 'package:foodandbody/screens/home/exercise_list.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/setting/bloc/info_bloc.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';
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

class MockInfo extends Mock implements Info {}

class MockMenuCardBloc extends MockBloc<MenuCardEvent, MenuCardState>
    implements MenuCardBloc {}

class FakeMenuCardEvent extends Fake implements MenuCardEvent {}

class FakeMenuCardState extends Fake implements MenuCardState {}

class MockInfoBloc extends MockBloc<InfoEvent, InfoState> implements InfoBloc {}

class FakeInfoEvent extends Fake implements InfoEvent {}

class FakeInfoState extends Fake implements InfoState {}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class FakeHomeEvent extends Fake implements HomeEvent {}

class FakeHomeState extends Fake implements HomeState {}

class MockPlanRepository extends Mock implements PlanRepository {}

void main() {
  //button
  const settingButtonKey = Key('setting_button');
  const menuAllButtonKey = Key('menu_all_button');
  const removeWaterButtonKey = Key('remove_water_button');
  const addWaterButtonKey = Key('add_water_button');

  //widget
  const circularIndicatorKey = Key('home_calories_circular');
  const dailyWaterCardKey = Key('daily_water_card');
  const dailyWaterDisplayKey = Key('daily_water_display');

  final DateTime mockDate = DateTime.now();
  final List<MenuList> mockMenuCard = [
    MenuList(name: 'อาหาร1', calory: 100, imageUrl: 'imageUrl1')
  ];
  final List<ExerciseRepo> mockExerciseList = [
    ExerciseRepo(
      id: 'id',
      name: 'exerciseName',
      min: 30,
      calory: 300,
      timestamp: Timestamp.fromDate(mockDate),
    )
  ];
  final Nutrient mockNutrientList = Nutrient(protein: 20, carb: 20, fat: 20);
  final History mockHistory = History(Timestamp.fromDate(mockDate),
      totalCal: 100,
      totalBurn: 100,
      totalWater: 1,
      totalNutrientList: mockNutrientList,
      exerciseList: mockExerciseList);
  final Info mockInfo = Info(name: 'user', goal: 1000);

  group('Home Page', () {
    late AppBloc appBloc;
    late User user;
    late PlanBloc planBloc;
    // late History plan;
    // late Info info;
    late MenuCardBloc menuCardBloc;
    late InfoBloc infoBloc;
    late HomeBloc homeBloc;
    late PlanRepository planRepository;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<PlanEvent>(FakePlanEvent());
      registerFallbackValue<PlanState>(FakePlanState());
      registerFallbackValue<MenuCardEvent>(FakeMenuCardEvent());
      registerFallbackValue<MenuCardState>(FakeMenuCardState());
      registerFallbackValue<InfoEvent>(FakeInfoEvent());
      registerFallbackValue<InfoState>(FakeInfoState());
      registerFallbackValue<HomeEvent>(FakeHomeEvent());
      registerFallbackValue<HomeState>(FakeHomeState());
    });

    setUp(() async {
      planBloc = MockPlanBloc();
      appBloc = MockAppBloc();
      menuCardBloc = MockMenuCardBloc();
      infoBloc = MockInfoBloc();
      homeBloc = MockHomeBloc();
      planRepository = MockPlanRepository();
      user = MockUser();
      when(() => planBloc.state)
          .thenReturn(PlanState(status: PlanStatus.success, plan: mockHistory));
      when(() => infoBloc.state)
          .thenReturn(InfoState(status: InfoStatus.success, info: mockInfo));
      when(() => menuCardBloc.state).thenReturn(
          MenuCardState(status: MenuCardStatus.success, fav: mockMenuCard));
      when(() => homeBloc.state).thenReturn(HomeState(
          status: HomeStatus.success,
          water: 1,
          exerciseList: mockExerciseList));
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      // when(() => plan.totalNutrientList)
      //     .thenReturn(Nutrient().copyWith(protein: 120, carb: 80, fat: 30));
      when(() => user.info).thenReturn(Info(
          goalNutrient: Nutrient().copyWith(protein: 180, carb: 145, fat: 75),
          goal: 2200));
      // when(() => plan.totalCal).thenReturn(1000);
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
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
                BlocProvider.value(value: homeBloc),
              ],
              child: Home(),
            ),
          ));
          expect(find.text('แคลอรีวันนี้'), findsOneWidget);
          expect(find.byKey(circularIndicatorKey), findsOneWidget);
        });
      }); //"calories circular progress"

      testWidgets("fail calories circular progress when plan status is failure", (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state)
          .thenReturn(PlanState(status: PlanStatus.failure, plan: mockHistory));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
                BlocProvider.value(value: homeBloc),
              ],
              child: Home(),
            ),
          ));
          expect(find.text('แคลอรีวันนี้'), findsOneWidget);
          expect(find.byKey(circularIndicatorKey), findsNothing);
          expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsNWidgets(2));
          expect(find.text('ลองอีกครั้ง'), findsNWidgets(2));
        });
      });

      testWidgets("fail calories circular progress when info status is failure", (tester) async {
        await mockNetworkImages(() async {
          when(() => infoBloc.state)
          .thenReturn(InfoState(status: InfoStatus.failure));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
                BlocProvider.value(value: homeBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.pumpAndSettle();
          expect(find.text('แคลอรีวันนี้'), findsOneWidget);
          expect(find.byKey(circularIndicatorKey), findsNothing);
          expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
          expect(find.text('ลองอีกครั้ง'), findsOneWidget);
        });
      });

      testWidgets("menu card", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          expect(find.text('เมนูยอดนิยม'), findsOneWidget);
          expect(find.text('ดูทั้งหมด'), findsOneWidget);
          expect(find.byType(MenuCard), findsOneWidget);
          expect(find.text('อาหาร1'), findsOneWidget);
        });
      }); //"menu card ListView"

      testWidgets("daily water card", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.pumpAndSettle();
          expect(find.text('น้ำวันนี้'), findsOneWidget);
          expect(find.text('1'), findsOneWidget);
          expect(find.byKey(dailyWaterCardKey), findsOneWidget);
          await tester.pumpAndSettle();
          expect(find.byKey(removeWaterButtonKey), findsOneWidget);
          expect(find.byKey(dailyWaterDisplayKey), findsOneWidget);
          expect(find.byKey(addWaterButtonKey), findsOneWidget);
        });
      }); //"daily water card"

      testWidgets("exercise list", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          expect(find.text('ออกกำลังกาย'), findsOneWidget);
          expect(find.text('เพิ่มการออกกำลังกาย'), findsOneWidget);
          expect(find.text('exerciseName'), findsOneWidget);
          expect(find.byType(ExerciseList), findsOneWidget);
        });
      });

      testWidgets("fail exercise list when plan status is failure", (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state)
          .thenReturn(PlanState(status: PlanStatus.failure, plan: mockHistory));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          expect(find.text('ออกกำลังกาย'), findsOneWidget);
          expect(find.text('เพิ่มการออกกำลังกาย'), findsNothing);
          expect(find.text('exerciseName'), findsNothing);
          expect(find.byType(ExerciseList), findsNothing);
          expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsNWidgets(2));
          expect(find.text('ลองอีกครั้ง'), findsNWidgets(2));
        });
      });

      testWidgets("dialog add exercise list when pressed add exercise icon", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          expect(find.text('เพิ่มการออกกำลังกาย'), findsOneWidget);
          await tester.tap(find.text('เพิ่มการออกกำลังกาย'));
          await tester.pumpAndSettle();
          expect(find.byKey(Key("home_add_exercise_dialog")), findsOneWidget);
        });
      });
    }); //group "render"

    group("action", () {
      // testWidgets("when pressed setting icon", (tester) async {
      //   await mockNetworkImages(() async {
      //     await tester.pumpWidget(MaterialApp(
      //       home: MultiBlocProvider(
      //         providers: [
      //           BlocProvider.value(value: planBloc),
      //           BlocProvider.value(value: homeBloc),
      //           BlocProvider.value(value: appBloc),
      //           BlocProvider.value(value: menuCardBloc),
      //           BlocProvider.value(value: infoBloc),
      //         ],
      //         child: Home(),
      //       ),
      //     ));
      //     await tester.tap(find.byKey(settingButtonKey));
      //     await tester.pumpAndSettle();
      //     expect(find.byType(Setting), findsOneWidget);
      //   });
      // }); //"when pressed setting icon"

      // testWidgets("when pressed ดูทั้งหมด button", (tester) async {
      //   await mockNetworkImages(() async {
      //     await tester.pumpWidget(MaterialApp(
      //       home: MultiBlocProvider(
      //         providers: [
      //           BlocProvider.value(value: planBloc),
      //           BlocProvider.value(value: homeBloc),
      //           BlocProvider.value(value: menuCardBloc),
      //           BlocProvider.value(value: infoBloc),
      //         ],
      //         child: Home(),
      //       ),
      //     ));
      //     await tester.tap(find.byKey(menuAllButtonKey));
      //     await tester.pumpAndSettle();
      //     expect(find.byType(SearchPage), findsOneWidget);
      //   });
      // }); //"when pressed ดูทั้งหมด button"

      testWidgets("call home bloc function when pressed remove button",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.tap(find.byKey(removeWaterButtonKey));
          await tester.pumpAndSettle();
          verify(() => homeBloc.add(DecreaseWaterEvent())).called(1);
          verify(() => homeBloc.add(WaterChanged(water: 0))).called(1);
        });
      }); //"when pressed remove button"

      testWidgets("call home bloc function when pressed add button",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.tap(find.byKey(addWaterButtonKey));
          await tester.pumpAndSettle();
          verify(() => homeBloc.add(IncreaseWaterEvent())).called(1);
          verify(() => homeBloc.add(WaterChanged(water: 2))).called(1);
        });
      }); //"when pressed add button"

      testWidgets("call refresh function when drag screen down",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 500), Offset(0, 100));
          await tester.pumpAndSettle();
          verify(() => menuCardBloc.add(ReFetchedFavMenuCard())).called(1);
          verify(() => planBloc.add(LoadPlan())).called(1);
          verify(() => homeBloc.add(LoadWater())).called(1);
        });
      });

      testWidgets("call plan bloc when pressed try again at circle indicator",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state)
          .thenReturn(PlanState(status: PlanStatus.failure, plan: mockHistory));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.tap(find.byKey(Key('home_tryAgain_button_circle')));
          await tester.pumpAndSettle();
          verify(() => planBloc.add(LoadPlan())).called(1);
        });
      });

      testWidgets("call info bloc when pressed try again at circle indicator",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => infoBloc.state)
          .thenReturn(InfoState(status: InfoStatus.failure));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.tap(find.text('ลองอีกครั้ง'));
          await tester.pumpAndSettle();
          verify(() => infoBloc.add(LoadInfo())).called(1);
        });
      });

      testWidgets("call plan bloc when pressed try again at exercise list",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state)
          .thenReturn(PlanState(status: PlanStatus.failure, plan: mockHistory));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: infoBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.tap(find.byKey(Key('home_tryAgain_button_exercise')));
          await tester.pumpAndSettle();
          verify(() => planBloc.add(LoadPlan())).called(1);
        });
      });
    }); //group "action"
  }); //group "Home Page"
} //main
