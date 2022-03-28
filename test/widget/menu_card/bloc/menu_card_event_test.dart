import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';

void main() {
  group('SearchEvent', () {
    group('FetchedFavMenuCard', () {
      test('supports value equality', () {
        expect(
          FetchedFavMenuCard(),
          equals(FetchedFavMenuCard()),
        );
      });

      test('props are correct', () {
        expect(
          FetchedFavMenuCard().props,
          equals(<Object?>[]),
        );
      });
    });

    group('FetchedMyFavMenuCard', () {
      test('supports value equality', () {
        expect(
          FetchedMyFavMenuCard(),
          equals(FetchedMyFavMenuCard()),
        );
      });

      test('props are correct', () {
        expect(
          FetchedMyFavMenuCard().props,
          equals(<Object?>[]),
        );
      });
    });

    group('ReFetchedFavMenuCard', () {
      test('supports value equality', () {
        expect(
          ReFetchedFavMenuCard(),
          equals(ReFetchedFavMenuCard()),
        );
      });

      test('props are correct', () {
        expect(
          ReFetchedFavMenuCard().props,
          equals(<Object?>[]),
        );
      });
    });

    group('ReFetchedMyFavMenuCard', () {
      test('supports value equality', () {
        expect(
          ReFetchedMyFavMenuCard(),
          equals(ReFetchedMyFavMenuCard()),
        );
      });

      test('props are correct', () {
        expect(
          ReFetchedMyFavMenuCard().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
