import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodandbody/app/app.dart';
import 'package:foodandbody/app/bloc_observer.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/repositories/search_reository.dart';
import 'package:foodandbody/repositories/user_repository.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenRepository = AuthenRepository();
  final userRepository = UserRepository();
  final searchRepository = SearchRepository(SearchCache(), SearchClient());
  await authenRepository.user.first;
  runApp(App(
    authenRepository: authenRepository,
    userRepository: userRepository,
    searchRepository: searchRepository,
  ));
}
