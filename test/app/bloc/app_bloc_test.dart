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
    final info = MockInfo();
    late AuthenRepository authenRepository;
    late UserRepository userRepository;

    setUp(() {
      authenRepository = MockAuthenRepository();
      userRepository = MockUserRepository();
      when(() => authenRepository.user).thenAnswer(
        (_) => Stream<User>.empty(),
      );
      when(
        () => authenRepository.currentUser,
      ).thenReturn(User.empty);
      when(() => user.info).thenReturn(null);
    });

    test('initial state is unauthenticated when user is empty', () {
      expect(
        AppBloc(
                authenRepository: authenRepository,
                userRepository: userRepository)
            .state,
        AppState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not empty and UserInfo is not empty',
        build: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => authenRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
          when(() => user.info).thenReturn(info);
          when(() => userRepository.getInfo(user))
              .thenAnswer((_) => Future(() => user));
          return AppBloc(
              authenRepository: authenRepository,
              userRepository: userRepository);
        },
        seed: () => AppState.unauthenticated(),
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emit initialize when user is not empty and userInfo is null',
        build: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => authenRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
          when(() => userRepository.getInfo(user))
              .thenAnswer((_) => Future(() => user));
          return AppBloc(
              authenRepository: authenRepository,
              userRepository: userRepository);
        },
        // seed: () => AppState.authenticated(user),
        expect: () => [AppState.initialize(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is empty',
        build: () {
          when(() => authenRepository.user).thenAnswer(
            (_) => Stream.value(User.empty),
          );
          return AppBloc(
              authenRepository: authenRepository,
              userRepository: userRepository);
        },
        expect: () => [AppState.unauthenticated()],
      );
    });
    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        build: () {
          return AppBloc(
              authenRepository: authenRepository,
              userRepository: userRepository);
        },
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authenRepository.logOut()).called(1);
        },
      );
    });
  });
}
