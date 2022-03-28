import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';
import 'package:foodandbody/widget/menu_card/menu_card.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class FakeMenuCardState extends Fake implements MenuCardState {}

class FakeMenuCardEvent extends Fake implements MenuCardEvent {}

class MockMenuCardBloc extends MockBloc<MenuCardEvent, MenuCardState>
    implements MenuCardBloc {}

extension on WidgetTester {
  Future<void> pumpMenuCard(MenuCardBloc menuCardBloc, bool isMyFav) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: menuCardBloc,
          child: MenuCard(isMyFav: isMyFav),
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
  ];

  late MenuCardBloc menuCardBloc;

  setUpAll(() {
    registerFallbackValue<MenuCardState>(FakeMenuCardState());
    registerFallbackValue<MenuCardEvent>(FakeMenuCardEvent());
  });

  setUp(() {
    menuCardBloc = MockMenuCardBloc();
  });

  group('MenuCard', () {
    testWidgets(
        'renders CircularProgressIndicator '
        'when menuCard status is initial', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState());
      await tester.pumpMenuCard(menuCardBloc, false);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders refetch text '
        'when menuCard status is failure', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState(
        status: MenuCardStatus.failure,
        fav: [],
        myFav: [],
      ));
      await tester.pumpMenuCard(menuCardBloc, false);
      expect(find.text('ไม่สามารถโหลดเมนูยอดนิยมได้ในขณะนี้'), findsOneWidget);
      await tester.pumpMenuCard(menuCardBloc, true);
      expect(find.text('ไม่สามารถโหลดเมนูที่กินบ่อยได้ในขณะนี้'), findsOneWidget);
    });

    testWidgets(
        'refetch when pressed try again in fail status', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState(
        status: MenuCardStatus.failure,
        fav: [],
        myFav: [],
      ));
      await tester.pumpMenuCard(menuCardBloc, false);
      expect(find.text('ไม่สามารถโหลดเมนูยอดนิยมได้ในขณะนี้'), findsOneWidget);
      expect(find.text('ลองอีกครั้ง'), findsOneWidget);
      await tester.tap(find.text('ลองอีกครั้ง'));
      verify(() => menuCardBloc.add(ReFetchedFavMenuCard())).called(1);
    });

    testWidgets(
        'renders no menuCards text '
        'when menuCard status is success but with 0 menuCards', (tester) async {
      when(() => menuCardBloc.state).thenReturn(const MenuCardState(
        status: MenuCardStatus.success,
        fav: [],
        myFav: [],
      ));
      await tester.pumpMenuCard(menuCardBloc, false);
      expect(find.text('ไม่มีเมนูยอดนิยมในขณะนี้'), findsOneWidget);
      await tester.pumpMenuCard(menuCardBloc, true);
      expect(find.text('ไม่มีเมนูที่กินบ่อยในขณะนี้'), findsOneWidget);
    });

    testWidgets('renders 1-10 menuCards if have data', (tester) async {
      mockNetworkImagesFor(() async {
        when(() => menuCardBloc.state).thenReturn(const MenuCardState(
          status: MenuCardStatus.success,
          fav: mockMenuCard,
          myFav: mockMenuCard,
        ));
        await tester.pumpMenuCard(menuCardBloc, false);
        expect(find.text('menuName1'), findsOneWidget);
        expect(find.text('menuName2'), findsOneWidget);
        expect(find.text('menuName3'), findsOneWidget);
        expect(find.text('menuName4'), findsOneWidget);
        await tester.drag(find.byType(ListView),const Offset(-300, 0));
        await tester.pump();
        expect(find.text('menuName5'), findsOneWidget);
      });
    });

    // testWidgets('go to menu page when pressed menu card', (tester) async {
    //   mockNetworkImagesFor(() async {
    //     when(() => menuCardBloc.state).thenReturn(const MenuCardState(
    //       status: MenuCardStatus.success,
    //       menu: mockMenuCard,
    //     ));
    //     await tester.pumpMenuCard(menuCardBloc);
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
