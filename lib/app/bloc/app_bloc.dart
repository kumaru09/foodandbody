import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:foodandbody/models/user.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:pedantic/pedantic.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(
      {required AuthenRepository authenRepository,
      required UserRepository userRepository,
      })
      : _authenRepository = authenRepository,
        _userRepository = userRepository,
        super(
          authenRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _authenRepository.user.listen(_onUserChanged);
  }

  final AuthenRepository _authenRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppUserChanged) {
      yield* _mapUserChangedToState(event, state);
    } else if (event is AppLogoutRequested) {
      unawaited(_authenRepository.logOut());
    } else if (event is AddInfoRequested) {
      yield* _mapInfoRequestToState(event, state);
    }
  }

  Stream<AppState> _mapInfoRequestToState(
      AddInfoRequested event, AppState state) async* {
    final user = await _userRepository.getInfo(event.user);
    if (user.info != null) {
      yield AppState.authenticated(user);
    } else {
      yield AppState.initialize(event.user);
    }
  }

  Stream<AppState> _mapUserChangedToState(
      AppUserChanged event, AppState state) async* {
    if (event.user.isNotEmpty) {
      final user = await _userRepository.getInfo(event.user);
      if (user.info != null) {
        yield AppState.authenticated(user);
      } else {
        yield AppState.initialize(event.user);
      }
    } else
      yield const AppState.unauthenticated();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
