import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';

void main() {
  group('MenuEvent', () {
    group('MenuFetched', () {
      test('supports value comparison', () {
        expect(MenuFetched(), MenuFetched());
      });
    });
  });
}