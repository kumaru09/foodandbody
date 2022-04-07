import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/near_restaurant.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:foodandbody/screens/menu/menu_detail.dart';
import 'package:foodandbody/screens/menu/menu_dialog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockPlanRepository extends Mock implements PlanRepository {}

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

class FakeMenuState extends Fake implements MenuState {}

class FakeMenuEvent extends Fake implements MenuEvent {}

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

void main() {
  const addToPlanButtonKey = Key('menu_addToPlan_button');
  const eatNowButtonKeyPlan = Key('menu_eatNow_outlinedButton');
  const eatNowButtonKeyMenu = Key('menu_eatNow_elevatedButton');
  const takePhotoButtonKey = Key('menu_takePhoto_button');
  const menuColumn = Key('menu_column');
  const dialogOkButtonKey = Key('menu_dialog_ok_button');
  const nearRestaurantImage = Key('nearRestaurant_image');

  late MenuBloc menuBloc;

  const mockMenu = MenuShow(
      name: "กุ้งเผา",
      calory: 96,
      protein: 18.7,
      carb: 0.3,
      fat: 0,
      serve: 100,
      unit: "กรัม",
      imageUrl: "https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg");
  final mockMenuPlan = Menu(
      name: "กุ้งเผา",
      calories: 96,
      protein: 18.7,
      carb: 0.3,
      fat: 0,
      serve: 100,
      volumn: 100);
  const nearRestaurant = [
    NearRestaurant(name: "ร้านอาหาร1"),
    NearRestaurant(name: "ร้านอาหาร2"),
  ];

  setUpAll(() {
    registerFallbackValue<MenuState>(FakeMenuState());
    registerFallbackValue<MenuEvent>(FakeMenuEvent());
  });

  setUp(() {
    menuBloc = MockMenuBloc();
  });

  group('MenuDetail', () {
    testWidgets(
        'renders CircularProgressIndicator '
        'when menu status is initial', (tester) async {
      when(() => menuBloc.state).thenReturn(MenuState());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: menuBloc,
            child: MenuDetail(isPlanMenu: false),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders fetch fail when menu status is failure',
        (tester) async {
      when(() => menuBloc.state).thenReturn(MenuState(
        status: MenuStatus.failure,
        menu: MenuShow(),
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: menuBloc,
            child: MenuDetail(isPlanMenu: false),
          ),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets(
        'call MenuFetch event when pressed try again button in failure status',
        (tester) async {
      when(() => menuBloc.state).thenReturn(MenuState(
        status: MenuStatus.failure,
        menu: MenuShow(),
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: menuBloc,
            child: MenuDetail(isPlanMenu: false),
          ),
        ),
      );
      await tester.tap(find.byType(OutlinedButton));
      await tester.pumpAndSettle();
      verify(() => menuBloc.add(MenuFetched())).called(1);
    });

    testWidgets('renders menu when menu status is success', (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuBloc.state).thenReturn(MenuState(
          status: MenuStatus.success,
          menu: mockMenu,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: menuBloc,
              child: MenuDetail(isPlanMenu: false),
            ),
          ),
        );
        expect(find.byType(Image), findsOneWidget);
        expect(find.text('96 แคล'), findsOneWidget);
        expect(find.text('100 กรัม'), findsOneWidget);
        expect(find.text('18.7 กรัม'), findsOneWidget);
        expect(find.text('0.3 กรัม'), findsOneWidget);
        expect(find.text('0 กรัม'), findsOneWidget);
        expect(find.text('ร้านใกล้คุณ'), findsOneWidget);
      });
    });

    testWidgets('renders no restaurant text when no restaurant result',
        (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuBloc.state).thenReturn(MenuState(
          status: MenuStatus.success,
          menu: mockMenu,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: menuBloc,
              child: MenuDetail(isPlanMenu: false),
            ),
          ),
        );
        expect(find.text('ร้านใกล้คุณ'), findsOneWidget);
        expect(find.text('ไม่มีร้านใกล้คุณในขณะนี้'), findsOneWidget);
      });
    });

    testWidgets('renders restaurant list when have restaurant result',
        (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuBloc.state).thenReturn(MenuState(
          status: MenuStatus.success,
          menu: mockMenu,
          nearRestaurant: nearRestaurant,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: menuBloc,
              child: MenuDetail(isPlanMenu: false),
            ),
          ),
        );
        expect(find.text('ร้านใกล้คุณ'), findsOneWidget);
        expect(find.text('ไม่มีร้านใกล้คุณในขณะนี้'), findsNothing);
        expect(find.text('ร้านอาหาร1'), findsOneWidget);
        expect(find.text('ร้านอาหาร2'), findsOneWidget);
        expect(find.byKey(nearRestaurantImage), findsNWidgets(2));
      });
    });

    testWidgets(
        'call MenuReFetched event when drag down to refresh page in success status',
        (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuBloc.state).thenReturn(MenuState(
          status: MenuStatus.success,
          menu: mockMenu,
        ));
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: menuBloc,
              child: MenuDetail(isPlanMenu: false),
            ),
          ),
        );
        await tester.drag(find.byKey(menuColumn), const Offset(0, 500));
        await tester.pumpAndSettle();
        verify(() => menuBloc.add(MenuReFetched())).called(1);
      });
    });

    // testWidgets('renders fail addMenu widget when AddMenuStatus failure',
    //     (tester) async {
    //   mockNetworkImagesFor(() async {
    //     when(()=> menuBloc.state).thenReturn(MenuState());
    //     whenListen(menuBloc, Stream.fromIterable(<MenuState>[
    //       MenuState(
    //         status: MenuStatus.success,
    //         menu: mockMenu,
    //         nearRestaurant: nearRestaurant,
    //         addMenuStatus: AddMenuStatus.initial,
    //       ),
    //       MenuState(
    //         status: MenuStatus.success,
    //         menu: mockMenu,
    //         nearRestaurant: nearRestaurant,
    //         addMenuStatus: AddMenuStatus.failure,
    //       ),
    //     ]));
    //     await tester.pumpWidget(
    //       MaterialApp(
    //         home: BlocProvider.value(
    //           value: menuBloc,
    //           child: MenuDetail(isPlanMenu: false),
    //         ),
    //       ),
    //     );
    //     await tester.pumpAndSettle(Duration(seconds: 2));
    //     expect(find.byType(AlertDialog), findsOneWidget);
    //     expect(find.byIcon(Icons.report), findsOneWidget);
    //     expect(find.text('เพิ่มเมนูไม่สำเร็จ'), findsOneWidget);
    //     expect(find.text('กรุณาลองอีกครั้ง'), findsOneWidget);
    //   });
    // });

    group('Menu', () {
      testWidgets(
          'renders addToPlan button and eatNow button when isPlanMenu is false',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: menuBloc,
                child: MenuDetail(isPlanMenu: false),
              ),
            ),
          );
          expect(find.byKey(addToPlanButtonKey), findsOneWidget);
          expect(find.byKey(eatNowButtonKeyMenu), findsOneWidget);
        });
      });

      testWidgets('renders dialog when addToPlan button is pressed',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          await tester.pumpWidget(
            RepositoryProvider<PlanRepository>(
              create: (_) => MockPlanRepository(),
              child: MaterialApp(
                home: BlocProvider.value(
                  value: menuBloc,
                  child: MenuDetail(isPlanMenu: false),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(addToPlanButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(MenuDialog), findsOneWidget);
        });
      });

      testWidgets('call addMenu() when add menu to plan', (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          when(() => menuBloc.add(AddMenu(
                name: "กุ้งเผา",
                isEatNow: false,
                volumn: 100,
              ))).thenAnswer((_) async {});
          await tester.pumpWidget(
            RepositoryProvider<PlanRepository>(
              create: (_) => MockPlanRepository(),
              child: MaterialApp(
                home: BlocProvider.value(
                  value: menuBloc,
                  child: MenuDetail(isPlanMenu: false),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(addToPlanButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(MenuDialog), findsOneWidget);
          await tester.tap(find.byKey(dialogOkButtonKey));
          await tester.pumpAndSettle();
          verify(() => menuBloc.add(AddMenu(
                name: "กุ้งเผา",
                isEatNow: false,
                volumn: 100,
              ))).called(1);
        });
      });

      testWidgets('renders dialog when eatNow button is pressed',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          await tester.pumpWidget(
            RepositoryProvider<PlanRepository>(
              create: (_) => MockPlanRepository(),
              child: MaterialApp(
                home: BlocProvider.value(
                  value: menuBloc,
                  child: MenuDetail(isPlanMenu: false),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(eatNowButtonKeyMenu));
          await tester.pumpAndSettle();
          expect(find.byType(MenuDialog), findsOneWidget);
        });
      });

      testWidgets('call addMenu() when eat now', (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          when(() => menuBloc.add(AddMenu(
                name: "กุ้งเผา",
                isEatNow: true,
                volumn: 100,
              ))).thenAnswer((_) async {});
          await tester.pumpWidget(
            RepositoryProvider<PlanRepository>(
              create: (_) => MockPlanRepository(),
              child: MaterialApp(
                home: BlocProvider.value(
                  value: menuBloc,
                  child: MenuDetail(isPlanMenu: false),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(eatNowButtonKeyMenu));
          await tester.pumpAndSettle();
          expect(find.byType(MenuDialog), findsOneWidget);
          await tester.tap(find.byKey(dialogOkButtonKey));
          await tester.pump();
          verify(() => menuBloc.add(AddMenu(
                name: "กุ้งเผา",
                isEatNow: true,
                volumn: 100,
              ))).called(1);
        });
      });
    });

    group('MenuPlan', () {
      testWidgets(
          'renders eatNow button and takePhoto button when isPlanMenu is true',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider.value(
                value: menuBloc,
                child: MenuDetail(isPlanMenu: true),
              ),
            ),
          );
          expect(find.byKey(eatNowButtonKeyPlan), findsOneWidget);
          expect(find.byKey(takePhotoButtonKey), findsOneWidget);
        });
      });

      testWidgets('renders dialog when eatNow button is pressed',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          await tester.pumpWidget(
            RepositoryProvider<PlanRepository>(
              create: (_) => MockPlanRepository(),
              child: MaterialApp(
                home: BlocProvider.value(
                  value: menuBloc,
                  child: MenuDetail(isPlanMenu: true, item: mockMenuPlan),
                ),
              ),
            ),
          );
          expect(find.byKey(eatNowButtonKeyPlan), findsOneWidget);
          await tester.tap(find.byKey(eatNowButtonKeyPlan));
          await tester.pumpAndSettle();
        });
      });

      testWidgets('call addMenu() when eat now', (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          when(() => menuBloc.add(AddMenu(
                name: "กุ้งเผา",
                isEatNow: true,
                volumn: 100,
                oldVolume: 100,
              ))).thenAnswer((_) async {});
          await tester.pumpWidget(
            RepositoryProvider<PlanRepository>(
              create: (_) => MockPlanRepository(),
              child: MaterialApp(
                home: BlocProvider.value(
                  value: menuBloc,
                  child: MenuDetail(isPlanMenu: true, item: mockMenuPlan),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(eatNowButtonKeyPlan));
          await tester.pumpAndSettle();
          expect(find.byType(MenuDialog), findsOneWidget);
          await tester.tap(find.byKey(dialogOkButtonKey));
          await tester.pump();
          verify(() => menuBloc.add(AddMenu(
                name: "กุ้งเผา",
                isEatNow: true,
                volumn: 100,
                oldVolume: 100,
              ))).called(1);
        });
      });

      // testWidgets('renders Camera when takePhoto button is pressed',
      //     (tester) async {
      //   mockNetworkImagesFor(() async {
      //     when(() => menuBloc.state).thenReturn(MenuState(
      //       status: MenuStatus.success,
      //       menu: mockMenu,
      //     ));
      //     await tester.pumpWidget(
      //       RepositoryProvider<PlanRepository>(
      //         create: (_) => MockPlanRepository(),
      //         child: MaterialApp(
      //           home: BlocProvider.value(
      //             value: menuBloc,
      //             child: MenuDetail(isPlanMenu: true, item: mockMenuPlan),
      //           ),
      //         ),
      //       ),
      //     );
      //     expect(find.byType(MenuDetail), findsOneWidget);
      //     await tester.tap(find.byKey(takePhotoButtonKey));
      //     await tester.pump(Duration(seconds: 1));
      //     expect(find.byType(Camera), findsOneWidget);
      //   });
      // });
    });
  });
}
