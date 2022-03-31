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
      required UserRepository userRepository})
      : _authenRepository = authenRepository,
        _userRepository = userRepository,
        super(
          authenRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _authenRepository.user.listen(_onUserChanged);
    on<AppUserChanged>(_userChanged);
    on<AppLogoutRequested>(_logout);
    on<AddInfoRequested>(_infoChanged);
    on<EditInfoRequested>(_editInfo);
  }

  final AuthenRepository _authenRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  void _userChanged(AppUserChanged event, Emitter<AppState> emit) async {
    if (event.user.isNotEmpty) {
      if (!event.user.emailVerified!) {
        print('not have verified yet');
        return;
      }
      try {
        final info = await _userRepository.getInfo();
        if (info == null) {
          add(AddInfoRequested(_authenRepository.currentUser));
          return;
        }
        emit(AppState.authenticated(event.user.copyWith(info: info)));
      } catch (_) {
        print('_userChanged error: $_');
      }
    } else {
      emit(AppState.unauthenticated());
    }
  }

  void _logout(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenRepository.logOut());
  }

  void _infoChanged(AddInfoRequested event, Emitter<AppState> emit) {
    emit(AppState.initialize(event.user));
  }

  void _editInfo(EditInfoRequested event, Emitter<AppState> emit) {
    emit(AppState.authenticated(event.user));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
