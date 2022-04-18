import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppEvent', () {
    group('AppUserChanged', () {
      final user = MockUser();

      test('supports value equality', () {
        expect(
          AppUserChanged(user),
          equals(AppUserChanged(user)),
        );
      });

      test('props are correct', () {
        expect(
          AppUserChanged(user).props,
          equals(<Object?>[user]),
        );
      });
    });
    group('AppLogoutRequested', () {
      test('supports value equality', () {
        expect(
          AppLogoutRequested(),
          equals(AppLogoutRequested()),
        );
      });

      test('props are correct', () {
        expect(
          AppLogoutRequested().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
