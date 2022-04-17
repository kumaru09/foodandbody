import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppState', () { 
    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, User.empty);
      });
    });

    group('initialize', () {
      test('has correct status', () {
        final user = MockUser();
        final state = AppState.initialize(user);
        expect(state.status, AppStatus.initialize);
        expect(state.user, user);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final user = MockUser();
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });
    });

    group('notverified', () {
      test('has correct status', () {
        final user = MockUser();
        final state = AppState.notverified(user);
        expect(state.status, AppStatus.notverified);
        expect(state.user, user);
      });
    });
  });
}
