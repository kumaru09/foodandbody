import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodandbody/app/bloc_observer.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc/bloc.dart';


void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authenRepository = AuthenRepository();
  await authenRepository.user.first;
  runApp(App(authenRepository : authenRepository));
}
