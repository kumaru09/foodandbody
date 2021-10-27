import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/screens/camera/camera.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';
import 'package:foodandbody/screens/menu/menu_detail.dart';
import 'package:foodandbody/screens/menu/menu_dialog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockPlanRepository extends Mock implements PlanRepository {}

class FakeMenuState extends Fake implements MenuState {}

class FakeMenuEvent extends Fake implements MenuEvent {}

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

void main() {
  const addToPlanButtonKey = Key('menu_addToPlan_button');
  const eatNowButtonKey = Key('menu_eatNow_button');
  const takePhotoButtonKey = Key('menu_takePhoto_button');

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
      when(() => menuBloc.state).thenReturn(const MenuState());
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

    testWidgets(
        'renders fetch fail text '
        'when menu status is failure', (tester) async {
      when(() => menuBloc.state).thenReturn(const MenuState(
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
      expect(find.text('failed to fetch menu'), findsOneWidget);
    });

    testWidgets('renders menu when menu status is success', (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuBloc.state).thenReturn(const MenuState(
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
      });
    });

    group('Menu', () {
      testWidgets('renders addToPlan button when isPlanMenu is false',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(const MenuState(
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
        });
      });

      testWidgets('renders dialog when addToPlan button is pressed',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(const MenuState(
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
    });

    group('MenuPlan', () {
      testWidgets(
          'renders eatNow button and takePhoto button when isPlanMenu is true',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(const MenuState(
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
          expect(find.byKey(eatNowButtonKey), findsOneWidget);
          expect(find.byKey(takePhotoButtonKey), findsOneWidget);
        });
      });

      testWidgets('renders dialog when eatNow button is pressed',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(const MenuState(
            status: MenuStatus.success,
            menu: mockMenu,
          ));
          await tester.pumpWidget(
            RepositoryProvider<PlanRepository>(
              create: (_) => MockPlanRepository(),
              child: MaterialApp(
                home: BlocProvider.value(
                  value: menuBloc,
                  child: MenuDetail(isPlanMenu: true),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(eatNowButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(MenuDialog), findsOneWidget);
        });
      });

      testWidgets('renders Camera when takePhoto button is pressed',
          (tester) async {
        mockNetworkImagesFor(() async {
          when(() => menuBloc.state).thenReturn(const MenuState(
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
          await tester.tap(find.byKey(takePhotoButtonKey));
          await tester.pumpAndSettle();
          expect(find.byType(Camera), findsOneWidget);
        });
      });
    });
  });
}
