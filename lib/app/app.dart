import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/app/routes.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/theme.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenRepository authenRepository,
    required UserRepository userRepository,
  })  : _authenRepository = authenRepository,
        _userRepository = userRepository,
        super(key: key);

  final AuthenRepository _authenRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenRepository>(
            create: (context) => AuthenRepository()),
        RepositoryProvider<UserRepository>(
            create: (context) => UserRepository()),
        RepositoryProvider<SearchRepository>(
            create: (context) =>
                SearchRepository(SearchCache(), SearchClient())),
        RepositoryProvider<PlanRepository>(
            create: (context) => PlanRepository()),
        RepositoryProvider<BodyRepository>(
            create: (context) => BodyRepository()),
        RepositoryProvider<FavoriteRepository>(
            create: (context) => FavoriteRepository()),
        RepositoryProvider<MenuCardRepository>(
            create: (context) => MenuCardRepository())
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenRepository: _authenRepository,
          userRepository: _userRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('th'),
      ],
    );
  }
}
