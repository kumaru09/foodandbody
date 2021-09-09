import 'package:bloc_test/bloc_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthenRepository extends Mock implements AuthenRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    final user = MockUser();
    late AuthenRepository authenRepository;

    setUp(() {
      authenRepository = MockAuthenRepository();
      when(() => authenRepository.user).thenAnswer(
        (_) => Stream<User>.empty(),
      );
      when(
        () => authenRepository.currentUser,
      ).thenReturn(User.empty);
    });

    test('initial state is unauthenticated when user is empty', () {
      expect(
        AppBloc(authenRepository: authenRepository).state,
        AppState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not empty',
        build: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => authenRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
          return AppBloc(authenRepository: authenRepository);
        },
        seed: () => AppState.unauthenticated(),
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is empty',
        build: () {
          when(() => authenRepository.user).thenAnswer(
            (_) => Stream.value(User.empty),
          );
          return AppBloc(authenRepository: authenRepository);
        },
        expect: () => [AppState.unauthenticated()],
      );
    });
    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        build: () {
          return AppBloc(authenRepository: authenRepository);
        },
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authenRepository.logOut()).called(1);
        },
      );
    });
  });
}
