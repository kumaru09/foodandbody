import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodandbody/app/app.dart';
import 'package:foodandbody/app/bloc_observer.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/services/arcore_service.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenRepository = AuthenRepository();
  final userRepository = UserRepository();
  // final arCoreService = ARCoreService();
  await authenRepository.user.first;
  // await arCoreService.isARCoreSupported();
  runApp(App(
    authenRepository: authenRepository,
    userRepository: userRepository,
  ));
}
