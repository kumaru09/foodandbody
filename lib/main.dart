import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodandbody/app/app.dart';
import 'package:foodandbody/app/bloc_observer.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  final authenRepository = AuthenRepository();
  final userRepository = UserRepository(cache: InfoCache());
  await authenRepository.user.first;
  runApp(App(
    authenRepository: authenRepository,
    userRepository: userRepository,
  ));
}
