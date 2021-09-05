import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/login/cubit/login_cubit.dart';
import 'package:foodandbody/screens/login/login_form.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  
  static Page page() => const MaterialPage<void>(child: Login());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthenRepository>()),
          child: const LoginForm(),
        ), 
      )
    );
  }
}
