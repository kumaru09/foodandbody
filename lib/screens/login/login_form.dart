import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:foodandbody/screens/login/cubit/login_cubit.dart';
import 'package:foodandbody/screens/register/register.dart';
import 'package:foodandbody/screens/forgot_password/forgot_password.dart';
import 'package:formz/formz.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // @override
  // void initState() {
  //   handleLink();
  //   FirebaseDynamicLinks.instance.onLink.listen((event) {
  //     print('get link');
  //     final Uri deepLink = event.link;
  //     final actionCode = deepLink.queryParameters['oobCode'];
  //     if (actionCode != null) verifedCode(actionCode);
  //     // final email = Uri.parse(deepLink.queryParameters['continueUrl']!)
  //     //     .queryParameters['email'];
  //     // final emailLink = deepLink.toString();
  //     // if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink) &&
  //     //     email != null) {
  //     //   print('signin: $emailLink');
  //     //   try {
  //     //     context.read<LoginCubit>().logInWithEmailLink(email, emailLink);
  //     //   } catch (_) {
  //     //     print('$_');
  //     //   }
  //     // }
  //   });
  //   super.initState();
  // }

  // void handleLink() async {
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (data?.link != null) {
  //     print('get link');
  //     final Uri deepLink = data!.link;
  //     final actionCode = deepLink.queryParameters['oobCode'];
  //     if (actionCode != null) verifedCode(actionCode);
  //   }
  // }

  // void verifedCode(String code) async {
  //   final auth = FirebaseAuth.instance;
  //   try {
  //     await auth.checkActionCode(code);
  //     await auth.applyActionCode(code);

  //     auth.currentUser!.reload();
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'expired-action-code' || e.code == 'invalid-action-code') {
  //       ScaffoldMessenger.of(context)
  //         ..hideCurrentSnackBar()
  //         ..showSnackBar(
  //           SnackBar(
  //               content: Text(
  //                   'ลิงค์หมดอายุหรือถูกใช้ไปแล้ว โปรดขอลิงค์ใหม่อีกครั้ง')),
  //         );
  //     }
  //   } catch (_) {
  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(
  //         SnackBar(
  //             content:
  //                 Text('ลิงค์หมดอายุหรือถูกใช้ไปแล้ว โปรดขอลิงค์ใหม่อีกครั้ง')),
  //       );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          // print(state.errorMessage);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(
                      '${state.errorMessage ?? 'ดำเนินการไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'}')),
            );
        }
      },
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
                    child: Text('เข้าสู่ระบบ',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .merge(TextStyle(color: Colors.white)))),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        _EmailInput(),
                        SizedBox(height: 16.0),
                        PasswordInput(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                key: const Key('loginForm_forgotPassword'),
                                child: Text('ลืมรหัสผ่าน?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button!
                                        .merge(TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary))),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                            create: (context) =>
                                                ForgotPasswordCubit(context
                                                    .read<AuthenRepository>()),
                                            child: ForgotPassword())),
                                  );
                                },
                              ),
                            ]),
                        _LoginButton(),
                        Text('หรือ',
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))),
                        _GoogleLoginButton(),
                        _FacebookLoginButton(),
                        SizedBox(height: 10.0),
                        TextButton(
                          key: const Key('loginForm_createAccount'),
                          child: Text('ลงทะเบียน',
                              style: Theme.of(context).textTheme.button!.merge(
                                  TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              // hintText: 'ชื่อผู้ใช้งาน',
              labelText: 'ชื่อผู้ใช้งาน',
              border: OutlineInputBorder(borderSide: BorderSide()),
              errorText: state.email.invalid ? 'invalid email' : null,
            ),
          );
        });
  }
}

class PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: OutlineInputBorder(),
                errorText: state.password.invalid ? 'invalid password' : null,
                suffixIcon: InkWell(
                  key: const Key('loginForm_visibilityIcon'),
                  onTap: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                  child:
                      Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
                )),
            obscureText: _isHidden,
          );
        });
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('loginForm_continue_raisedButton'),
                    onPressed: state.status.isValidated
                        ? () =>
                            context.read<LoginCubit>().logInWithCredentials()
                        : null,
                    child: Text('เข้าสู่ระบบ'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 10.0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                );
        });
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        key: const Key('loginForm_googleLogin'),
        label: Text(
          'LOGIN WITH GOOGLE',
          style: Theme.of(context)
              .textTheme
              .button!
              .merge(TextStyle(color: Colors.white)),
        ),
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          primary: Color(0xFFEA4335),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        ),
        icon: const Icon(FontAwesomeIcons.google,
            size: 21.0, color: Colors.white),
        onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      ),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        key: const Key('loginForm_facebookLogin'),
        label: Text(
          'LOGIN WITH FACEBOOK',
          style: Theme.of(context)
              .textTheme
              .button!
              .merge(TextStyle(color: Colors.white)),
        ),
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          primary: Color(0xFF3B5998),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        ),
        icon: const Icon(Icons.facebook, color: Colors.white),
        onPressed: () => context.read<LoginCubit>().logInWithFacebook(),
      ),
    );
  }
}
