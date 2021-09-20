import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/initial_info/cubit/initial_info_cubit.dart';
import 'package:foodandbody/screens/initial_info/initial_info_form.dart';

class InitialInfo extends StatelessWidget {
  const InitialInfo ({ Key? key }) : super(key: key);

  static Page page() => const MaterialPage<void>(child: InitialInfo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: BlocProvider<InitialInfoCubit>( 
          create: (_) => InitialInfoCubit(context.read<UserRepository>()),
          child: const InitialInfoForm(),
        ),
      )
    );
  }
}