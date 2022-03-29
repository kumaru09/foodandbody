import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodandbody/app/app.dart';
import 'package:foodandbody/app/bloc_observer.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final authenRepository = AuthenRepository();
  final userRepository = UserRepository();
  final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getInitialLink();
  if (data?.link != null) {
    print('get link');
    final Uri deepLink = data!.link;
    final email = Uri.parse(deepLink.queryParameters['continueUrl']!)
        .queryParameters['email'];
    final emailLink = deepLink.toString();
    if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink) &&
        email != null) {
      print('signin: $emailLink');
      try {
        authenRepository.logInWithEmailLink(email, emailLink);
      } catch (_) {
        print('$_');
      }
    }
  }
  FirebaseDynamicLinks.instance.onLink.listen((event) {
    print('get link');
    final Uri deepLink = event.link;
    final email = Uri.parse(deepLink.queryParameters['continueUrl']!)
        .queryParameters['email'];
    final emailLink = deepLink.toString();
    if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink) &&
        email != null) {
      print('signin: $emailLink');
      try {
        authenRepository.logInWithEmailLink(email, emailLink);
      } catch (_) {
        print('$_');
      }
    }
  });
  await authenRepository.user.first;
  runApp(App(
    authenRepository: authenRepository,
    userRepository: userRepository,
  ));
}
