part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated, initialize, notverified }

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.initialize(User user)
      : this._(status: AppStatus.initialize, user: user);

  const AppState.notverified(User user)
      : this._(status: AppStatus.notverified, user: user);

  final AppStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
