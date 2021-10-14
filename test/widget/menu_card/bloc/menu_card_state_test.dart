import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';

void main() {
  group('MenuCardState', () {
    test('supports value comparison', () {
      expect(MenuCardState(), MenuCardState());
      expect(
        MenuCardState().toString(),
        MenuCardState().toString(),
      );
    });
  });
}

