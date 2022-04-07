import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: VerifyEmail());

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  void initState() {
    handleLink();
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      print('get link');
      final Uri deepLink = event.link;
      print(deepLink);
      final actionCode = deepLink.queryParameters['oobCode'];
      if (actionCode != null) verifedCode(actionCode);
      // final email = Uri.parse(deepLink.queryParameters['continueUrl']!)
      //     .queryParameters['email'];
      // final emailLink = deepLink.toString();
      // if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink) &&
      //     email != null) {
      //   print('signin: $emailLink');
      //   try {
      //     context.read<LoginCubit>().logInWithEmailLink(email, emailLink);
      //   } catch (_) {
      //     print('$_');
      //   }
      // }
    });
    super.initState();
  }

  void handleLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data?.link != null) {
      print('get link');
      final Uri deepLink = data!.link;
      print(deepLink);
      final actionCode = deepLink.queryParameters['oobCode'];
      if (actionCode != null) verifedCode(actionCode);
    }
  }

  void verifedCode(String code) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.checkActionCode(code);
      await auth.applyActionCode(code);

      await auth.currentUser!.reload();
      context.read<AppBloc>().add(
          AppUserChanged(await context.read<AuthenRepository>().user.first));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'expired-action-code' || e.code == 'invalid-action-code') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
                content: Text(
                    'ลิงค์หมดอายุหรือถูกใช้ไปแล้ว โปรดขอลิงค์ใหม่อีกครั้ง')),
          );
      }
    } catch (_) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              content:
                  Text('ลิงค์หมดอายุหรือถูกใช้ไปแล้ว โปรดขอลิงค์ใหม่อีกครั้ง')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image(image: AssetImage('assets/logo.png')),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('ลงทะเบียน',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .merge(TextStyle(color: Colors.white))),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.email,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 120),
                          SizedBox(height: 16.0),
                          Text(
                            '''ระบบได้ส่งข้อความไปที่อีเมลของคุณแล้ว\nกรุณายืนยันตัวตนเพื่อลงทะเบียน''',
                            maxLines: 3,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ArgonTimerButton(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              minWidth: 183,
                              highlightColor: Colors.transparent,
                              highlightElevation: 0,
                              roundLoadingShape: false,
                              onTap: (startTimer, btnState) {
                                if (btnState == ButtonState.Idle) {
                                  context
                                      .read<AuthenRepository>()
                                      .sendVerifyEmail();
                                  startTimer(30);
                                }
                              },
                              child: Text("ส่งอีกครั้ง",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
                              loader: (timeLeft) {
                                return Text(
                                  "รอสักครู่ | $timeLeft",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)),
                                );
                              },
                              borderRadius: 50.0,
                              color: Colors.transparent,
                              elevation: 0,
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 1.5),
                            ),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
