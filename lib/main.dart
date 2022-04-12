import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodandbody/app/app.dart';
import 'package:foodandbody/app/bloc_observer.dart';
import 'package:foodandbody/models/user.dart' as user;
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/services/arcore_service.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenRepository = AuthenRepository();
  final userRepository = UserRepository(cache: InfoCache());
  final arCoreService = ARCoreService();
  await authenRepository.user.first;
  // await arCoreService.isARCoreSupported();
  // if (arCoreService.isSupportDepth == ARStatus.notinstall) {
  //   Future.delayed(const Duration(milliseconds: 1000), () {
  //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //   });
  // }
  // print(arCoreService.isSupportDepth);
  runApp(App(
    authenRepository: authenRepository,
    userRepository: userRepository,
    arCoreService: arCoreService,
  ));
}
