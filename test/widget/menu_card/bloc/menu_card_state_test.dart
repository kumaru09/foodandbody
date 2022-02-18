import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_list.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';

void main() {
  final List<MenuList> mockMenuList = [MenuList(name: 'menuName1', calory: 450, imageUrl: '')];
  group('MenuCardState', () {

    MenuCardState createSubject({
      MenuCardStatus status = MenuCardStatus.initial,
      List<MenuList>? fav,
      List<MenuList>? myFav,
    }) {
      return MenuCardState(
        status: status,
        fav: fav ?? mockMenuList,
        myFav: myFav ?? mockMenuList,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(MenuCardState(), MenuCardState());
      expect(
        MenuCardState().toString(),
        MenuCardState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: MenuCardStatus.initial,
          fav: mockMenuList,
          myFav: mockMenuList,
        ).props,
        equals(<Object?>[
          MenuCardStatus.initial, // status
          mockMenuList, // fav
          mockMenuList, // myFav
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            fav: null,
            myFav: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: MenuCardStatus.success,
            fav: [],
            myFav: [],
          ),
          equals(
            createSubject(
              status: MenuCardStatus.success,
              fav: [],
              myFav: [],
            ),
          ),
        );
      });
    });
  });
}

