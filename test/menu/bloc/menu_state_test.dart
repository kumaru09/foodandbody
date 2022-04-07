import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/near_restaurant.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';

void main() {
  final List<NearRestaurant> mockNearRestaurant = [NearRestaurant(name: 'ร้านอาหาร1')];
  final MenuShow mockMenu = MenuShow(name: "อาหาร", calory: 300, protein: 30, carb: 20, fat: 10, serve: 1, unit: "จาน");

  group('MenuState', () {

    MenuState createSubject({
      MenuStatus status = MenuStatus.initial,
      MenuShow? menu,
      List<NearRestaurant>? nearRestaurant,
    }) {
      return MenuState(
        status: status,
        menu: menu ?? mockMenu,
        nearRestaurant: nearRestaurant ?? mockNearRestaurant,
      );
    }

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('supports value comparison', () {
      expect(MenuState(), MenuState());
      expect(
        MenuState().toString(),
        MenuState().toString(),
      );
    });

    test('props are correct', () {
      expect(
        createSubject(
          status: MenuStatus.initial,
          menu: mockMenu,
          nearRestaurant: mockNearRestaurant,
        ).props,
        equals(<Object?>[
          MenuStatus.initial, // status
          mockMenu, // menu
          mockNearRestaurant, // nearRestaurant
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
            nearRestaurant: null,
            menu: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: MenuStatus.success,
            menu: mockMenu,
            nearRestaurant: [],
          ),
          equals(
            createSubject(
              status: MenuStatus.success,
              menu: mockMenu,
              nearRestaurant: [],
            ),
          ),
        );
      });
    });
  });
}