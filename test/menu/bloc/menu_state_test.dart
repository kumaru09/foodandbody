import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/menu/bloc/menu_bloc.dart';

void main() {
  group('MenuState', () {
    test('supports value comparison', () {
      expect(MenuState(), MenuState());
      expect(
        MenuState().toString(),
        MenuState().toString(),
      );
    });
  });
}
