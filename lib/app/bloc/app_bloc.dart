import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/user.dart';
import 'package:pedantic/pedantic.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenRepository authenRepository})
    : _authenRepository = authenRepository,
      super(
        authenRepository.currentUser.isNotEmpty
          ? AppState.authenticated(authenRepository.currentUser)
          : const AppState.unauthenticated(),
      ) {
        _userSubscription = _authenRepository.user.listen(_onUserChanged);
      }
    
  final AuthenRepository _authenRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppUserChanged) {
      yield _mapUserChangedToState(event, state);
    } else if (event is AppLogoutRequested) {
      unawaited(_authenRepository.logOut());
    }
  }

  AppState _mapUserChangedToState(AppUserChanged event, AppState state) {
    return event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}