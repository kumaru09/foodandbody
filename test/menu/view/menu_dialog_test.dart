import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
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
  const sliderKey = Key('menu_dialog_slider');
  const okButtonKey = Key('menu_dialog_ok_button');

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

  group('MenuDialog', () {
    testWidgets('renders dialog correctly', (tester) async {
      when(() => menuBloc.state).thenReturn(MenuState(
        status: MenuStatus.success,
        menu: mockMenu,
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: menuBloc,
            child: MenuDialog(serve: 100, unit: "กรัม", isEatNow: false),
          ),
        ),
      );
      expect(find.text('ปริมาณที่จะกิน'), findsOneWidget);
      expect(find.text('100 กรัม'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('ตกลง'), findsOneWidget);
      expect(find.text('ยกเลิก'), findsOneWidget);
    });

    testWidgets('renders serve depend on slider value', (tester) async {
      when(() => menuBloc.state).thenReturn(MenuState(
        status: MenuStatus.success,
        menu: mockMenu,
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: menuBloc,
            child: MenuDialog(serve: 100, unit: "กรัม", isEatNow: false),
          ),
        ),
      );
      await tester.drag(find.byKey(sliderKey), Offset(100, 0));
      await tester.pump();
      expect(find.text('434 กรัม'), findsOneWidget);
    });

    testWidgets('renders ok button disable when serve is 0', (tester) async {
      when(() => menuBloc.state).thenReturn(MenuState(
        status: MenuStatus.success,
        menu: mockMenu,
      ));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: menuBloc,
            child: MenuDialog(serve: 100, unit: "กรัม", isEatNow: false),
          ),
        ),
      );
      await tester.drag(find.byKey(sliderKey), Offset(-150, 0));
      await tester.pump();
      final textButton = tester.widget<TextButton>(find.byKey(okButtonKey));
      expect(textButton.enabled, isFalse);
    });

    testWidgets('close dialog and MenuDetail when ok is pressed', (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuBloc.state).thenReturn(MenuState(
          status: MenuStatus.success,
          menu: mockMenu,
        ));
        when(() =>
              menuBloc.add(AddMenu(name: "กุ้งเผา", isEatNow: false, volumn: 100)))
          .thenAnswer((_) async {});
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
        expect(find.byKey(okButtonKey), findsOneWidget);
        await tester.tap(find.byKey(okButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(MenuDialog), findsNothing);
      });
    });

    testWidgets('close dialog and back to MenuDetail when cancle is pressed', (tester) async {
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
        await tester.tap(find.text('ยกเลิก'));
        await tester.pumpAndSettle();
        expect(find.byType(MenuDetail), findsOneWidget);
        expect(find.byType(MenuDialog), findsNothing);
      });
    });
  });
}
