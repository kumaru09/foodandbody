import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/screens/menu/menu.dart';
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
  final mockMenuCard = [
    MenuList(name: 'menuName1', calory: 150, imageUrl: 'testUrl1'),
    MenuList(name: 'menuName2', calory: 250, imageUrl: 'testUrl2'),
    MenuList(name: 'menuName3', calory: 350, imageUrl: 'testUrl3'),
    MenuList(name: 'menuName4', calory: 450, imageUrl: 'testUrl4'),
    MenuList(name: 'menuName5', calory: 550, imageUrl: 'testUrl5'),
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
        'renders no menuCards text '
        'when menuCard status is success but with 0 menuCards', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState(
        status: MenuCardStatus.success,
        menu: [],
      ));
      await tester.pumpMenuCardList(menuCardBloc);
      expect(find.text('ไม่พบเมนู'), findsOneWidget);
    });

    // testWidgets('renders 5 menuCards ', (tester) async {
    //   mockNetworkImagesFor(() async {
    //     when(() => menuCardBloc.state).thenReturn(MenuCardState(
    //       status: MenuCardStatus.success,
    //       menu: mockMenuCard,
    //     ));
    //     await tester.pumpMenuCardList(menuCardBloc);
    //     expect(find.byType(MenuCardItem), findsNWidgets(5));
    //   });
    // });

    testWidgets('go to menu when pressed menu card', (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuCardBloc.state).thenReturn(MenuCardState(
          status: MenuCardStatus.success,
          menu: mockMenuCard,
        ));
        await tester.pumpMenuCardList(menuCardBloc);
        expect(find.byType(Menu), findsNothing);
        await tester.tap(find.text('menuName1'));
        await tester.pumpAndSettle();
        expect(find.byType(Menu), findsOneWidget);
      });
    });
  });
}
