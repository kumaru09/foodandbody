import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/login/cubit/login_cubit.dart';
import 'package:foodandbody/screens/register/register.dart';
import 'package:foodandbody/screens/forgot_password/forgot_password.dart';
import 'package:formz/formz.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
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
                                                .colorScheme.secondary))),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPassword()),
                                  );
                                },
                              ),
                            ]),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                          child: _LoginButton(),
                        ),
                        Text('หรือ',
                            style: Theme.of(context).textTheme.bodyText2!.merge(
                                TextStyle(
                                    color: Theme.of(context).colorScheme.secondary))),
                        Padding(
                            padding: EdgeInsets.fromLTRB(16, 6, 16, 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _FacebookLoginButton(),
                                  _GoogleLoginButton(),
                                ])),
                        TextButton(
                          key: const Key('loginForm_createAccount'),
                          child: Text('ลงทะเบียน',
                              style: Theme.of(context).textTheme.button!.merge(
                                  TextStyle(
                                      color: Theme.of(context).colorScheme.secondary))),
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
            autofocus: true,
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
              : ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                  child: Text('เข้าสู่ระบบ'),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 50.0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                );
        });
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin'),
      label: Text(''),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: Color(0xFFEA4335),
        padding: EdgeInsets.fromLTRB(13, 13, 6, 13),
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () {},
      // onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('loginForm_facebookLogin'),
      label: Text(''),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: Color(0xFF3B5998),
        padding: EdgeInsets.fromLTRB(13, 13, 6, 13),
      ),
      icon: const Icon(FontAwesomeIcons.facebookF, color: Colors.white),
      onPressed: () {},
      // onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}
