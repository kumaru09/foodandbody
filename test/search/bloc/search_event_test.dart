import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/search/bloc/search_bloc.dart';

void main() {
  group('SearchEvent', () {

    final mockText = 'ชื่ออาหาร';
    final mockFilter = ['ทอด', 'ผัด'];

    group('ReFetched', () {
      test('supports value equality', () {
        expect(
          ReFetched(),
          equals(ReFetched()),
        );
      });

      test('props are correct', () {
        expect(
          ReFetched().props,
          equals(<Object?>[]),
        );
      });
    });

    group('TextChanged', () {
      test('supports value equality', () {
        expect(
          TextChanged(
            text: mockText,
            selectFilter: mockFilter,
          ),
          equals(
            TextChanged(
              text: mockText,
              selectFilter: mockFilter,
            ),
          ),
        );
      });

      test('props are correct', () {
        expect(
          TextChanged(
            text: mockText,
            selectFilter: mockFilter,
          ).props,
          equals(<Object?>[
            mockText, // text
            mockFilter, // selectFilter
          ]),
        );
      });
    });
  });
}
