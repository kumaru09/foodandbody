import 'package:bloc_test/bloc_test.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/models/info.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthenRepository extends Mock implements AuthenRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

class MockInfo extends Mock implements Info {}

void main() {
  group('AppBloc', () {
    final user = MockUser();
    late AuthenRepository authenRepository;
    late UserRepository userRepository;

    setUp(() {
      authenRepository = MockAuthenRepository();
      userRepository = MockUserRepository();
      when(() => authenRepository.user).thenAnswer((_) => Stream<User>.empty());
      when(() => authenRepository.currentUser).thenReturn(User.empty);
    });

    test('initial state is unauthenticated when user is empty', () {
      expect(
        AppBloc(
          authenRepository: authenRepository,
          userRepository: userRepository,
        ).state,
        AppState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not empty and UserInfo is not empty',
        setUp: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => user.emailVerified).thenReturn(true);
          when(() => authenRepository.user)
              .thenAnswer((_) => Stream.value(user));
          when(() => authenRepository.currentUser).thenReturn(user);
        },
        build: () => AppBloc(
          authenRepository: authenRepository,
          userRepository: userRepository,
        ),
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits notverified when user is not empty and emailVerified is false',
        setUp: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => user.emailVerified).thenReturn(false);
          when(() => authenRepository.user)
              .thenAnswer((_) => Stream.value(user));
          when(() => authenRepository.currentUser).thenReturn(user);
        },
        build: () => AppBloc(
          authenRepository: authenRepository,
          userRepository: userRepository,
        ),
        expect: () => [AppState.notverified(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is empty',
        setUp: () => when(() => authenRepository.user)
            .thenAnswer((_) => Stream.value(User.empty)),
        build: () => AppBloc(
          authenRepository: authenRepository,
          userRepository: userRepository,
        ),
        expect: () => [AppState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'call authenRepository logOut',
        build: () => AppBloc(
            authenRepository: authenRepository, userRepository: userRepository),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authenRepository.logOut()).called(1);
        },
      );
    });
  });
}
