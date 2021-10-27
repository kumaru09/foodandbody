import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card_list.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class FakeMenuCardState extends Fake implements MenuCardState {}

class FakeMenuCardEvent extends Fake implements MenuCardEvent {}

class MockMenuCardBloc extends MockBloc<MenuCardEvent, MenuCardState>
    implements MenuCardBloc {}

extension on WidgetTester {
  Future<void> pumpMenuCardList(MenuCardBloc menuCardBloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: menuCardBloc,
          child: MenuCardList(),
        ),
      ),
    );
  }
}

void main() {
  const mockMenuCard = [
    MenuList(name: 'menuName1', calory: 150, imageUrl: 'testUrl1'),
    MenuList(name: 'menuName2', calory: 250, imageUrl: 'testUrl2'),
    MenuList(name: 'menuName3', calory: 350, imageUrl: 'testUrl3'),
    MenuList(name: 'menuName4', calory: 450, imageUrl: 'testUrl4'),
    MenuList(name: 'menuName5', calory: 550, imageUrl: 'testUrl5'),
    MenuList(name: 'menuName6', calory: 550, imageUrl: 'testUrl6'),
  ];

  late MenuCardBloc menuCardBloc;

  setUpAll(() {
    registerFallbackValue<MenuCardState>(FakeMenuCardState());
    registerFallbackValue<MenuCardEvent>(FakeMenuCardEvent());
  });

  setUp(() {
    menuCardBloc = MockMenuCardBloc();
  });

  group('MenuCardList', () {
    testWidgets(
        'renders CircularProgressIndicator '
        'when menuCard status is initial', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState());
      await tester.pumpMenuCardList(menuCardBloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders fetch fail text '
        'when menuCard status is failure', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState(
        status: MenuCardStatus.failure,
        menu: [],
      ));
      await tester.pumpMenuCardList(menuCardBloc);
      expect(find.text('failed to fetch menu'), findsOneWidget);
    });

    testWidgets(
        'renders no menuCards text '
        'when menuCard status is success but with 0 menuCards', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState(
        status: MenuCardStatus.success,
        menu: [],
      ));
      await tester.pumpMenuCardList(menuCardBloc);
      expect(find.text('ไม่พบเมนู'), findsOneWidget);
    });

    testWidgets('renders 5 menuCards ', (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuCardBloc.state).thenReturn(const MenuCardState(
          status: MenuCardStatus.success,
          menu: mockMenuCard,
        ));
        await tester.pumpMenuCardList(menuCardBloc);
        expect(find.text('menuName1'), findsOneWidget);
        expect(find.text('menuName2'), findsOneWidget);
        expect(find.text('menuName3'), findsOneWidget);
        expect(find.text('menuName4'), findsOneWidget);
        await tester.drag(find.byType(ListView),const Offset(-300, 0));
        await tester.pump();
        expect(find.text('menuName5'), findsOneWidget);
        expect(find.text('menuName6'), findsNothing);
      });
    });

    // testWidgets('go to menu page when pressed menu card', (tester) async {
    //   mockNetworkImagesFor(() async {
    //     when(() => menuCardBloc.state).thenReturn(const MenuCardState(
    //       status: MenuCardStatus.success,
    //       menu: mockMenuCard,
    //     ));
    //     await tester.pumpMenuCardList(menuCardBloc);
    //     expect(find.byType(MenuPage), findsNothing);
    //     await tester.tap(find.text('menuName1'));
    //     await tester.pumpAndSettle(const Duration(seconds: 5));
    //     expect(find.byType(MenuPage), findsOneWidget);
    //     // expect(find.text('menuName1'), findsOneWidget);
    //     // expect(find.text('menuName2'), findsNothing);
    //   });
    // });
  });
}
