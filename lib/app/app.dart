import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foodandbody/app/bloc/app_bloc.dart';
import 'package:foodandbody/app/routes.dart';
import 'package:foodandbody/repositories/authen_repository.dart';
import 'package:foodandbody/repositories/body_repository.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/repositories/favor_repository.dart';
import 'package:foodandbody/repositories/history_repository.dart';
import 'package:foodandbody/repositories/menu_card_repository.dart';
import 'package:foodandbody/repositories/plan_repository.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:foodandbody/repositories/user_repository.dart';
import 'package:foodandbody/screens/body/cubit/body_cubit.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/plan/bloc/plan_bloc.dart';
import 'package:foodandbody/services/arcore_service.dart';
import 'package:foodandbody/theme.dart';

class App extends StatelessWidget {
  App(
      {Key? key,
      required AuthenRepository authenRepository,
      required UserRepository userRepository,
      required ARCoreService arCoreService,
      PlanRepository? planRepository,
      BodyRepository? bodyRepository})
      : _authenRepository = authenRepository,
        _userRepository = userRepository,
        _arCoreService = arCoreService,
        _planRepository = planRepository ?? PlanRepository(),
        _bodyRepository = bodyRepository ?? BodyRepository(),
        super(key: key);

  final AuthenRepository _authenRepository;
  final UserRepository _userRepository;
  final ARCoreService _arCoreService;
  final PlanRepository _planRepository;
  final BodyRepository _bodyRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenRepository>(
            create: (context) => _authenRepository),
        RepositoryProvider<UserRepository>(
            create: (context) => _userRepository),
        RepositoryProvider<SearchRepository>(
            create: (context) =>
                SearchRepository(SearchCache(), SearchClient())),
        RepositoryProvider<PlanRepository>(
            create: (context) => _planRepository),
        RepositoryProvider<BodyRepository>(
            create: (context) => _bodyRepository),
        RepositoryProvider<FavoriteRepository>(
            create: (context) => FavoriteRepository()),
        RepositoryProvider<MenuCardRepository>(
            create: (context) =>
                MenuCardRepository(MenuCardCache(), MenuCardClient())),
        RepositoryProvider<HistoryRepository>(
            create: (context) => HistoryRepository()),
        RepositoryProvider<CameraRepository>(
            create: (context) => CameraRepository()),
        RepositoryProvider<ARCoreService>(create: (context) => _arCoreService)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AppBloc(
                  authenRepository: _authenRepository,
                  userRepository: _userRepository)),
          BlocProvider(
              create: (_) => CameraBloc(
                  cameraRepository: CameraRepository(),
                  planRepository: _planRepository,
                  bodyRepository: _bodyRepository)),
        ],
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
