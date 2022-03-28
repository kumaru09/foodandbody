import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/history/bloc/history_bloc.dart';

void main() {
  group('HistoryEvent', () {
    group('LoadHistory', () {
      test('supports value equality', () {
        expect(
          LoadHistory(),
          equals(LoadHistory()),
        );
      });

      test('props are correct', () {
        expect(
          LoadHistory().props,
          equals(<Object?>[]),
        );
      });
    });

    group('LoadMenuList', () {
      test('supports value equality', () {
        expect(
          LoadMenuList(dateTime: DateTime(2022)),
          equals(
            LoadMenuList(dateTime: DateTime(2022)),
          ),
        );
      });

      test('props are correct', () {
        expect(
          LoadMenuList(dateTime: DateTime(2022)).props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
