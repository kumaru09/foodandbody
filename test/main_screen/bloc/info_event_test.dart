import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/main_screen/bloc/info_bloc.dart';

void main() {
  group('InfoEvent', () {
    group('LoadInfo', () {
      test('supports value equality', () {
        expect(
          LoadInfo(),
          equals(LoadInfo()),
        );
      });

      test('props are correct', () {
        expect(
          LoadInfo().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
