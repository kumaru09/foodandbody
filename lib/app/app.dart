import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/app/routes.dart';
import 'package:foodandbody/repositories/authen_repository.dart';

class App extends StatelessWidget {
  const App({ Key? key, required AuthenRepository authenRepository })
    : _authenRepository = authenRepository,
      super(key: key);
  
  final AuthenRepository _authenRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenRepository: _authenRepository
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}