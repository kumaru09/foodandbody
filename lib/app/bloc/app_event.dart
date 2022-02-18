part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AddInfoRequested extends AppEvent {
  const AddInfoRequested(this.user);

  final User user;
  @override
  List<Object> get props => [];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class EditInfoRequested extends AppEvent {
  const EditInfoRequested(this.user);

  final User user;
  @override
  List<Object> get props => [];
}
