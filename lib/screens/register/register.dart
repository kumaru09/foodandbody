import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/screens/register/cubit/register_cubit.dart';
import 'package:foodandbody/screens/register/register_form.dart'; 

class Register extends StatelessWidget {
  const Register({ Key? key }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Register());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: BlocProvider<RegisterCubit>(
          create: (_) => RegisterCubit(context.read<AuthenRepository>()),
          child: const RegisterForm(),
        ),
      )
    );
  }
}