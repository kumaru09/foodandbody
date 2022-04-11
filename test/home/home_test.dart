import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/calory.dart';
import 'package:foodandbody/models/exercise_repo.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';
import 'package:foodandbody/screens/home/exercise_list.dart';
import 'package:foodandbody/screens/search/search_page.dart';
import 'package:foodandbody/models/history.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/nutrient.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/screens/setting/setting.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/screens/home/home.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';
import 'package:formz/formz.dart';
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

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class FakeHomeEvent extends Fake implements HomeEvent {}

class FakeHomeState extends Fake implements HomeState {}

class MockPlanRepository extends Mock implements PlanRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  //button
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
  final Info mockInfo = Info(name: 'user', goal: 1600);
  final Calory mockGoal = Calory.dirty(mockInfo.goal.toString());

  group('Home Page', () {
    late AppBloc appBloc;
    late User user;
    late PlanBloc planBloc;
    late MenuCardBloc menuCardBloc;
    late HomeBloc homeBloc;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
      registerFallbackValue<PlanEvent>(FakePlanEvent());
      registerFallbackValue<PlanState>(FakePlanState());
      registerFallbackValue<MenuCardEvent>(FakeMenuCardEvent());
      registerFallbackValue<MenuCardState>(FakeMenuCardState());
      registerFallbackValue<HomeEvent>(FakeHomeEvent());
      registerFallbackValue<HomeState>(FakeHomeState());
    });

    setUp(() async {
      planBloc = MockPlanBloc();
      appBloc = MockAppBloc();
      menuCardBloc = MockMenuCardBloc();
      homeBloc = MockHomeBloc();
      user = MockUser();
      when(() => planBloc.state).thenReturn(PlanState(
        status: PlanStatus.success,
        plan: mockHistory,
        info: mockInfo,
        goal: mockGoal,
        exerciseStatus: FormzStatus.submissionSuccess,
      ));
      when(() => menuCardBloc.state).thenReturn(
          MenuCardState(status: MenuCardStatus.success, fav: mockMenuCard));
      when(() => homeBloc.state).thenReturn(HomeState(
          status: HomeStatus.success,
          water: 1,
          exerciseList: mockExerciseList));
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    group("render", () {
      testWidgets("calories circular progress", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: menuCardBloc),
                BlocProvider.value(value: homeBloc),
              ],
              child: Home(),
            ),
          ));
          expect(find.text('แคลอรีวันนี้'), findsOneWidget);
          expect(find.byKey(circularIndicatorKey), findsOneWidget);
        });
      }); //"calories circular progress"

      testWidgets("fail calories circular progress when plan status is failure",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state).thenReturn(PlanState(
            status: PlanStatus.failure,
            plan: mockHistory,
            exerciseStatus: FormzStatus.submissionFailure,
          ));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: menuCardBloc),
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

      testWidgets("menu card", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
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

      testWidgets("fail daily water card when home status is failure",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => homeBloc.state)
              .thenReturn(HomeState(status: HomeStatus.failure));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.pumpAndSettle();
          expect(find.text('น้ำวันนี้'), findsOneWidget);
          expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
          expect(find.text('ลองอีกครั้ง'), findsOneWidget);
        });
      });

      testWidgets("exercise list", (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
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

      testWidgets("fail exercise list when exerciseStatus is failure",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state).thenReturn(PlanState(
              exerciseStatus: FormzStatus.submissionFailure,
              plan: mockHistory));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          expect(find.text('ออกกำลังกาย'), findsOneWidget);
          expect(find.text('เพิ่มการออกกำลังกาย'), findsNothing);
          expect(find.text('exerciseName'), findsNothing);
          expect(find.byType(ExerciseList), findsNothing);
          expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
          expect(find.text('ลองอีกครั้ง'), findsOneWidget);
        });
      });

      testWidgets("dialog add exercise list when pressed add exercise icon",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MultiRepositoryProvider(
              providers: [
                RepositoryProvider<PlanRepository>(
                    create: (_) => MockPlanRepository()),
                RepositoryProvider<UserRepository>(
                    create: (_) => MockUserRepository()),
              ],
              child: MaterialApp(
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: planBloc),
                    BlocProvider.value(value: homeBloc),
                    BlocProvider.value(value: menuCardBloc),
                  ],
                  child: Home(),
                ),
              )));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          expect(find.text('เพิ่มการออกกำลังกาย'), findsOneWidget);
          await tester.tap(find.text('เพิ่มการออกกำลังกาย'));
          await tester.pumpAndSettle();
          expect(find.byKey(Key("home_add_exercise_dialog")), findsOneWidget);
        });
      });
    }); //group "render"

    group("action", () {
      testWidgets("call DecreaseWaterEvent when pressed remove button",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
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

      testWidgets("call IncreaseWaterEvent when pressed add button",
          (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
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

      testWidgets("call LoadPlan when pressed try again at circle indicator",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state).thenReturn(
              PlanState(status: PlanStatus.failure, plan: mockHistory));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.tap(find.byKey(Key('home_tryAgain_button_circle')));
          await tester.pumpAndSettle();
          verify(() => planBloc.add(LoadPlan())).called(1);
        });
      });

      testWidgets("call LoadPlan when pressed try again at exercise list",
          (tester) async {
        await mockNetworkImages(() async {
          when(() => planBloc.state).thenReturn(PlanState(
              exerciseStatus: FormzStatus.submissionFailure,
              plan: mockHistory));
          await tester.pumpWidget(MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: planBloc),
                BlocProvider.value(value: homeBloc),
                BlocProvider.value(value: menuCardBloc),
              ],
              child: Home(),
            ),
          ));
          await tester.dragFrom(Offset(0, 300), Offset(0, -300));
          await tester.tap(find.byKey(Key('home_tryAgain_button_exercise')));
          verify(() => planBloc.add(LoadPlan())).called(1);
        });
      });
    }); //group "action"
  }); //group "Home Page"
} //main