import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';

void main() {
  const String name = 'name';
  const bool isEatNow = true;
  const double volumn = 2;
  const double oldVolume = 1;

  group('MenuEvent', () {
    group('MenuFetched', () {
      test('supports value equality', () {
        expect(
          MenuFetched(),
          equals(MenuFetched()),
        );
      });

      test('props are correct', () {
        expect(
          MenuFetched().props,
          equals(<Object?>[]),
        );
      });
    });

    group('MenuReFetched', () {
      test('supports value equality', () {
        expect(
          MenuReFetched(),
          equals(MenuReFetched()),
        );
      });

      test('props are correct', () {
        expect(
          MenuReFetched().props,
          equals(<Object?>[]),
        );
      });
    });

    group('AddMenu', () {
      test('supports value equality', () {
        expect(
          AddMenu(
            name: name,
            isEatNow: isEatNow,
            volumn: volumn,
            oldVolume: oldVolume,
          ),
          equals(AddMenu(
            name: name,
            isEatNow: isEatNow,
            volumn: volumn,
            oldVolume: oldVolume,
          )),
        );
      });

      test('props are correct', () {
        expect(
          AddMenu(
            name: name,
            isEatNow: isEatNow,
            volumn: volumn,
            oldVolume: oldVolume,
          ).props,
          equals(<Object?>[name, isEatNow, volumn, oldVolume]),
        );
      });
    });
  });
}
