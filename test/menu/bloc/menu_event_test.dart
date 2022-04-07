import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';

void main() {
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
  });
}