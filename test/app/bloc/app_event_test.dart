import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppEvent', () {
    group('AppUserChanged', () {
      final user = MockUser();
      test('supports value comparisons', () {
        expect(
          AppUserChanged(user),
          AppUserChanged(user),
        );
      });
    });
    group('AppLogoutRequested', () {
      test('supports value comparisons', () {
        expect(
          AppLogoutRequested(),
          AppLogoutRequested(),
        );
      });
    });
  });
}
