import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';

void main() {
  group('MenuCardEvent', () {
    group('MenuCardFetched', () {
      test('supports value comparison', () {
        expect(MenuCardFetched(), MenuCardFetched());
      });
    });
  });
}

