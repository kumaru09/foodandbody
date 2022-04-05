import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/screens/register/cubit/register_cubit.dart';
import 'package:foodandbody/screens/register/verify_email.dart';
import 'package:formz/formz.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pop();
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Register Failure')),
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
                      child: Text('ลงทะเบียน',
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
                          SizedBox(height: 16.0),
                          ConfirmPasswordInput(),
                          SizedBox(height: 16.0),
                          _RegisterButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            key: const Key('registerForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<RegisterCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'อีเมล',
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
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            key: const Key('registerForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<RegisterCubit>().passwordChanged(password),
            decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: OutlineInputBorder(),
                errorText: state.password.invalid ? 'invalid password' : null,
                suffixIcon: InkWell(
                  key: const Key('registerForm_password_visibilityIcon'),
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

class ConfirmPasswordInput extends StatefulWidget {
  @override
  _ConfirmPasswordInputState createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<ConfirmPasswordInput> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.confirmedPassword != current.confirmedPassword,
        builder: (context, state) {
          return TextField(
            key: const Key('registerForm_confirmedPasswordInput_textField'),
            onChanged: (confirmPassword) => context
                .read<RegisterCubit>()
                .confirmedPasswordChanged(confirmPassword),
            decoration: InputDecoration(
                labelText: 'ยืนยันรหัสผ่าน',
                border: OutlineInputBorder(),
                errorText: state.confirmedPassword.invalid
                    ? 'passwords do not match'
                    : null,
                suffixIcon: InkWell(
                  key: const Key('registerForm_confirmPassword_visibilityIcon'),
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

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('registerForm_continue_raisedButton'),
                    onPressed: state.status.isValidated
                        ? () {
                            context
                                .read<RegisterCubit>()
                                .registerFormSubmitted();
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => VerifyEmail()));
                          }
                        : null,
                    child: Text('ลงทะเบียน'),
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
