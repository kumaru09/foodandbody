import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/widget/menu_card/bloc/menu_card_bloc.dart';

void main() {
  group('MenuCardEvent', () {
    test('supports value comparison', () {
      expect(FetchedFavMenuCard(), FetchedFavMenuCard());
      expect(FetchedMyFavMenuCard(), FetchedMyFavMenuCard());
      expect(ReFetchedFavMenuCard(), ReFetchedFavMenuCard());
      expect(ReFetchedMyFavMenuCard(), ReFetchedMyFavMenuCard());
    });
  });
}
